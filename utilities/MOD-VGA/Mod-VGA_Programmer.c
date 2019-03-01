/// ######################################################################################
/// 
///  Mod-VGA_Programmer.c
///
///  Author: hjups22 (hjups22@gmail.com)
///  Purpose: Implement an SPI based programmer which uses the FTDI 232H USB to SPI chip, in order to
///				program the AT45DB041D SPI Flash PROM used to store the FPGA configuration on the 
///				Omlex MOD-VGA Gameduino board.
///
///  This file is based off of the sample-static.c provided by FTDI in their libMPSSE_SPI library.
///
///	 Usage: To modify the filenames for writing / dumping the PROM, as well as to change the 
///			 read / write behavior, simply modify the parameters in the section below and 
///			 recompile.
///
/// Rivision History :
/// 0.1 - 2019/02/28 - Initial version
/// 0.2 - 2019/03/01 - Cleaned up the initial code
///
/// ######################################################################################

 /******************************************************************************/
 /* 							 Parameters										   */
 /******************************************************************************/
#define DUMP_FILE_NAME "ROM_Dump.hex"
#define WRITE_FILE_NAME "GD_Mod1.hex"
#define WRITE_ROM 1
#define DUMP_ROM 0 


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

/// <summar> Function to read the Flash PROM Manufacturer ID </summary>
/// <returns> Byte of the manufacturer ID </summary>
///
uint8 ReadMID()
{
	uint32 sizeToTransfer = 0;
	uint32 sizeTransfered = 0;
	uint8 writeComplete = 0;
	uint32 retry = 0;
	FT_STATUS status;


	// Formulate the command string
	sizeToTransfer = 7;
	sizeTransfered = 0;
	uint8 inBuffer[100];
	uint8 outBuffer[3];
	outBuffer[0] = 0x9F; // read from MID register op code

	status = SPI_ReadWrite(ftHandle, inBuffer, outBuffer, sizeToTransfer, &sizeTransfered,
		SPI_TRANSFER_OPTIONS_SIZE_IN_BYTES |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_ENABLE |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_DISABLE);


	printf("Device ID: %02X %02X\n", inBuffer[1], inBuffer[2]);
	return inBuffer[2];

}

/// <summar> Function to read the Flash PROM Status register </summary>
/// <returns> The Flash PROM status register </summary>
///
uint8 ReadStatusReg()
{
	uint32 sizeToTransfer = 0;
	uint32 sizeTransfered = 0;
	uint8 writeComplete = 0;
	uint32 retry = 0;
	FT_STATUS status;

	// Formulate the command string
	sizeToTransfer = 2;
	sizeTransfered = 0;
	uint8 inBuffer[3];
	uint8 outBuffer[3];
	outBuffer[0] = 0xD7; // read from status register op code

	status = SPI_ReadWrite(ftHandle, inBuffer, outBuffer, sizeToTransfer, &sizeTransfered,
		SPI_TRANSFER_OPTIONS_SIZE_IN_BYTES |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_ENABLE |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_DISABLE);

	return inBuffer[1];
}

/// <summar> Function to read a 256 byte page and dump the hexidecimal value to a file </summary>
/// <param name='page'> The page address to read </param>
/// <param name='pfile'> The FILE pointer to dump the ASCII to </param>
///
void ReadPage256(int page, FILE* pfile)
{
	uint32 sizeToTransfer = 0;
	uint32 sizeTransfered = 0;
	uint8 writeComplete = 0;
	uint32 retry = 0;
	FT_STATUS status;

	// read the status register and spin on busy
	uint8 statusReg = 0x80;
	do {
		statusReg = ReadStatusReg();
		printf("Checking Status register for Addr: %06X\n", page);
	} while ((statusReg & 0x80) == 0);


	// formualte the command string
	sizeToTransfer = 260; // 256 + 4
	sizeTransfered = 0;
	uint8 inBuffer[260];
	uint8 outBuffer[260];
	outBuffer[0] = 0x03;				   // read from page op code
	outBuffer[1] = (page & 0x70000) >> 16; // address byte 2
	outBuffer[2] = (page & 0xFF00) >> 8;   // address byte 1
	outBuffer[3] = page & 0xFF;            // address byte 0


	status = SPI_ReadWrite(ftHandle, inBuffer, outBuffer, sizeToTransfer, &sizeTransfered,
		SPI_TRANSFER_OPTIONS_SIZE_IN_BYTES |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_ENABLE |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_DISABLE);

	// dump the page values to the given file
	for (int k = 4; k < 260; k++) // the first 4 bytes are don't care
	{
		fprintf(pfile,"%02x", inBuffer[k]);
	}

}


/// <summar> Function to read a 264 byte page and dump the hexidecimal value to a file </summary>
/// <param name='page'> The page address to read </param>
/// <param name='offset'> The offset within the page to start at </param>
/// <param name='pfile'> The FILE pointer to dump the ASCII to </param>
///
void ReadPage264(int page, int offset, FILE* pfile)
{
	uint32 sizeToTransfer = 0;
	uint32 sizeTransfered = 0;
	uint8 writeComplete = 0;
	uint32 retry = 0;
	FT_STATUS status;

	// combine the page and offset values
	page = (page & 0x7FF) << 9;
	offset = (offset & 0x1FFF);
	page = page | offset;

	// read the status register and spin on busy
	uint8 statusReg = 0x80;
	do {
		statusReg = ReadStatusReg();
		printf("Checking Status register for Addr: %06X %02X\n", page, statusReg);
	} while ((statusReg & 0x80) == 0);

	// formualte the command string
	sizeToTransfer = 268-offset; // 264 + 4 - offset
	sizeTransfered = 0;
	uint8 inBuffer[268];
	uint8 outBuffer[268];
	outBuffer[0] = 0x03;		// read page op code
	outBuffer[1] = (page & 0x70000) >> 16; // address byte 2
	outBuffer[2] = (page & 0xFF00) >> 8;   // address byte 1
	outBuffer[3] = page & 0xFF;            // address byte 0


	status = SPI_ReadWrite(ftHandle, inBuffer, outBuffer, sizeToTransfer, &sizeTransfered,
		SPI_TRANSFER_OPTIONS_SIZE_IN_BYTES |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_ENABLE |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_DISABLE);

	// dump the hex data to the file
	for (int k = 4; k < 268-offset; k++) // the first 4 bytes are don't care
	{
		fprintf(pfile, "%02x", inBuffer[k]);
	}

}
/// <summar> Function to convert an ASCII character input into the corresponding hex value </summary>
/// <param name='c'> The ASCII character to translate </param>
/// <returns> The translated hexidecimal value, returns 0 for non-hex characters </returns>
///
uint8 CtoHex(char c)
{
	switch (c)
	{
	case '0':
		return 0x0;
	case '1':
		return 0x1;
	case '2':
		return 0x2;
	case '3':
		return 0x3;
	case '4':
		return 0x4;
	case '5':
		return 0x5;
	case '6':
		return 0x6;
	case '7':
		return 0x7;
	case '8':
		return 0x8;
	case '9':
		return 0x9;
	case 'A':
	case 'a':
		return 0xA;
	case 'B':
	case 'b':
		return 0xB;
	case 'C':
	case 'c':
		return 0xC;
	case 'D':
	case 'd':
		return 0xD;
	case 'E':
	case 'e':
		return 0xE;
	case 'F':
	case 'f':
		return 0xF;
	default:
		printf("Not a hex char %0X\n", c);
		return 0;
	}
}


/// <summar> Function to write a 264 byte page from a file to the Flash PROM </summary>
/// <param name='page'> The page address to read </param>
/// <param name='pfile'> The FILE pointer to read the Hex ASCII from </param>
///
void WritePage264(int page, FILE* pfile)
{
	uint32 sizeToTransfer = 0;
	uint32 sizeTransfered = 0;
	uint8 writeComplete = 0;
	uint32 retry = 0;
	FT_STATUS status;
	uint8 outBuffer[268];

	// formulate the memory buffer write string
	sizeToTransfer = 4;
	sizeTransfered = 0;
	outBuffer[0] = 0x84; // write to Buffer 1 op-code
	outBuffer[1] = 0; // 3 don't care address bytes
	outBuffer[2] = 0; // set to zero for offset
	outBuffer[3] = 0; // set to zero for offset

	// read the 264 bytes (264*2 ASCII hex characters) and store it in the output buffer
	int rv;
	unsigned char val = 0;
	int num = 0;
	for (int i = 0; i < 264; i++)
	{
		// get the first nybble
		char val1 = fgetc(pfile);
		// get the second nybble
		char val2 = fgetc(pfile);

		// break on EOF, newline, and carriage return character
		if ((val1 == -1) || (val1 == '\n') || (val1 == '\r'))
			break;

		// convert the two nybbles to hex
		val1 = CtoHex(val1);
		val2 = CtoHex(val2);

		// combine the nybbles
		val = (val1 << 4) | val2;

		outBuffer[4 + i] = val;

		// check for end of file
		if (feof(pfile) )
		{
			break;
		}
		else
		{
			// if we got here, then we successfully stored the value in the outbuffer, and can increment the count
			num = num + 1;
		}
	}
	
	// set the extra buffer characters to zero for writing / clearing
	for (int i = num; i < 264; i++)
	{
		outBuffer[4 + i] = 0;
	}

	// set the transfer size to 264 + 4
	sizeToTransfer = 268;

	status = SPI_Write(ftHandle, outBuffer, sizeToTransfer, &sizeTransfered,
		SPI_TRANSFER_OPTIONS_SIZE_IN_BYTES |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_ENABLE |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_DISABLE);
	APP_CHECK_STATUS(status);

	// calculate the page bytes
	page = (page & 0x7FF) << 9;

	// set up the write memory buffer to ROM command
	buffer[0] = 0x83; // buffer 1 + erase op-code
	buffer[1] = (page & 0x70000) >> 16; // address byte 2
	buffer[2] = (page & 0xFF00) >> 8;   // address byte 1
	buffer[3] = page & 0xFF;            // address byte 0

	// spin on status register to make sure the device is ready
	uint8 statusReg = 0x80;
	do {
		statusReg = ReadStatusReg();
		printf("Checking Status register for before Write for Addr: %06X %02X\n", page, statusReg);
	} while ((statusReg & 0x80) == 0);

	// submit the write memory to ROM command
	sizeToTransfer = 4;

	status = SPI_Write(ftHandle, buffer, sizeToTransfer, &sizeTransfered,
		SPI_TRANSFER_OPTIONS_SIZE_IN_BYTES |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_ENABLE |
		SPI_TRANSFER_OPTIONS_CHIPSELECT_DISABLE);
	APP_CHECK_STATUS(status);

	// spin on status register to make sure the device is ready
	statusReg = 0x80;
	do {
		statusReg = ReadStatusReg();
		printf("Checking Status register for after Write for Addr: %06X %02X\n", page, statusReg);
	} while ((statusReg & 0x80) == 0);

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
	
	// Configure the SPI protocol
	channelConf.ClockRate = 4500000;
	channelConf.LatencyTimer = latency;
	channelConf.configOptions = SPI_CONFIG_OPTION_MODE0 | SPI_CONFIG_OPTION_CS_DBUS3 | SPI_CONFIG_OPTION_CS_ACTIVELOW;
	channelConf.Pin = 0x00000000;/*FinalVal-FinalDir-InitVal-InitDir (for dir 0=in, 1=out)*/

	// init the library
#ifdef _MSC_VER
	Init_libMPSSE();
#endif
	status = SPI_GetNumChannels(&channels);
	APP_CHECK_STATUS(status);
	printf("Number of available SPI channels = %d\n",(int)channels);

	if (channels > 0)
	{
		for (i = 0; i < channels; i++)
		{
			status = SPI_GetChannelInfo(i, &devList);
			APP_CHECK_STATUS(status);
			printf("Information on channel number %d:\n", i);
			/* print the dev info */
			printf("		Flags=0x%x\n", devList.Flags);
			printf("		Type=0x%x\n", devList.Type);
			printf("		ID=0x%x\n", devList.ID);
			printf("		LocId=0x%x\n", devList.LocId);
			printf("		SerialNumber=%s\n", devList.SerialNumber);
			printf("		Description=%s\n", devList.Description);
			printf("		ftHandle=0x%x\n", (unsigned int)devList.ftHandle);/*is 0 unless open*/
		}

		/* Open the first available channel */
		status = SPI_OpenChannel(CHANNEL_TO_OPEN, &ftHandle);
		APP_CHECK_STATUS(status);
		printf("\nhandle=0x%x status=0x%x\n", (unsigned int)ftHandle, status);
		status = SPI_InitChannel(ftHandle, &channelConf);
		APP_CHECK_STATUS(status);

		// Read the manufacturer ID
		ReadMID();

		// read the status register
		uint8 statusReg = ReadStatusReg();
		printf("Status Register: %02X\n", statusReg);

		// check for power of 2 addressing mode
		bool usingPow2 = statusReg & 0x01;

		if (DUMP_ROM)
		{
			// perform a ROM Hex Dump to the file specified
			FILE* pfile = fopen(DUMP_FILE_NAME, "w");
			for (int i = 0; i < 2048; i++)
			{
				if (usingPow2)
					ReadPage256(i, pfile);
				else
					ReadPage264(i, 0, pfile);
			}
			fclose(pfile);
		}
		
		if (WRITE_ROM)
		{
			// perform a ROM Hex Write via the file specified
			FILE* pfile = fopen(WRITE_FILE_NAME, "r");
			for (int i = 0; i < 2048; i++)
			{
				WritePage264(i, pfile);
				if (feof(pfile))
					break;
			}
			fclose(pfile);
		}


		// cloe the SPI channel
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

