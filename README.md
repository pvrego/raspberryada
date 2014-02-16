## Welcome to RaspberryAda project ##

**Raspberry Ada** is an I/O toolbox for Raspberry Pi board. 

### General Information ###

The project is based on mapping from Broadcom BCM2835 datasheet for ARM Peripherals. The project intention is to map all the chip using the datasheet available from  
<http://www.raspberrypi.org/wp-content/uploads/2012/02/BCM2835-ARM-Peripherals.pdf>. This datasheet Windows link is replicated in `related` folder to become easier the development.

There are some corrections to be made in the BCM2835 datasheet, which are described in <http://elinux.org/BCM2835_datasheet_errata#the_BCM2835_on_the_RPI>. This page is also replicated in pdf form in `related` folder, file `BCM2835-datasheet_errata-eLinux.pdf`.

And finally we add the file `related\BCM2835-ARM-Peripherals-Fixed.pdf` with the corrections indicated in `BCM2835-datasheet_errata-eLinux.pdf`, added to the `BCM2835-ARM-Peripherals.pdf` document. The informations from the errata document are indicated in comments in the main document.

### Project Status and Goals ###

Each block is a chapter of the BCM2835 datasheet. 

- Auxiliaries: UART1 & SPI1, SPI2 : Implemented.
- BSC : Implemented.
- **DMA Controller : Under development**.
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
	|   |   |-- raspberryada-aux_uart_spi.ads
	|   |   `-- raspberryada-bsc.ads
	|   |-- obj
	|   `-- raspberryada.gpr
	|-- related
	|   |-- BCM2835-ARM-Peripherals.pdf
	|   |-- BCM2835-ARM-Peripherals-Fixed.pdf
	|   `-- BCM2835-datasheet_errata-eLinux.pdf
	|-- LICENSE
	`-- README.md
  
In `project` folder is where are configured the GPS project file, sources and structure for build.

