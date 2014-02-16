--+-----------------------------------------------------------------------------
--| The  Broadcom  Serial  Controller  (BSC)  controller  is  a master,
--| fast-mode  (400Kb/s)  BSC controller. The Broadcom Serial Control bus is a
--| proprietary bus compliant with the Philips I2C bus/interface version 2.1
--| January 2000.
--| - I2C single master only operation (supports clock stretching wait states)
--| - Both 7-bit and 10-bit addressing is supported. Timing completely software
--|   controllable via registers.
--|
--| The BSC controller has eight memory-mapped registers.  All accesses are
--| assumed to be 32-bit. Note that the BSC2 master is used dedicated with the
--| HDMI interface and should not be accessed by user programs.
--| There are three BSC masters inside BCM. The registeraddresses starts from
--| BSC0: 0x7E20_5000
--| BSC1: 0x7E80_4000
--| BSC2: 0x7E80_5000
--|
--| The table below shows the address of I2C interface where the address is an
--| offset from one of the three base addreses listed above.
--|
--| +-----------------+---------------+----------------------+------+
--| | Address Offset  | Register Name | Description          | Size |
--| +-----------------+---------------+----------------------+------+
--| | 0x0             | C             | Control              | 32   |
--| | 0x4             | S             | Status               | 32   |
--| | 0x8             | DLEN          | Data Length          | 32   |
--| | 0xc             | A             | Slave Address        | 32   |
--| | 0x10            | FIFO          | Data FIFO            | 32   |
--| | 0x14            | DIV           | Clock Divider        | 32   |
--| | 0x18            | DEL           | Data Delay           | 32   |
--| | 0x1c            | CLKT          | Clock Strech Timeout | 32   |
--| +-----------------+---------------+----------------------+------+
--|
--+-----------------------------------------------------------------------------
package RASPBERRYADA.BSC is

   --+--------------------------------------------------------------------------
   --| The control register is used to enable interrupts, clear the FIFO, define
   --| a read or write operation and start a transfer.
   --+--------------------------------------------------------------------------
   type Control_Register_Type is
      record
         -- The READ field specifies the type of transfer.
         -- - 0 = Write Packet Transfer.
         -- - 1 = Read Packet Transfer. Read/Write.
         Read_Transfer : Boolean;

         -- Reserved - Write as 0, read as don't care
         Spare_1_3 : Spare_Type (1 .. 3) := (others => 0);

         -- The CLEAR field is used to clear the FIFO. Writing to this field is
         -- a one-shot operation which will always read back as zero. The CLEAR
         -- bit can set at the same time as the start transfer bit, and will
         -- result in the FIFO being cleared just prior to the start of
         -- transfer. Note that clearing the FIFO during a transfer will result
         -- in the transfer being aborted.
         -- - 00 = No action. x1 = Clear FIFO. One shot operation.
         -- - 1x = Clear FIFO. One shot operation.
         -- If CLEAR and ST are both set in the same operation, the FIFO is
         -- cleared before the new frame is started. Read back as 0.
         -- Note: 2 bits are used to maintain compatibility to previous version.
         -- Read/Write.
         FIFO_Clear : Bit_Array_Type (4 .. 5);

         -- Reserved - Write as 0, read as don't care
         Spare_6 : Spare_Type (6 .. 6) := (others => 0);

         -- The ST field starts a new BSC transfer. This has a one shot action,
         -- and so the bit will always read back as 0.
         -- - 0 = No action.
         -- - 1 = Start a new transfer. One shot operation. Read back as 0
         -- Read/Write.
         Start_Transfer : Boolean;

         -- The INTD field enables interrupts at the end of a transfer the DONE
         -- condition. The interrupt remains active until the DONE condition is
         -- cleared by writing a 1 to the I2CS.DONE field. Writing a 0 to the
         -- INTD field disables interrupts on DONE.
         -- - 0 = Don't generate interrupts on DONE condition.
         -- - 1 = Generate interrupt while DONE = 1.
         -- Read/Write.
         Interrupt_On_Done : Boolean;

         -- The INTT field enables interrupts whenever the FIFOis or more empty
         -- and needs writing (during a write transfer) - the TXW condition.
         -- The interrupt remains active until the TXW condition is cleared by
         -- writing sufficient data to the FIFO to complete the transfer.
         -- Writing a 0 to the INTT field disables interrupts on TXW.
         -- - 0 = Don't generate interrupts on TXW condition.
         -- - 1 = Generate interrupt while TXW = 1.
         -- Read/Write.
         Interrupt_On_Tx : Boolean;

         -- The INTR field enables interrupts whenever the FIFOis or more full
         -- and needs reading (i.e. during a read transfer) - the RXR condition.
         -- The interrupt remains active until the RXW condition is cleared by
         -- reading sufficient data from the RX FIFO. Writing a 0 to the INTR
         -- field disables interrupts on RXR.
         -- - 0 = Don't generate interrupts on RXR condition.
         -- - 1 = Generate interrupt while RXR = 1.
         -- Read/Write.
         Interrupt_On_Rx : Boolean;

         -- The I2CEN field enables BSC operations. If this bitis 0 then
         -- transfers will not be performed. All register accesses are still
         -- permitted however.
         -- - 0 = BSC controller is disabled.
         -- - 1 = BSC controller is enabled.
         -- Read/Write.
         E2C_Enable : Boolean;
      end record;
   pragma Pack (Control_Register_Type);
   for Control_Register_Type'Size use SIZE_DWORD;

   --+--------------------------------------------------------------------------
   --| The status register is used to record activity status, errors and
   --| interrupt requests.
   --+--------------------------------------------------------------------------
   type Status_Register_Type is
      record
         -- The TA field indicates the activity status of the BSC controller.
         -- This read-only field returns a 1 when the controller is in the
         -- middle of a transfer and a 0 when idle.
         -- - 0 = Transfer not active.
         -- - 1 = Transfer active.
         -- Read.
         Transfer_Active : Boolean;

         -- The DONE field is set when the transfer completes. The DONE
         -- condition can be used with I2CC.INTD to generate an interrupt on
         -- transfer completion. The DONE field is reset by writing a 1, writing
         -- a 0 to the field has no effect.
         -- - 0 = Transfer not completed.
         -- - 1 = Transfer complete.
         -- Cleared by writing 1 to the field.
         -- Read/Write.
         Transfer_Done : Boolean;

         -- The read-only TXW bit is set during a write transferand the FIFO is
         -- less than full and needs writing. Writing sufficient data (i.e.
         -- enough data to either fill the FIFO more than full or complete the
         -- transfer) to the FIFO will clear the field. When the I2CC.INTT
         -- control bit is set, the TXW condition can be used to generate an
         -- interrupt to write more data to the FIFO to complete the current
         -- transfer. Ifthe I2C controller runs out of data to send, it will
         -- wait for more data to be written into the FIFO.
         -- - 0 = FIFO is at least full and a write is underway (or sufficient
         --   data to send).
         -- - 1 = FIFO is less then full and a write is underway.
         -- Cleared by writing sufficient data to the FIFO.
         -- Read.
         TXW_FIFO_Needs_Writing_Full : Boolean;

         -- The read-only RXR field is set during a read transfer and the FIFO
         -- is or more full and needs reading. Reading sufficient data to bring
         -- thedepth below will clear the field. When I2CC.INTR control bit is
         -- set, the RXR condition can be used to generate an interrupt to read
         -- data from the FIFO before it becomes full. In the event that the
         -- FIFO does become full, all I2C operations will stall until data is
         -- removed from the FIFO.
         -- - 0 = FIFO is less than full and a read is underway.
         -- - 1 = FIFO is or more full and a read is underway.
         -- Cleared by reading sufficient data from the FIFO.
         -- Read.
         RXR_FIFO_Needs_Reading_Full : Boolean;

         -- The read-only TXD field is set when the FIFO has space for at least
         -- one byte of data. TXD is clear when the FIFO is full. The TXD field
         -- can be used to check that the FIFO can accept data before any is
         -- written. Any writes to a full TX FIFO will be ignored.
         -- - 0 = FIFO is full. The FIFO cannot accept more data.
         -- - 1 = FIFO has space for at least 1 byte.
         -- Read.
         TXD_FIFO_Can_Accept_Data : Boolean;

         -- The read-only RXD field is set when the FIFO containsat least one
         -- byte of data. RXD is cleared when the FIFO becomes empty. The RXD
         -- field can be used to check that the FIFO contains data before
         -- reading. Reading from an empty FIFO will return invalid data.
         -- - 0 = FIFO is empty.
         -- - 1 = FIFO contains at least 1 byte.
         -- Cleared by reading sufficient data from FIFO.
         -- Read.
         RXD_FIFO_Contains_Data : Boolean;

         -- The read-only TXE field is set when the FIFO is empty. No further
         -- data will be transmitted until more data is written to the FIFO.
         -- - 0 = FIFO is not empty.
         -- - 1 = FIFO is empty. If a write is underway, no further serial data
         --   can be transmitted until data is written to the FIFO.
         -- Read.
         TXE_FIFO_Empty : Boolean;

         -- The read-only RXF field is set when the FIFO is full. No more clocks
         -- will be generated until space is available in the FIFO to receive
         -- more data.
         -- - 0 = FIFO is not full.
         -- - 1 = FIFO is full. If a read is underway, no further serial data
         --   will be received until data is read from FIFO.
         -- Read.
         RXF_FIFO_Full : Boolean;

         -- The ERR field is set when the slave fails to acknowledge either its
         -- address or a data byte written to it. The ERR field is reset by
         -- writing a 1, writing a 0 to the field has no effect.
         -- - 0 = No errors detected.
         -- - 1 = Slave has not acknowledged its address.
         -- Cleared by writing 1 to the field.
         -- Read/Write.
         ERR_Ack_Error : Boolean;

         -- The CLKT field is set when the slave holds the SCL signal high for
         -- too long (clock stretching). The CLKT field is reset by writing a 1,
         -- writing a 0 to the field has no effect.
         -- - 0 = No errors detected.
         -- - 1 = Slave has held the SCL signal low (clock stretching)
         --   for longer and that specified in the I2CCLKT register.
         -- Cleared by writing 1 to the field.
         -- Read/Write.
         CLKT_Clock_Strech_Timeout : Boolean;
      end record;
   pragma Pack (Status_Register_Type);
   for Status_Register_Type'Size use SIZE_DWORD;

   --+--------------------------------------------------------------------------
   --| The data length register defines the number of bytes of data to transmit
   --| or receive in the I2C transfer. Reading the register gives the number of
   --| bytes remaining in the current transfer.
   --| The DLEN field specifies the number of bytes to be transmitted/received.
   --| Reading the DLEN field when a transfer is in progress (TA = 1) returns
   --| the number of bytes still to be transmitted or received. Reading the DLEN
   --| field when the transfer has just completed (DONE = 1) returns zero as
   --| there are no more bytes to transmit or receive. Finally, reading the DLEN
   --| field when TA = 0 and DONE = 0 returns the last value written. The DLEN
   --| field can be left over multiple transfers.
   --+--------------------------------------------------------------------------
   type Data_Length_Register_Type is
      record
         -- Writing to DLEN specifies the number of bytes to be transmitted/
         -- received. Reading from DLEN when TA = 1 or DONE = 1, returns the
         -- number of bytes still to be transmitted or received. Reading from
         -- DLEN when TA = 0 and DONE  = 0, returns the last DLEN value written.
         -- DLEN can be left over multiple packets.
         -- Read/Write.
         Value : Bit_Array_Type (0 .. 15);

         -- Reserved - Write as 0, read as don't care
         Spare_16_31 : Spare_Type (16 .. 31) := (others => <>);
      end record;
   pragma Pack (Data_Length_Register_Type);
   for Data_Length_Register_Type'Size use SIZE_DWORD;

   --+--------------------------------------------------------------------------
   --| The slave address register specifies the slave address and cycle type.
   --| The address register can be left across multiple transfers. The ADDR
   --| field specifies the slave address of the I2C device.
   --+--------------------------------------------------------------------------
   type Slave_Address_Register_Type is
      record
         -- Slave Address. Read/Write.
         Value : Bit_Array_Type (0 .. 6);

         -- Reserved - Write as 0, read as don't care.
         Spare_7_31 : Spare_Type (7 .. 31) := (others => <>);
      end record;
   pragma Pack (Slave_Address_Register_Type);
   for Slave_Address_Register_Type'Size use SIZE_DWORD;

   --+--------------------------------------------------------------------------
   --| The Data FIFO register is used to access the FIFO. Write cycles to this
   --| address place data in the 16-byte FIFO, ready to transmit on the BSC bus.
   --| Read cycles access data received from the bus. Data writes to a full FIFO
   --| will be ignored and datareads from an empty FIFO will result in invalid
   --| data. The FIFO can be cleared using the I2CC.CLEAR field. The DATA field
   --| specifies the data to be transmitted or received.
   --+--------------------------------------------------------------------------
   type Data_FIFO_Register_Type is
      record
         -- Writes to the register write transmit data to the FIFO. Reads from
         -- register reads received data from the FIFO. Read/Write.
         Data : Bit_Array_Type (0 .. 7);

         -- Reserved - Write as 0, read as don't care
         Spare_8_31 : Spare_Type (8 .. 31) := (others => <>);
      end record;
   pragma Pack (Data_FIFO_Register_Type);
   for Data_FIFO_Register_Type'Size use SIZE_DWORD;

   --+--------------------------------------------------------------------------
   --| The clock divider register is used to define the clock speed of the BSC
   --| peripheral. The CDIV field specifies the core clock divider used by the
   --| BSC.
   --+--------------------------------------------------------------------------
   type Clock_Divider_Register_Type is
      record
         -- SCL = core clock / CDIV. Where core_clk is nominally 150 MHz. If
         -- CDIV is set to 0, the divisor is 32768. CDIV is always rounded down
         -- to an even number. The default value should result in a 100 kHz I2C
         -- clock frequency. Read/Write.
         Clock_Divider : Bit_Array_Type (0 .. 15);

         -- Reserved - Write as 0, read as don't care
         Spare_16_31 : Spare_Type (16 .. 31) := (others => <>);
      end record;
   pragma Pack (Clock_Divider_Register_Type);
   for Clock_Divider_Register_Type'Size use SIZE_DWORD;

   --+--------------------------------------------------------------------------
   --| The data delay register provides fine control over the sampling/launch
   --| point of the data.
   --| - The REDL field specifies the number core clocks to wait after the
   --|   rising edge before sampling the incoming data.
   --| - The FEDL field specifies the number core clocks to wait after the
   --|   falling edge before outputting the next data bit.
   --| Note: Care must be taken in choosing values for FEDL and REDL as it is
   --| possible to cause the BSC master to malfunction by setting values of
   --| CDIV/2 or greater. Therefore the delay values should always be set to
   --| less than CDIV/2.
   --+--------------------------------------------------------------------------
   type Data_Delay_Register_Type is
      record
         -- Number of core clock cycles to wait after the rising edge of SCL
         -- before reading the next bit of data. Read/Write.
         REDL_Rising_Edge_Delay : Bit_Array_Type (0 .. 15);

         -- Number of core clock cycles to wait after the falling edge of SCL
         -- before outputting next bit of data. Read/Write.
         FEDL_Falling_Edge_Delay : Bit_Array_Type (16 .. 31);
      end record;
   pragma Pack (Data_Delay_Register_Type);
   for Data_Delay_Register_Type'Size use SIZE_DWORD;

   --+--------------------------------------------------------------------------
   --| The clock stretch timeout register provides a timeout on how long the
   --| master waits for the slave to stretch the clock before deciding that the
   --| slave has hung.
   --| The TOUT field specifies the number I2C SCL clocks to wait after
   --| releasing SCL high and finding that the SCL is still low before deciding
   --| that the slave is not responding and moving the I2C machine forward. When
   --| a timeout occurs,the I2CS.CLKT bit is set.
   --| Writing 0x0 to TOUT will result in the Clock Stretch Timeout being
   --| disabled.
   --+--------------------------------------------------------------------------
   type Clock_Stretch_Timeout_Register_Type is
      record
         -- TOUT Clock Stretch Timeout Value. Number of SCL clock cycles to wait
         -- after the rising edge of SCL before deciding that the slave is not
         -- responding. Read/Write.
         Value : Bit_Array_Type (0 .. 15);

         -- Reserved - Write as 0, read as don't care
         Spare_16_31 : Spare_Type (16 .. 31) := (others => <>);
      end record;
   pragma Pack (Clock_Stretch_Timeout_Register_Type);
   for Clock_Stretch_Timeout_Register_Type'Size use SIZE_DWORD;

   type I2C_Address_Map_Type is
      record
         Control              : Control_Register_Type;
         Status               : Status_Register_Type;
         Data_Length          : Data_Length_Register_Type;
         Slave_Address        : Slave_Address_Register_Type;
         Data_FIFO            : Data_FIFO_Register_Type;
         Clock_Divider        : Clock_Divider_Register_Type;
         Data_Delay           : Data_Delay_Register_Type;
         Clock_Strech_Timeout : Clock_Stretch_Timeout_Register_Type;
      end record;

   for I2C_Address_Map_Type use
      record
         Control              at 16#00# range 00 .. SIZE_DWORD - 1;
         Status               at 16#04# range 00 .. SIZE_DWORD - 1;
         Data_Length          at 16#08# range 00 .. SIZE_DWORD - 1;
         Slave_Address        at 16#0C# range 00 .. SIZE_DWORD - 1;
         Data_FIFO            at 16#10# range 00 .. SIZE_DWORD - 1;
         Clock_Divider        at 16#14# range 00 .. SIZE_DWORD - 1;
         Data_Delay           at 16#18# range 00 .. SIZE_DWORD - 1;
         Clock_Strech_Timeout at 16#1C# range 00 .. SIZE_DWORD - 1;
      end record;

end RASPBERRYADA.BSC;
