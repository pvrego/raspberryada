with System;

--+-----------------------------------------------------------------------------
--| The  Device  has  three  Auxiliary  peripherals:  One  mini  UART  and  two
--| SPI  masters. These three peripheral are grouped together as they share the
--| same area  in the peripheral register map and they share a common interrupt.
--| Also all three are controlled by the auxiliary enable register.
--+-----------------------------------------------------------------------------
package RASPBERRYADA.AUX_UART_SPI is

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
         Data : Bit_Array_Type (0 .. 7);
      end record;
   pragma Pack (Mini_Uart_IO_Data_Type);
   for Mini_Uart_IO_Data_Type'Size use SIZE_BYTE;

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
   --|   - Bit_0 : Enable_Rx_Interrupt_DLAB_Eq_0 : Boolean
   --|             If this bit is set the interrupt line is asserted whenever
   --|             the receive FIFO holds at least 1 byte. If this bit is clear
   --|             no receive interrupts are generated. Read/Write.
   --|   - Bit_1 : Enable_Tx_Interrupt_DLAB_Eq_0 : Boolean
   --|             If this bit is set the interrupt line is asserted whenever
   --|             the transmit FIFO is empty. If this bit is clear no transmit
   --|             interrupts are generated. Read/Write.
   --|   - Bits_2_To_3 : Reserved, but required in order to receive inputs.
   --|   - Bits_4_To_7 : Reserved, write zero, read as don't care. Some of these
   --|                   bits have functions in a 16550 compatible UART but are
   --|                   ignored here. Read/Write.
   --+--------------------------------------------------------------------------
   type Mini_Uart_Interrupt_Enable_Type is
      record
         Data : Bit_Array_Type (0 .. 7);
      end record;
   pragma Pack (Mini_Uart_Interrupt_Enable_Type);
   for Mini_Uart_Interrupt_Enable_Type'Size use SIZE_BYTE;

   --+--------------------------------------------------------------------------
   --| The AUX_MU_IIR_REG register shows the interrupt status. It also has two
   --| FIFO enable status bits and (when w riting) FIFO clear bits.
   --+--------------------------------------------------------------------------
   type Mini_Uart_Interrupt_Identify_Type is
      record
         -- This bit is clear whenever an interrupt is pending. Read. Reset
         -- on 1.
         Interrupt_Pending : Boolean;
         -- Read/Write.
         -- On read this register shows the interrupt ID bits:
         -- * 00 : No interrupts
         -- * 01 : Transmit holding register empty
         -- * 10 : Receiver holds valid byte
         -- * 11 : <Not possible>
         -- On write:
         -- * Writing with bit 1 set will clear the receive FIFO.
         -- * Writing with bit 2 set will clear the transmit FIFO
         Read_Interrupt_Id_Or_Write_FIFO_Clear_Bits : Bit_Array_Type (1 .. 2);
         -- Always read as zero as the mini UART has no timeout function. Read.
         Spare_3 : Spare_Type (3 .. 3);
         -- Always read as zero. Read.
         Spare_4_5 : Spare_Type (4 .. 5);
         -- Both bits always read as 1 as the FIFOs are always enabled. Read.
         FIFO_Enables : Bit_Array_Type (6 .. 7);
      end record;
   pragma Pack (Mini_Uart_Interrupt_Identify_Type);
   for Mini_Uart_Interrupt_Identify_Type'Size use SIZE_BYTE;

   --+--------------------------------------------------------------------------
   --| The AUX_MU_LCR_REG register controls the line data format and gives
   --| access to the baudrate register.
   --+--------------------------------------------------------------------------
   type Mini_Uart_Line_Control_Type is
      record
         -- If clear the UART works in 7-bit mode. If set the UART works in
         -- 8-bit mode. Read/Write.
         Data_Size : Boolean;
         -- Bit 1 must be se for 8-bit mode, like a 16550 write a 3 to get
         -- 8-bit mode. Read.
         Use_8_Bit_Mode : Boolean;
         -- Reserved, write zero, read as don't care. Some of these bits have
         -- functions in a 16550 compatible UART but are ignored here.
         Spare_2_To_5 : Spare_Type (2 .. 5);
         -- If set high the UART1_TX line is pulled low continuously. If held
         -- for at least 12 bits times that will indicate a break condition.
         -- Read/Write.
         Break : Boolean;
         -- If set the first to Mini UART register give access the the Baudrate
         -- register. During operation this bit must be cleared.
         DLAB_Access : Boolean;
      end record;
   pragma Pack (Mini_Uart_Line_Control_Type);
   for Mini_Uart_Line_Control_Type'Size use SIZE_BYTE;

   --+--------------------------------------------------------------------------
   --| The AUX_MU_MCR_REG register controls the 'modem' signals.
   --+--------------------------------------------------------------------------
   type Mini_Uart_Modem_Control_Type is
      record
         -- Reserved, write zero, read as don't care. This bit has a function
         -- in a 16550 compatible UART but is ignored here;
         Spare_0 : Spare_Bit_Type;
         -- If clear the UART1_RTS line is high. If set the UART1_RTS line is
         -- low. This bit is ignored if the RTS is used for auto-flow control.
         -- See the Mini Uart Extra Control register description.
         RTS : Boolean;
         -- Reserved, write zero, read as don't care. Some of these bits have
         -- functions in a 16550 compatible UART but are ignored here.
         Spare_2_7 : Spare_Type (2 .. 7);
      end record;
   pragma Pack (Mini_Uart_Modem_Control_Type);
   for Mini_Uart_Modem_Control_Type'Size use SIZE_BYTE;

   --+--------------------------------------------------------------------------
   --| The AUX_MU_LSR_REG register shows the data status.
   --+--------------------------------------------------------------------------
   type Mini_Uart_Line_Status_Type is
      record
         -- This bit is set if the receive FIFO holds at least 1 symbol. Read.
         Data_Ready : Boolean;
         -- This bit is set if there was a receiver overrun. That is: one or
         -- more characters arrived whilst the receive FIFO was full. The newly
         -- arrived characters have been discarded. This bit is cleared each
         -- time this register is read. To do a non-destructive read of this
         -- overrun bit use the Mini Uart Extra Status register. Read/Clear.
         Receiver_Outrun : Boolean;
         -- Reserved, write zero, read as don't care. Some of these bits have
         -- functions in a 16550 compatible UART but are ignored here.
         Spare_2_4 : Spare_Type (2 .. 4);
         -- This bit is set if the transmit FIFO can accept at least one byte.
         -- Read.
         Transmitter_Empty : Boolean;
         -- This bit is set if the transmit FIFO is empty and the transmitter
         -- is idle. (Finished shifting out the last bit). Read.
         Transmitter_Idle : Boolean;
         -- Reserved, write zero, read as don't care. This bit has a function
         -- in a 16550 compatible UART but is ignored here.
         Spare_7 : Spare_Bit_Type;
      end record;
   pragma Pack (Mini_Uart_Line_Status_Type);
   for Mini_Uart_Line_Status_Type'Size use SIZE_BYTE;

   --+--------------------------------------------------------------------------
   --| The AUX_MU_MSR_REG register shows the 'modem' status.
   --+--------------------------------------------------------------------------
   type Mini_Uart_Modem_Status_Type is
      record
         -- Reserved, write zero, read as don't care. Some of these bits have
         -- functions in a 16550 compatible UART but are ignored here.
         Spare_0_3 : Spare_Type (0 .. 3);
         -- This bit is the inverse of the UART1_CTS input. Thus:
         -- * If set the UART1_CTS pin is low
         -- * If clear the UART1_CTS pin is high
         CTS_Status : Boolean;
         -- Reserved, write zero, read as don't care. Some of these bits have
         -- functions in a 16550 compatible UART but are ignored here.
         Spare_6_7 : Spare_Type (6 .. 7);
      end record;
   pragma Pack (Mini_Uart_Modem_Status_Type);

   --+--------------------------------------------------------------------------
   --| The AUX_MU_SCRATCH is a single byte storage.
   --+--------------------------------------------------------------------------
   type Mini_Uart_Scratch_Type is
      record
         -- One whole byte extra on top of the 134217728 provided by the SDC.
         -- Read/Write.
         Scratch : Bit_Array_Type (0 .. 7);
      end record;
   pragma Pack (Mini_Uart_Scratch_Type);
   for Mini_Uart_Scratch_Type'Size use SIZE_BYTE;

   --+--------------------------------------------------------------------------
   --| The AUX_MU_CNTL_REG provides access to some extra useful and nice
   --| features not found on a normal 16550 UART.
   --+--------------------------------------------------------------------------
   type Mini_Uart_Extra_Control_Type is
      record
         -- If this bit is set the mini UART receiver is enabled. If this bit is
         -- clear the mini UART receiver is disabled. Read/Write.
         Receiver_Enable : Boolean;
         -- If this bit is set the mini UART transmitter is enabled. If this bit
         -- is clear the mini UART transmitter is disabled. Read/Write.
         Transmitter_Enable : Boolean;
         -- If this bit is set the RTS line will de-assert if the receive FIFO
         -- reaches its 'auto flow' level. In fact the RTS line will behave as
         -- an RTR (Ready To Receive) line. If this bit is clear the RTS line is
         -- controlled by the AUX_MU_MCR_REG register bit 1. Read/Write.
         Enable_Receive_Auto_Flowcontrol_Using_RTS : Boolean;
         -- If this bit is set the transmitter will stop if the CTS line is
         -- de-asserted. If this bit is clear the transmitter will ignore the
         -- status of the CTS line. Read/Write.
         Enable_Transmit_Auto_Flowcontrol_Using_CTS : Boolean;
         -- These two bits specify at what receiver FIFO level the RTS line is
         -- de-asserted in auto-flow mode:
         -- * 00 : De-assert RTS when the receive FIFO has 3 empty spaces left.
         -- * 01 : De-assert RTS when the receive FIFO has 2 empty spaces left.
         -- * 10 : De-assert RTS when the receive FIFO has 1 empty space left.
         -- * 11 : De-assert RTS when the receive FIFO has 4 empty spaces left.
         -- Read/Write.
         RTS_Auto_Flow_Level : Bit_Array_Type (4 .. 5);
         -- This bit allows one to invert the RTS auto flow operation polarity.
         -- If set the RTS auto flow assert level is low. If clear the RTS auto
         -- flow assert level is high. Read/Write.
         RTS_Assert_Level : Boolean;
         -- This bit allows one to invert the CTS auto flow operation polarity.
         -- If set the CTS auto flow assert level is low. If clear the CTS auto
         -- flow assert level is high.
         CTS_Assert_Level : Boolean;
      end record;
   pragma Pack (Mini_Uart_Extra_Control_Type);
   for Mini_Uart_Extra_Control_Type'Size use SIZE_BYTE;

   --+--------------------------------------------------------------------------
   --| The AUX_MU_STAT_REG provides a lot of useful information about the
   --| internal status of the mini UART not found on a normal 16550 UART.
   --+--------------------------------------------------------------------------
   type Mini_Uart_Extra_Status_Type is
      record
         -- If this bit is set the mini UART receive FIFO contains at least 1
         -- symbol. If this bit is clear the mini UART receiver FIFO is empty.
         -- Read.
         Symbol_Available : Boolean;
         -- If this bit is set the mini UART transmitter FIFO can accept at
         -- least one more symbol. If this bit is clear the mini UART
         -- transmitter FIFO is full. Read.
         Space_Available : Boolean;
         -- If this bit is set the receiver is idle. If this bit is clear the
         -- receiver is busy. This bit can change unless the receiver is
         -- disabled. Read.
         Receiver_Is_Idle : Boolean;
         -- If this bit is set the transmitter is idle. If this bit is clear the
         -- transmitter is idle. Read.
         Transmitter_Is_Idle : Boolean;
         -- This bit is set if there was a receiver overrun. That is: one or
         -- more characters arrived whilst the receive FIFO was full. The newly
         -- arrived characters have been discarded. This bit is cleared each
         -- time the AUX_MU_LSR_REG register is read. Read.
         Receiver_Overrun : Boolean;
         -- This is the inverse of bit 1 (Space_Available). Read.
         Transmit_FIFO_Is_Full : Boolean;
         -- This bit shows the status of the UART1_RTS line. Read.
         RTS_Status : Boolean;
         -- This bit shows the status of the UART1_CTS line. Read.
         CTS_Status : Boolean;
         -- If this bit is set the transmitter FIFO is empty. Thus it can accept
         -- 8 symbols. Read.
         Transmit_FIFO_Is_Empty : Boolean;
         -- This bit is set if the transmitter is idle and the transmit FIFO is
         -- empty. It is a logic AND of bits 2 and 8. Read.
         Transmitter_Done : Boolean;
         -- Reserved, write zero, read as don't care.
         Spare_10_15 : Spare_Type (10 .. 15);
         -- These bits shows how many symbols are stored in the receive FIFO.
         -- The value is in the range 0-8. Read.
         Receive_FIFO_Fill_Level : Bit_Array_Type (16 .. 19);
         -- Reserved, write zero, read as don't care.
         Spare_20_23 : Spare_Type (20 .. 23);
         -- These bits shows how many symbols are stored in the transmit FIFO.
         -- The value is in the range 0-8. Read.
         Transmit_FIFO_Fill_Level : Bit_Array_Type (24 .. 27);
      end record;
   pragma Pack (Mini_Uart_Extra_Status_Type);
   for Mini_Uart_Extra_Status_Type'Size use SIZE_DWORD;

   --+--------------------------------------------------------------------------
   --| The AUX_MU_BAUD register allows direct access to the 16-bit wide baudrate
   --| counter. This is the same register as is accessed using the LABD bit and
   --| the first two register, but much easier to access.
   --+--------------------------------------------------------------------------
   type Mini_Uart_Baud_Rate is
      record
         -- Mini UART baudrate counter. Read/Write.
         Baud_Rate : Bit_Array_Type (0 .. 15);
      end record;
   pragma Pack (Mini_Uart_Baud_Rate);
   for Mini_Uart_Baud_Rate'Size use SIZE_WORD;

   --+--------------------------------------------------------------------------
   --| The AUXSPIx_CNTL0 register control many features of the SPI interfaces.
   --+--------------------------------------------------------------------------
   type SPI_Control_Register_0_Type is
      record
         -- Specifies the number of bits to shift. This field is ignored when
         -- using 'variable shift' mode. Read/Write.
         Shift_Length : Bit_Array_Type (0 .. 5);
         -- If 1 the data is shifted out starting with the MS bit (bit 15 or
         -- bit 11). If 0 the data is shifted out starting with the LS bit
         -- (bit 0). Read/Write.
         Shift_Out_MS_Bit_First : Boolean;
         -- If 1 the 'idle' clock line state is high. If 0 the 'idle' clock line
         -- state is low. Read/Write.
         Invert_SPI_CLK : Boolean;
         -- If 1 data is clocked out on the rising edge of the SPI clock. If 0
         -- data is clocked out on the falling edge of the SPI clock.
         -- Read/Write.
         Out_Rising : Boolean;
         -- If 1 the receive and transmit FIFOs are held in reset (and thus
         -- flushed). This bit should be 0 during normal operation. Read/Write.
         Clear_FIFOs : Boolean;
         -- If 1 data is clocked in on the rising edge of the SPI clock. If 0
         -- data is clocked in on the falling edge of the SPI clock. Read/Write.
         In_Rising : Boolean;
         -- Enables the SPI interface. Whilst disabled the FIFOs can still be
         -- written to or read from. This bit should be 1 during normal
         -- operation. Read/Write.
         Enable : Boolean;
         -- Controls the extra DOUT hold time in system clock cycles.
         -- * 00 : No extra hold time
         -- * 01 : 1 system clock extra hold time
         -- * 10 : 4 system clocks extra hold time
         -- * 11 : 7 system clocks extra hold time
         -- Read/Write.
         DOUT_Hold_Time : Bit_Array_Type (12 .. 13);
         -- If 1 the SPI takes the shift length and the data from the TX fifo.
         -- If 0 the SPI takes the shift length from bits 0-5 of this register.
         -- Read/Write.
         Variable_Width : Boolean;
         -- If 1 the SPI takes the CS pattern and the data from the TX fifo.
         -- If 0 the SPI takes the CS pattern from bits 17-19 of this register.
         -- Set this bit only if also bit 14 (variable width) is set.
         -- Read/Write.
         Variable_CS : Boolean;
         -- If set the SPI input works in post input mode.
         Post_Input_Mode : Boolean;
         -- The pattern output on the CS pins when active. Read/Write.
         Chip_Selects : Bit_Array_Type (17 .. 19);
         -- Sets the SPI clock speed. spi clk freq =
         -- system_clock_freq/2*(speed+1). Read/Write.
         Speed : Bit_Array_Type (20 .. 31);
      end record;
   pragma Pack (SPI_Control_Register_0_Type);
   for SPI_Control_Register_0_Type'Size use SIZE_DWORD;

   --+--------------------------------------------------------------------------
   --| The AUXSPIx_CNTL1 registers control more features of the SPI interfaces.
   --+--------------------------------------------------------------------------
   type SPI_Control_Register_1_Type is
      record
         -- If 1 the receiver shift register is NOT cleared. Thus new data is
         -- concatenated to old data. If 0 the receiver shift register is
         -- cleared before each transaction. Read/Write.
         Keep_Input : Boolean;
         -- If 1 the data is shifted in starting with the MS bit. (bit 15). If 0
         -- the data is shifted in starting with the LS bit. (bit 0).
         -- Read/Write.
         Shift_In_MS_First : Boolean;
         -- Reserved, write zero, read as don't care.
         Spare_2_5 : Spare_Type (2 .. 5);
         -- If 1 the interrupt line is high when the interface is idle.
         -- Read/Write.
         Done_IRQ : Boolean;
         -- If 1 the interrupt line is high when the transmit FIFO is empty.
         -- Read/Write.
         TX_Empty_IRQ : Boolean;
         -- Additional SPI clock cycles where the CS is high. Read/Write.
         CS_High_Time : Boolean;
      end record;
   pragma Pack (SPI_Control_Register_1_Type);
   for SPI_Control_Register_1_Type'Size use 11;

   --+--------------------------------------------------------------------------
   --| The AUXSPIx_STAT registers show the status of the SPI interfaces.
   --+--------------------------------------------------------------------------
   type SPI_Status_Type is
      record
         -- The number of bits still to be processed. Starts with 'shift-length'
         -- and counts down. Read/Write.
         Bit_Count : Bit_Array_Type (0 .. 5);
         -- Indicates the module is busy transferring data. Read/Write.
         Busy : Boolean;
         -- If 1 the receiver FIFO is empty. If 0 the receiver FIFO holds at
         -- least 1 data unit. Read/Write.
         RX_Empty : Boolean;
         -- If 1 the transmit FIFO is empty. If 0 the transmit FIFO holds at
         -- least 1 data unit. Read/Write.
         TX_Empty : Boolean;
         -- If 1 the transmit FIFO is full. If 0 the transmit FIFO can accept at
         -- least 1 data unit. Read/Write.
         TX_Full : Boolean;
         -- Reserved, write zero, read as don't care.
         Spare_10_15 : Spare_Type (10 .. 15);
         -- The number of data units in the receive data FIFO. Read/Write.
         RX_FIFO_Level : Interfaces.Unsigned_8;
         -- The number of data units in the transmit data FIFO. Read/Write.
         TX_FIFO_Level : Interfaces.Unsigned_8;
      end record;
      pragma Pack (SPI_Status_Type);
      for SPI_Status_Type'Size use SIZE_DWORD;

   --+--------------------------------------------------------------------------
   --| The AUXSPIx_IO registers are the primary data port of the SPI interfaces.
   --| These four addresses all write to the same FIFO.
   --+--------------------------------------------------------------------------
   type SPI_Data_Type is
      record
         -- Writes to this address range end up in the transmit FIFO. Data is
         -- lost when writing whilst the transmit FIFO is full. Reads from this
         -- address will take the top entry from the receive FIFO. Reading
         -- whilst the receive FIFO is will return the last data received.
         -- Read/Write.
         Data : Bit_Array_Type (0 .. 15);
      end record;
   pragma Pack (SPI_Data_Type);
   for SPI_Data_Type'Size use SIZE_WORD;

   --+--------------------------------------------------------------------------
   --| The AUXSPIx_PEEK registers show received data of the SPI interfaces.
   --+--------------------------------------------------------------------------
   type SPI_Peek_Type is
      record
         Data : Bit_Array_Type (0 .. 15);
      end record;
   pragma Pack (SPI_Peek_Type);
   for SPI_Peek_Type'Size use SIZE_WORD;

   --+--------------------------------------------------------------------------
   --| The AUXSPIx_TXHOLD registers are the extended CS port of the SPI
   --| interfaces. These four addresses all write to the same FIFO.
   --+--------------------------------------------------------------------------
   type SPI_TX_Hold_Type is
      record
         -- Writes to this address range end up in the transmit FIFO. Data is
         -- lost when writing whilst the transmit FIFO is full. Reads from this
         -- address will take the top entry from the receive FIFO. Reading
         -- whilst the receive FIFO is will return the last data received.
         Data : Bit_Array_Type (0 .. 15);
      end record;
   pragma Pack (SPI_TX_Hold_Type);
   for SPI_TX_Hold_Type'Size use SIZE_WORD;

   type Auxiliary_Peripherals_Register_Map_Type is
      record
         AUX_IRQ            : Auxiliary_Interrupt_Status_Type;
         AUX_ENABLES        : Auxiliary_Enables_Type;
         AUX_MU_IO_REG      : Mini_Uart_IO_Data_Type;
         AUX_MU_IER_REG     : Mini_Uart_Interrupt_Enable_Type;
         AUX_MU_IIR_REG     : Mini_Uart_Interrupt_Identify_Type;
         AUX_MU_LCR_REG     : Mini_Uart_Line_Control_Type;
         AUX_MU_MCR_REG     : Mini_Uart_Modem_Control_Type;
         AUX_MU_LSR_REG     : Mini_Uart_Line_Status_Type;
         AUX_MU_MSR_REG     : Mini_Uart_Modem_Status_Type;
         AUX_MU_SCRATCH     : Mini_Uart_Scratch_Type;
         AUX_MU_CNTL_REG    : Mini_Uart_Extra_Control_Type;
         AUX_MU_STAT_REG    : Mini_Uart_Extra_Status_Type;
         AUX_MU_BAUD_REG    : Mini_Uart_Baud_Rate;
         AUX_SPI0_CNTL0_REG : SPI_Control_Register_0_Type;
         AUX_SPI0_CNTL1_REG : SPI_Control_Register_1_Type;
         AUX_SPI0_STAT_REG  : SPI_Status_Type;
         AUX_SPI0_PEEK_REG  : SPI_Peek_Type;
         AUX_SPI0_IO_REG    : SPI_Data_Type;
         AUX_SPI0_TXHOLD    : SPI_TX_Hold_Type;
         AUX_SPI1_CNTL0_REG : SPI_Control_Register_0_Type;
         AUX_SPI1_CNTL1_REG : SPI_Control_Register_1_Type;
         AUX_SPI1_STAT_REG  : SPI_Status_Type;
         AUX_SPI1_PEEK_REG  : SPI_Peek_Type;
         AUX_SPI1_IO_REG    : SPI_Data_Type;
         AUX_SPI1_TXHOLD    : SPI_TX_Hold_Type;
      end record;

   for Auxiliary_Peripherals_Register_Map_Type use
      record
         AUX_IRQ            at 16#00# range 00 .. 02;
         AUX_ENABLES        at 16#04# range 00 .. 02;
         AUX_MU_IO_REG      at 16#40# range 00 .. 07;
         AUX_MU_IER_REG     at 16#44# range 00 .. 07;
         AUX_MU_IIR_REG     at 16#48# range 00 .. 07;
         AUX_MU_LCR_REG     at 16#4C# range 00 .. 07;
         AUX_MU_MCR_REG     at 16#50# range 00 .. 07;
         AUX_MU_LSR_REG     at 16#54# range 00 .. 07;
         AUX_MU_MSR_REG     at 16#58# range 00 .. 07;
         AUX_MU_SCRATCH     at 16#5C# range 00 .. 07;
         AUX_MU_CNTL_REG    at 16#60# range 00 .. 07;
         AUX_MU_STAT_REG    at 16#64# range 00 .. 31;
         AUX_MU_BAUD_REG    at 16#68# range 00 .. 15;
         AUX_SPI0_CNTL0_REG at 16#80# range 00 .. 31;
         AUX_SPI0_CNTL1_REG at 16#84# range 00 .. 10;
         AUX_SPI0_STAT_REG  at 16#88# range 00 .. 31;
         AUX_SPI0_PEEK_REG  at 16#8C# range 00 .. 15;
         AUX_SPI0_IO_REG    at 16#A0# range 00 .. 15;
         AUX_SPI0_TXHOLD    at 16#B0# range 00 .. 15;
         AUX_SPI1_CNTL0_REG at 16#C0# range 00 .. 31;
         AUX_SPI1_CNTL1_REG at 16#C4# range 00 .. 10;
         AUX_SPI1_STAT_REG  at 16#C8# range 00 .. 31;
         AUX_SPI1_PEEK_REG  at 16#CC# range 00 .. 15;
         AUX_SPI1_IO_REG    at 16#E0# range 00 .. 15;
         AUX_SPI1_TXHOLD    at 16#F0# range 00 .. 15;

      end record;

private
   Auxiliary_Peripherals_Register_Map : Auxiliary_Peripherals_Register_Map_Type;
   for Auxiliary_Peripherals_Register_Map'Address use System'To_Address (16#7E21_5000#);

end RASPBERRYADA.AUX_UART_SPI;
