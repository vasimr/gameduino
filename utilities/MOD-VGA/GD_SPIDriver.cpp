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
#include <conio.h>
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
class Color
{
	union ColorType
	{
		uint16 value;
		struct
		{
			uint16 b : 5;	///< Blue Value 5-bits
			uint16 g : 5;	///< Green Value 5-bits
			uint16 r : 5;	///< Red Value 5-bits
			uint16 a : 1;	///< The Alpha Value
		} cValue;
	};
public:
	Color(uint8 a, uint8 r, uint8 g, uint8 b)
	{
		m_Color.cValue.a = a;
		m_Color.cValue.r = r;
		m_Color.cValue.g = g;
		m_Color.cValue.b = b;
	}
	Color()
	{
		m_Color.value = 0;
	}

	uint16 Get()
	{
		return m_Color.value;
	}
private:
	ColorType m_Color;
};

// define a helper macro for colors
#define _C(a,r,g,b) Color(a,r,g,b)

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

void SetColor(uint32 address, uint8 r, uint8 g, uint8 b, uint8 a)
{
	uint32 r5 = r & 0x1F;
	uint32 g5 = g & 0x1F;
	uint32 b5 = b & 0x1F;

	int color = (r5 << 10) | (g5 << 5) | b5;
	color = (a == 0) ? color : color | 0x8000;
	WriteToReg(address+1, (color >> 8) & 0xFF);
	WriteToReg(address, color & 0xFF);
}

void SetColor(uint32 address, Color c)
{
	WriteToReg(address + 1, (c.Get() >> 8) & 0xFF);
	WriteToReg(address, c.Get() & 0xFF);
}

void WriteCharacter(int addr, const char* data)
{

	for (int y = 0; y < 8; y++)
	{
		for (int xv = 0; xv < 2; xv++)
		{
			int p0 = data[y * 8 + xv * 4];
			int p1 = data[y * 8 + xv * 4 + 1];
			int p2 = data[y * 8 + xv * 4 + 2];
			int p3 = data[y * 8 + xv * 4 + 3];

			p0 = p0 & 0x03;
			p1 = p1 & 0x03;
			p2 = p2 & 0x03;
			p3 = p3 & 0x03;

			int bval = (p0 << 6) | (p1 << 4) | (p2 << 2) | p3;
			WriteToReg(addr + y*2 + xv, bval);
		}
	}

}

void WriteCharacterByIndex(int index, const char* data)
{
	int addr = 0x1000 + index * 16;
	WriteCharacter(addr, data);
}

void SetPalette4(int addr, Color c0, Color c1, Color c2, Color c3)
{
	WriteToReg(addr + 1, (c0.Get() >> 8) & 0xFF);
	WriteToReg(addr, c0.Get() & 0xFF);
	WriteToReg(addr +2 + 1, (c1.Get() >> 8) & 0xFF);
	WriteToReg(addr +2, c1.Get() & 0xFF);
	WriteToReg(addr +4 + 1, (c2.Get() >> 8) & 0xFF);
	WriteToReg(addr +4, c2.Get() & 0xFF);
	WriteToReg(addr +6 + 1, (c3.Get() >> 8) & 0xFF);
	WriteToReg(addr +6, c3.Get() & 0xFF);
}

void SetCharPaletteByIndex(int index, Color c0, Color c1, Color c2, Color c3)
{
	int addr = 0x2000 + index * 8;
	SetPalette4( addr,  c0,  c1,  c2,  c3);
}

void SetScreenCharacter(int x, int y, int index)
{
	int addr = 0 + y * 64 + x;
	WriteToReg(addr, index&0xFF);
}

const char CHAR_BAR[] = {
3, 3, 2, 2, 1, 1, 0, 0,
3, 3, 2, 2, 1, 1, 0, 0,
3, 3, 2, 2, 1, 1, 0, 0,
3, 3, 2, 2, 1, 1, 0, 0,
3, 3, 2, 2, 1, 1, 0, 0,
3, 3, 2, 2, 1, 1, 0, 0,
3, 3, 2, 2, 1, 1, 0, 0,
3, 3, 2, 2, 1, 1, 0, 0
};

void WriteScrollReg(int scrollX, int scrollY)
{
	scrollX = scrollX & 0x1FF;
	scrollY = scrollY & 0x1FF;
	WriteToReg(0x2804, scrollX & 0xFF);
	WriteToReg(0x2805, (scrollX >> 8) & 0xFF);
	WriteToReg(0x2806, scrollY & 0xFF);
	WriteToReg(0x2807, (scrollY >> 8) & 0xFF);

}

void WriteBars()
{

	// can only do 10 lines due to the character limit
	for (int g = 0; g < 10; g++)
	{
		for (int r = 0; r < 8; r++)
		{
			WriteCharacterByIndex(r + g * 24, CHAR_BAR);
			SetCharPaletteByIndex(r + g*24,
				_C(0, r * 4 + 4, g*2, 0),
				_C(0, r * 4 + 3, g*2, 0),
				_C(0, r * 4 + 2, g*2, 0),
				_C(0, r * 4 + 1, g*2, 0)
			);
			SetScreenCharacter(r, g, r + g * 24);
		}
	}

	for (int b = 0; b < 10; b++)
	{
		for (int g = 0; g < 8; g++)
		{
			WriteCharacterByIndex(g + 8 + b*24, CHAR_BAR);
			SetCharPaletteByIndex(g + 8 + b*24,
				_C(0, 0, g * 4 + 4, b*2),
				_C(0, 0, g * 4 + 3, b * 2),
				_C(0, 0, g * 4 + 2, b * 2),
				_C(0, 0, g * 4 + 1, b * 2)
			);
			SetScreenCharacter(g + 8, b, g + 8 + b*24);
		}
	}

	for (int r = 0; r < 10; r++)
	{
		for (int b = 0; b < 8; b++)
		{
			WriteCharacterByIndex(b + 16 + r*24, CHAR_BAR);
			SetCharPaletteByIndex(b + 16 + r * 24,
				_C(0, r*2, 0, b * 4 + 4),
				_C(0, r * 2, 0, b * 4 + 3),
				_C(0, r * 2, 0, b * 4 + 2),
				_C(0, r * 2, 0, b * 4 + 1)
			);
			SetScreenCharacter(b + 16, r, b + 16 + r * 24);
		}
	}
}

void TypeAscii()
{
	char c = 0;
	int x = 0;
	int y = 0;
	while (c != '`')
	{
		c = _getch();
		if (c == '\r')
		{
			y++;
			x = 0;
		}
		else if (c == 8)
		{
			x--;
		}
		else
		{
			SetScreenCharacter(x, y, c);
			x++;
		}
	}

	// clear the screen
	for (int xx = 0; xx < 64; xx++)
	{
		for(int yy = 0; yy < 64; yy++)
			SetScreenCharacter(xx, yy, 0);
	}
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
		//SetColor(0x280E, _C(1, 0xFF, 0xFF, 0xFF));
		
		WriteScrollReg(0, 0);

		//WriteBars();
		TypeAscii();

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

