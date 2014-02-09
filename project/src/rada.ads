package RADA is

   --+--------------------------------------------------------------------------
   --| The AUXIRQ  register is used to check any pending interrupts which may be
   --| asserted by the three Auxiliary sub blocks.
   --+--------------------------------------------------------------------------
   type Auxiliary_Interrupt_Status_Type is
      record
         -- If set the mini UART has an interrupt pending.
         Mini_Uart_IRQ : Boolean;
         -- If set the SPI1 module has an interrupt pending. Read.
         SPI_1_IRQ     : Boolean;
         -- If set the SPI 2 module has an interrupt pending. Read.
         SPI_2_IRQ     : Boolean;
      end record;
   pragma Pack (Auxiliary_Interrupt_Status_Type);
   for Auxiliary_Interrupt_Status_Type'Size use 3;

   type Auxiliary_Peripherals_Register_Map_Type is
      record
         AUX_IRQ            : Auxiliary_Interrupt_Status_Type;
         --           AUX_ENABLES        : Auxiliary_Enables_Type;
         --           AUX_MU_IO_REG      : Mini_Uart_IO_Data_Type;
         --           AUX_MU_IER_REG     : Mini_Uart_Interrupt_Enable_Type;
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
         AUX_IRQ at 5000 range 00 .. 02;
      end record;

end RADA;
