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
   type Control_Type is
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
   pragma Pack (Control_Type);
   for Control_Type'Size use SIZE_DWORD;

   --+--------------------------------------------------------------------------
   --| The status register is used to record activity status, errors and
   --| interrupt requests.
   --+--------------------------------------------------------------------------
   type Status_Type is
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
   pragma Pack (Status_Type);
   for Status_Type'Size use SIZE_DWORD;

   type I2C_Address_Map_Type is
      record
         Control              : Control_Type;
         Status               : Status_Type;
         Data_Lenght          : Data_Length_Type;
         Slave_Address        : Slave_Address_Type;
         Data_FIFO            : Data_Fifo_Type;
         Clock_Divider        : Clock_Divider_Type;
         Data_Delay           : Data_Delay_Type;
         Clock_Strech_Timeout : Clock_Strech_Timeout_Type;
      end record;

end RASPBERRYADA.BSC;
