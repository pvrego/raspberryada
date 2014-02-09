with Interfaces;
with System;

package RADA is

   --+--------------------------------------------------------------------------
   --| Constants
   --+--------------------------------------------------------------------------

   BYTE_SIZE : constant := 8;

   --+--------------------------------------------------------------------------
   --| General Purpose Types
   --+--------------------------------------------------------------------------

   type Byte_Type is new Interfaces.Unsigned_8;
   for Byte_Type'Size use BYTE_SIZE;

   type Byte_Array_Type is array (0 .. 7) of Boolean;
   pragma Pack (Byte_Array_Type);
   for Byte_Array_Type'Size use 8;

   --+--------------------------------------------------------------------------
   --| The AUXIRQ  register is used to check any pending interrupts which may be
   --| asserted by the three Auxiliary sub blocks.
   --+--------------------------------------------------------------------------
   type Auxiliary_Interrupt_Status_Type is
      record
         -- If set the mini UART has an interrupt pending. Read.
         Mini_Uart_IRQ : Boolean;
         -- If set the SPI1 module has an interrupt pending. Read.
         SPI_1_IRQ     : Boolean;
         -- If set the SPI 2 module has an interrupt pending. Read.
         SPI_2_IRQ     : Boolean;
      end record;
   pragma Pack (Auxiliary_Interrupt_Status_Type);
   for Auxiliary_Interrupt_Status_Type'Size use 3;

   --+--------------------------------------------------------------------------
   --| The AUXENB register is used to enable the three modules; UART,SPI1, SPI2.
   --+--------------------------------------------------------------------------
   type Auxiliary_Enables_Type is
      record
         -- If set the mini UART is enabled. The UART will immediately start
         -- receiving data, especially if the UART1_RX line is low. If clear the
         -- mini UART is disabled. That also disables any mini UART register
         -- access. Read/Write.
         Mini_Uart_Enable : Boolean;
         -- If set the SPI 1 module is enabled. If clear the SPI 1 module is
         -- disabled. That also disables any SPI 1 module register access.
         -- Read/Write.
         SPI_1_Enable     : Boolean;
         -- If set the SPI 2 module is enabled. If clear the SPI 2 module is
         -- disabled. That also disables any SPI 2 module register access.
         -- Read/Write.
         SPI_2_Enable     : Boolean;
      end record;
   pragma Pack (Auxiliary_Enables_Type);
   for Auxiliary_Enables_Type'Size use 3;

   --+--------------------------------------------------------------------------
   --| The AUX_MU_IO_REG register is primary used to write data to and read data
   --| from the UART FIFOs. If the DLAB bit in the line control register is set
   --| this register gives access to the LS 8 bits of the baud rate.
   --| Note: there is easier access to the baud rate register.
   --|
   --| It can be interpreted in one of the following meanings:
   --|
   --| * Receive_Data_Read_DLAB_Eq_0 : Byte_Array_Type
   --|   - Data read is taken from the receive FIFO (Provided it is not empty)
   --|     but only if bit 7 of the line control register (DLAB bit) is clear.
   --|     Read.
   --|
   --| * Transmit_Data_Write_DLAB_Eq_0 : Byte_Array_Type
   --|   - Data written is put in the transmit FIFO (Provided it is not full)
   --|     but only if bit 7 of the line control register (DLAB bit) is clear.
   --|     Write.
   --|
   --| * LS_8_Bits_Baudrate_RW_DLAB_Eq_1 : Byte_Array_Type
   --|   - Access to the LS 8 bits of the 16-bit baudrate register. But only
   --|     if bit 7 of the line control register (DLAB bit) is set. Read/Write.
   --+--------------------------------------------------------------------------
   type Mini_Uart_IO_Data_Type is
      record
         Data : Byte_Array_Type;
      end record;
   pragma Pack (Mini_Uart_IO_Data_Type);
   for Mini_Uart_IO_Data_Type'Size use BYTE_SIZE;

   --+--------------------------------------------------------------------------
   --| The AUX_MU_IER_REG register is primary used to enable interrupts.
   --| If the DLAB bit in the line control register is set this register gives
   --| access to the MS 8 bits of the baud rate.
   --| Note: there is easier access to the baud rate register.
   --|
   --| It can be interpreted in one of the following meanings:
   --| * MS_8_bits_Baudrate_RW_DLAB_Eq_1 : Byte_Array_Type
   --|   - Access to the MS 8 bits of the 16-bit baudrate register. Only if bit
   --|     7 of the line control register (DLAB bit) is set. Read/Write.
   --|
   --| * Enable_Interrupts : Byte_Array_Type
   --|   - Bit_0 : Enable_Tx_Interrupt_DLAB_Eq_0 : Boolean
   --|             If this bit is set the interrupt line is asserted whenever
   --|             the transmit FIFO is empty. If this bit is clear no transmit
   --|             interrupts are generated. Read.
   --|   - Bit_1 : Enable_Rx_Interrupt_DLAB_Eq_0 : Boolean
   --|             If this bit is set the interrupt line is asserted whenever
   --|             the receive FIFO holds at least 1 byte. If this bit is clear
   --|             no receive interrupts are generated.
   --|   - Bits_2_To_7 : Reserved, write zero, read as don't care. Some of these
   --|                   bits have functions in a 16550 compatible UART but are
   --|                   ignored here.
   --+--------------------------------------------------------------------------
   type Mini_Uart_Interrupt_Enable_Type is
      record
         Data : Byte_Array_Type;
      end record;
   pragma Pack (Mini_Uart_Interrupt_Enable_Type);
   for Mini_Uart_Interrupt_Enable_Type'Size use 8;

   type Auxiliary_Peripherals_Register_Map_Type is
      record
         AUX_IRQ            : Auxiliary_Interrupt_Status_Type;
         AUX_ENABLES        : Auxiliary_Enables_Type;
         AUX_MU_IO_REG      : Mini_Uart_IO_Data_Type;
         AUX_MU_IER_REG     : Mini_Uart_Interrupt_Enable_Type;
         --           AUX_MU_IIR_REG     : Mini_Uart_Interrupt_Identify_Type;
         --           AUX_MU_LCR_REG     : Mini_Uart_Line_Control_Type;
         --           AUX_MU_MCR_REG     : Mini_Uart_Modem_Control_Type;
         --           AUX_MU_LSR_REG     : Mini_Uart_Line_Status_Type;
         --           AUX_MU_MSR_REG     : Mini_Uart_Modem_Status_Type;
         --           AUX_MU_SCRATCH     : Mini_Uart_Scratch_Type;
         --           AUX_MU_CNTL_REG    : Mini_Uart_Extra_Control_Type;
         --           AUX_MU_STAT_REG    : Mini_Uart_Extra_Status_Type;
         --           AUX_MU_BAUD_REG    : Mini_Uart_Baud_Rate;
         --           AUX_SPI0_CNTL0_REG : SPI_1_Control_Register_0;
         --           AUX_SPI0_CNTL1_REG : SPI_1_Control_Register_1;
         --           AUX_SPI0_STAT_REG  : SPI_1_Status;
         --           AUX_SPI0_IO_REG    : SPI_1_Data;
         --           AUX_SPI0_PEEK_REG  : SPI_1_Peek;
         --           AUX_SPI1_CNTL0_REG : SPI_2_Control_Register_0;
         --           AUX_SPI1_CNTL1_REG : SPI_2_Control_Register_1;
         --           AUX_SPI0_STAT_REG  : SPI_2_Status;
         --           AUX_SPI0_IO_REG    : SPI_2_Data;
         --           AUX_SPI0_PEEK_REG  : SPI_2_Peek;
      end record;

   for Auxiliary_Peripherals_Register_Map_Type use
      record
         AUX_IRQ        at 00 range 00 .. 02;
         AUX_ENABLES    at 04 range 00 .. 02;
         AUX_MU_IO_REG  at 40 range 00 .. 07;
         AUX_MU_IER_REG at 44 range 00 .. 07;
      end record;

private
   Auxiliary_Peripherals_Register_Map : Auxiliary_Peripherals_Register_Map_Type;
   for Auxiliary_Peripherals_Register_Map'Address use System'To_Address (16#7E21_5000#);
end RADA;
