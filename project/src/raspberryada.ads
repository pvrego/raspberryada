with Interfaces;
with System;

package RASPBERRYADA is

   --+--------------------------------------------------------------------------
   --| Constants
   --+--------------------------------------------------------------------------

   SIZE_BYTE  : constant := 8;
   SIZE_WORD  : constant := 16;
   SIZE_DWORD : constant := 32;

   --+--------------------------------------------------------------------------
   --| General Purpose Types
   --+--------------------------------------------------------------------------

   type Byte_Type is new Interfaces.Unsigned_8;
   for Byte_Type'Size use SIZE_BYTE;

   type Byte_Array_Type is array (0 .. 7) of Boolean;
   pragma Pack (Byte_Array_Type);
   for Byte_Array_Type'Size use SIZE_BYTE;

   type Word_Array_Type is array (0 .. 15) of Boolean;
   pragma Pack (Word_Array_Type);
   for Word_Array_Type'Size use SIZE_WORD;

   type Bit_Array_2_Type is array (0 .. 1) of Boolean;
   pragma Pack (Bit_Array_2_Type);
   for Bit_Array_2_Type'Size use 2;

   type Bit_Array_4_Type is array (0 .. 3) of Boolean;
   pragma Pack (Bit_Array_4_Type);
   for Bit_Array_4_Type'Size use 4;

   type Bit_Array_6_Type is array (0 .. 5) of Boolean;
   pragma Pack (Bit_Array_6_Type);
   for Bit_Array_6_Type'Size use 6;

   type Bit_Array_12_Type is array (0 .. 11) of Boolean;
   pragma Pack (Bit_Array_12_Type);
   for Bit_Array_12_Type'Size use 12;

   type Unsigned_6 is mod 2 ** 6;
   for Unsigned_6'Size use 6;

   type Unsigned_12 is mod 2 ** 12;
   for Unsigned_12'Size use 12;

   --+--------------------------------------------------------------------------
   --| Spare Types
   --+--------------------------------------------------------------------------

   type Spare_Bit_Type is new Boolean;
   for Spare_Bit_Type'Size use 1;

   type Spare_2_Bit_Array_Type is array (0 .. 1) of Spare_Bit_Type;
   pragma Pack (Spare_2_Bit_Array_Type);
   for Spare_2_Bit_Array_Type'Size use 2;

   type Spare_3_Bit_Array_Type is array (0 .. 2) of Spare_Bit_Type;
   pragma Pack (Spare_3_Bit_Array_Type);
   for Spare_3_Bit_Array_Type'Size use 3;

   type Spare_4_Bit_Array_Type is array (0 .. 3) of Spare_Bit_Type;
   pragma Pack (Spare_4_Bit_Array_Type);
   for Spare_4_Bit_Array_Type'Size use 4;

   type Spare_5_Bit_Array_Type is array (0 .. 4) of Spare_Bit_Type;
   pragma Pack (Spare_5_Bit_Array_Type);
   for Spare_5_Bit_Array_Type'Size use 5;

   type Spare_6_Bit_Array_Type is array (0 .. 5) of Spare_Bit_Type;
   pragma Pack (Spare_6_Bit_Array_Type);
   for Spare_6_Bit_Array_Type'Size use 6;

   type Spare_7_Bit_Array_Type is array (0 .. 6) of Spare_Bit_Type;
   pragma Pack (Spare_7_Bit_Array_Type);
   for Spare_7_Bit_Array_Type'Size use 7;

end RASPBERRYADA;
