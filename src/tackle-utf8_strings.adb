with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;

package body Tackle.UTF8_Strings is
   function To_Bytes (Source : String) return Byte_Array is
      subtype Source_String is String (Source'Range);
      subtype Source_Bytes  is Byte_Array (Source'Range);
      function Convert is new Unchecked_Conversion (Source_String, Source_Bytes);
   begin
      return Convert (Source);
   end To_Bytes;

   function Sequence_Length (Lead_Byte : Byte) return UTF8_Sequence_Length is
   begin
      if (Lead_Byte and 2#1000_0000#) = 2#0000_0000# then
         return 1;
      elsif (Lead_Byte and 2#1110_0000#) = 2#1100_0000# then
         return 2;
      elsif (Lead_Byte and 2#1111_0000#) = 2#1110_0000# then
         return 3;
      elsif (Lead_Byte and 2#1111_1000#) = 2#1111_0000# then
         return 4;
      else
         raise Encoding_Error with "invalid lead byte";
      end if;
   end Sequence_Length;

   function Continuation_Bits (B : Byte) return Codepoint_Internal is
   begin
      return Codepoint_Internal (B and 2#0011_1111#);
   end Continuation_Bits;

   function Decode (Bytes : Byte_Array; Position : Positive) return Codepoint is
      Lead_Byte : constant Byte := Bytes (Position);
      Length : constant UTF8_Sequence_Length := Sequence_Length (Lead_Byte);
      CP : Codepoint_Internal;
   begin
      for Offset in 1 .. Positive (Length) - 1 loop
         if (Bytes (Position + Offset) and 2#1100_0000#) /= 2#1000_0000# then
            raise Encoding_Error with "invalid continuation byte";
         end if;
      end loop;

      case Length is
         when 1 =>
            CP := Codepoint_Internal (Lead_Byte and 2#0111_1111#);
         when 2 =>
            CP := Shift_Left (Codepoint_Internal (Lead_Byte and 2#0001_1111#), 6) or
                  Continuation_Bits (Bytes (Position + 1));

            if CP < 16#0080# then
               raise Encoding_Error with "overlong encoding";
            end if;
         when 3 =>
            CP := Shift_Left (Codepoint_Internal (Lead_Byte and 2#0000_1111#), 12) or
                  Shift_Left (Continuation_Bits (Bytes (Position + 1)), 6) or
                  Continuation_Bits (Bytes (Position + 2));

            if CP < 16#0800# then
               raise Encoding_Error with "overlong encoding";
            end if;
         when 4 =>
            CP := Shift_Left (Codepoint_Internal (Lead_Byte and 2#0000_0111#), 18) or
                  Shift_Left (Continuation_Bits (Bytes (Position + 1)), 12) or
                  Shift_Left (Continuation_Bits (Bytes (Position + 2)), 6) or
                  Continuation_Bits (Bytes (Position + 3));

            if CP < 16#1_0000# then
               raise Encoding_Error with "overlong encoding";
            end if;
      end case;

      if CP in 16#D800# .. 16#DFFF# then
         raise Encoding_Error with "surrogate codepoint";
      end if;

      if CP > 16#10_FFFF# then
         raise Encoding_Error with "codepoint out of range";
      end if;

      return Codepoint (CP);
   end Decode;

   function Validate (Bytes : Byte_Array) return Natural is
      Position : Positive := Bytes'First;
      Codepoint_Count : Natural := 0;
   begin
      while Position <= Bytes'Last loop
         declare
            Lead_Byte : constant Byte := Bytes (Position);
            Length : constant UTF8_Sequence_Length := Sequence_Length (Lead_Byte);
            Unused_Codepoint : Codepoint;
         begin
            if Position + Positive (Length) - 1 > Bytes'Last then
               raise Encoding_Error with "truncated byte sequence";
            end if;

            Unused_Codepoint := Decode (Bytes, Position);

            Codepoint_Count := Codepoint_Count + 1;
            Position := Position + Positive (Length);
         end;
      end loop;

      return Codepoint_Count;
   end Validate;

   function From (Source : String) return UTF8_String is
   begin
      return Result : UTF8_String do
         Result.Bytes := new Byte_Array'(To_Bytes (Source));
         Result.Codepoint_Count := Validate (Result.Bytes.all);
      end return;
   end From;

   function To_Codepoint (Source : String) return Codepoint is
   begin
      if Source'Length = 0 then
         raise Encoding_Error with "expected exactly one codepoint";
      end if;

      declare
         Bytes : constant Byte_Array := To_Bytes (Source);
         Length : constant UTF8_Sequence_Length := Sequence_Length (Bytes (Bytes'First));
      begin
         if Positive (Length) /= Bytes'Length then
            raise Encoding_Error with "expected exactly one codepoint";
         end if;

         return Decode (Bytes, Bytes'First);
      end;
   end To_Codepoint;

   function To_String (CP : Codepoint) return String is
      CP_Internal : constant Codepoint_Internal := Codepoint_Internal (CP);
   begin
      if CP_Internal in 16#D800# .. 16#DFFF# then
         raise Encoding_Error with "surrogate codepoint";
      end if;

      if CP_Internal <= 16#7F# then
         return [Character'Val (CP_Internal)];
      elsif CP_Internal <= 16#7FF# then
         return [Character'Val (Shift_Right (CP_Internal, 6) or 2#1100_0000#),
                  Character'Val ((CP_Internal and 2#0011_1111#) or 2#1000_0000#)];
      elsif CP_Internal <= 16#FFFF# then
         return [Character'Val (Shift_Right (CP_Internal, 12) or 2#1110_0000#),
                  Character'Val ((Shift_Right (CP_Internal, 6) and 2#0011_1111#) or 2#1000_0000#),
                  Character'Val ((CP_Internal and 2#0011_1111#) or 2#1000_0000#)];
      else
         return [Character'Val (Shift_Right (CP_Internal, 18) or 2#1111_0000#),
                  Character'Val ((Shift_Right (CP_Internal, 12) and 2#0011_1111#) or 2#1000_0000#),
                  Character'Val ((Shift_Right (CP_Internal, 6) and 2#0011_1111#) or 2#1000_0000#),
                  Character'Val ((CP_Internal and 2#0011_1111#) or 2#1000_0000#)];
      end if;
   end To_String;

   function Byte_Length (Self : UTF8_String) return Natural is
   begin
      if Self.Bytes = null then
         return 0;
      end if;

      return Self.Bytes.all'Length;
   end Byte_Length;

   function Codepoint_Count (Self : UTF8_String) return Natural is
   begin
      return Self.Codepoint_Count;
   end Codepoint_Count;

   function To_String (Self : UTF8_String) return String is
   begin
      if Self.Bytes = null then
         return "";
      end if;

      declare
         subtype Result_Bytes  is Byte_Array (Self.Bytes'Range);
         subtype Result_String is String (Self.Bytes'Range);
         function Convert is new Unchecked_Conversion (Result_Bytes, Result_String);
      begin
         return Convert (Self.Bytes.all);
      end;
   end To_String;

   function "=" (Left : Codepoint; Right : Character) return Boolean is
   begin
      return Left = Character'Pos (Right);
   end "=";

   overriding procedure Adjust (Self : in out UTF8_String) is
   begin
      if Self.Bytes /= null then
         Self.Bytes := new Byte_Array'(Self.Bytes.all);
      end if;
   end Adjust;

   procedure Free is new Unchecked_Deallocation (Byte_Array, Byte_Array_Access);

   overriding procedure Finalize (Self : in out UTF8_String) is
   begin
      Free (Self.Bytes);
   end Finalize;
end Tackle.UTF8_Strings;
