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

   type Bit_Array_Type is array (Natural range <>) of Boolean;
   for Bit_Array_Type'Component_Size use 1;

   --+--------------------------------------------------------------------------
   --| Spare Types
   --+--------------------------------------------------------------------------

   type Spare_Bit_Type is private;
   type Spare_Type is array (Natural range <>) of Spare_Bit_Type;

private
   type Spare_Bit_Type is range 0 .. 0;
   for Spare_Type'Component_Size use 1;

end RASPBERRYADA;
