## Welcome to RaspberryAda project ##

**Raspberry Ada** is an I/O toolbox for Raspberry Pi board. 

### General Information ###

The project is based on mapping from Broadcom BCM2835 datasheet for ARM Peripherals. The project intention is to map all the chip using the datasheet available from  
<http://www.raspberrypi.org/wp-content/uploads/2012/02/BCM2835-ARM-Peripherals.pdf>.

### Project Status and Goals ###

Each block is a chapter of the BCM2835 datasheet. 

- Auxiliaries: UART1 & SPI1, SPI2 : Implemented.
- **BSC : Under development**.
- DMA Controller : Future development.
- External Mass Media Controller : Future development.
- General Purpose I/O (GPIO) : Future development.
- Interrupts : Future development.
- PCM / I2S Audio : Future development.
- Pulse Width Modulator : Future development.
- SPI : Future development.
- SPI/BSC SLAVE : Future development.
- System Timer : Future development.
- UART : Future development.
- Timer (ARM side) : Future development.
- USB : Future development.


### Project Structure ##

	trunk
	|-- project
	|   |-- bin
	|   |-- src
	|   |   |-- main.adb
	|   |   |-- raspberryada.ads
	|   |   `-- raspberryada-aux_uart_spi.ads
	|   |-- obj
	|   `-- raspberryada.gpr
	|-- LICENSE
	`-- README.md
  
* project: folder where are configured the GPS project file, sources and structure for build.

