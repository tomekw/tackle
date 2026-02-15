with Ada.Finalization;

package Tackle.UTF8_Strings is
   use Ada;

   Encoding_Error : exception;

   type UTF8_String is new Finalization.Limited_Controlled with private;

   function From (Source : String) return UTF8_String;

   function Byte_Length (Self : UTF8_String) return Natural;

   function Codepoint_Count (Self : UTF8_String) return Natural;
private

   type Byte is mod 2 ** 8;
   type Byte_Array is array (Positive range <>) of Byte;
   type Byte_Array_Access is access Byte_Array;

   type UTF8_String is new Finalization.Limited_Controlled with record
      Bytes : Byte_Array_Access;
      Codepoint_Count : Natural;
   end record;

   overriding procedure Finalize (Self : in out UTF8_String);
end Tackle.UTF8_Strings;
