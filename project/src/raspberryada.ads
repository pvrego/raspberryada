with Interfaces;

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

   --+--------------------------------------------------------------------------
   --| Spare Types
   --+--------------------------------------------------------------------------

   type Spare_Bit_Type is range 0 .. 0;
   type Spare_Type is array (Natural range <>) of Spare_Bit_Type;
   for Spare_Type'Component_Size use 1;

end RASPBERRYADA;
