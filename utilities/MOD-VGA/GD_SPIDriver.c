/// ######################################################################################
/// 
///  GD_SPIDriver.c
///
///  Author: hjups22 (hjups22@gmail.com)
///  Purpose: Implement a test SPI driver program to test / modify / drive a Gameduino implementation
///				via a FTDI 232H USB to SPI chip. 
///
///  This file is based off of the sample-static.c provided by FTDI in their libMPSSE_SPI library.
///
///
/// Rivision History :
/// 0.1 - 2019/02/28 - Initial version
/// 0.2 - 2019/03/01 - Cleaned up the initial code
///
/// ######################################################################################

/******************************************************************************/
/* 							 Include files										   */
/******************************************************************************/
#define _CRT_SECURE_NO_DEPRECATE
/* Standard C libraries */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
/* OS specific libraries */
#ifdef _WIN32
#include<windows.h>
#endif

/* Include D2XX header*/
#include "ftd2xx.h"

/* Include libMPSSE header */
#include "libMPSSE_spi.h"

/******************************************************************************/
/*								Macro and type defines							   */
/******************************************************************************/
/* Helper macros */

#define APP_CHECK_STATUS(exp) {if(exp!=FT_OK){printf("%s:%d:%s(): status(0x%x) \
!= FT_OK\n",__FILE__, __LINE__, __FUNCTION__,exp);exit(1);}else{;}};
#define CHECK_NULL(exp){if(exp==NULL){printf("%s:%d:%s():  NULL expression \
encountered \n",__FILE__, __LINE__, __FUNCTION__);exit(1);}else{;}};

/* Application specific macro definations */
#define SPI_DEVICE_BUFFER_SIZE		256
#define SPI_WRITE_COMPLETION_RETRY		10
#define START_ADDRESS_EEPROM 	0x00 /*read/write start address inside the EEPROM*/
#define END_ADDRESS_EEPROM		0x10
#define RETRY_COUNT_EEPROM		10	/* number of retries if read/write fails */
#define CHANNEL_TO_OPEN			0	/*0 for first available channel, 1 for next... */
#define SPI_SLAVE_0				0
#define SPI_SLAVE_1				1
#define SPI_SLAVE_2				2
#define DATA_OFFSET				4
#define USE_WRITEREAD			0

/******************************************************************************/
/*								Global variables							  	    */
/******************************************************************************/
static FT_HANDLE ftHandle;
static uint8 buffer[SPI_DEVICE_BUFFER_SIZE] = {0};

/******************************************************************************/
/*						Public function definitions						  		   */
/******************************************************************************/

// Function to write to an Gameduino registers
void WriteToReg(int addr, uint8 val)
{
	uint32 sizeToTransfer = 0;
	uint32 sizeTransfered = 0;
	uint8 writeComplete = 0;
	uint32 retry = 0;
	FT_STATUS status;

	// set the MSB to one to enable writing
	addr = addr | 0x8000;

	// formulate the transfer size
	sizeToTransfer = 3;
	sizeTransfered = 0;
	buffer[0] = (addr&0xFF00)>>8; // high byte
	buffer[1] = addr&0xFF;		  // low byte
	buffer[2] = val;			  // value
	status = SPI_Write(ftHandle, buffer, sizeToTransfer, &sizeTransfered,
		SPI_TRANSFER_OPTIONS_SIZE_IN_BYTES |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_ENABLE |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_DISABLE);
	APP_CHECK_STATUS(status);

}

// Function to read from a Gameduino registers
uint8 ReadFromReg(int addr)
{
	uint32 sizeToTransfer = 0;
	uint32 sizeTransfered = 0;
	uint8 writeComplete = 0;
	uint32 retry = 0;
	FT_STATUS status;

	// set the MSB to zero to prevent writing
	addr = addr & 0x7FFF;

	sizeToTransfer = 3;
	sizeTransfered = 0;
	uint8 inBuffer[100];
	uint8 outBuffer[3];
	outBuffer[0] = (addr & 0xFF00) >> 8; // high byte
	outBuffer[1] = addr & 0xFF;			 // low byte
	outBuffer[2] = 0;					 // write one don't care byte for reading

	status = SPI_ReadWrite(ftHandle, inBuffer, outBuffer, sizeToTransfer, &sizeTransfered,
		SPI_TRANSFER_OPTIONS_SIZE_IN_BYTES |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_ENABLE |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_DISABLE);

	// the third byte is the one we want
	return inBuffer[2];
}


int main()
{
	FT_STATUS status = FT_OK;
	FT_DEVICE_LIST_INFO_NODE devList = {0};
	ChannelConfig channelConf = {0};
	uint8 address = 0;
	uint32 channels = 0;
	uint16 data = 0;
	uint8 i = 0;
	uint8 latency = 1;
	
	// setup the SPI connection
	channelConf.ClockRate = 4500000;
	channelConf.LatencyTimer = latency;
	channelConf.configOptions = SPI_CONFIG_OPTION_MODE0 | SPI_CONFIG_OPTION_CS_DBUS3 | SPI_CONFIG_OPTION_CS_ACTIVELOW;
	channelConf.Pin = 0x00000000;/*FinalVal-FinalDir-InitVal-InitDir (for dir 0=in, 1=out)*/

	/* init library */
#ifdef _MSC_VER
	Init_libMPSSE();
#endif
	status = SPI_GetNumChannels(&channels);
	APP_CHECK_STATUS(status);
	printf("Number of available SPI channels = %d\n",(int)channels);

	if(channels>0)
	{
		for(i=0;i<channels;i++)
		{
			status = SPI_GetChannelInfo(i,&devList);
			APP_CHECK_STATUS(status);
			printf("Information on channel number %d:\n",i);
			/* print the dev info */
			printf("		Flags=0x%x\n",devList.Flags);
			printf("		Type=0x%x\n",devList.Type);
			printf("		ID=0x%x\n",devList.ID);
			printf("		LocId=0x%x\n",devList.LocId);
			printf("		SerialNumber=%s\n",devList.SerialNumber);
			printf("		Description=%s\n",devList.Description);
			printf("		ftHandle=0x%x\n",(unsigned int)devList.ftHandle);/*is 0 unless open*/
		}

		/* Open the first available channel */
		status = SPI_OpenChannel(CHANNEL_TO_OPEN,&ftHandle);
		APP_CHECK_STATUS(status);
		printf("\nhandle=0x%x status=0x%x\n",(unsigned int)ftHandle,status);
		status = SPI_InitChannel(ftHandle,&channelConf);
		APP_CHECK_STATUS(status);
		
		// attempt to read from the revision register
		uint8 ident = ReadFromReg(0x2800);
		uint8 rev = ReadFromReg(0x2801);
		printf("Ident: %X Revision: %X\n", ident, rev);

		// disable sprites
		WriteToReg(0x280A, 1);

		// set the background color
		int r5 = 0xFF;
		int g5 = 0;
		int b5 = 0xFF;

		r5 = r5 & 0x1F;
		g5 = g5 & 0x1F;
		b5 = b5 & 0x1F;

		int color = (r5 << 10) | (g5 << 5) | b5;
		WriteToReg(0x280F, (color >> 8) & 0xFF);
		WriteToReg(0x280E, color & 0xFF);

		// cleanup the SPI channel
		status = SPI_CloseChannel(ftHandle);
	}

#ifdef _MSC_VER
	Cleanup_libMPSSE();
#endif

#ifndef __linux__
	system("pause");
#endif
	return 0;
}

