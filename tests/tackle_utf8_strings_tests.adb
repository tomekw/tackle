with AUnit.Assertions; use AUnit.Assertions;
with AUnit.Test_Cases; use AUnit.Test_Cases;

with Tackle.UTF8_Strings;

package body Tackle_UTF8_Strings_Tests is
   use Tackle;

   overriding
   function Name (Unused_T : Test_Case) return Message_String is
   begin
      return Format ("Tackle.UTF8_Strings");
   end Name;

   overriding
   procedure Register_Tests (T : in out Test_Case) is
   begin
      Registration.Register_Routine (T, Test_Empty_String'Access, "Empty string has zero length and count");
      Registration.Register_Routine (T, Test_ASCII_String'Access, "ASCII string byte length equals codepoint count");
      Registration.Register_Routine (T, Test_3_Byte_String'Access, "3-byte codepoint has 3 bytes and 1 codepoint");
      Registration.Register_Routine (T, Test_Emoji'Access, "4-byte emoji has 4 bytes and 1 codepoint");
      Registration.Register_Routine (T, Test_Byte_Length'Access, "Returns proper byte length");
      Registration.Register_Routine (T, Test_Codepoint_Count'Access, "Returns proper codepoint count");
      Registration.Register_Routine (T, Test_Invalid_Lead_Byte'Access, "Raises on invalid lead byte");
      Registration.Register_Routine (T, Test_Truncated_Byte_Sequence'Access, "Raises on truncated byte sequence");
      Registration.Register_Routine (T, Test_Invalid_Continuation_Byte'Access, "Raises on invalid continuation byte");
      Registration.Register_Routine (T, Test_Overlong_Encoding'Access, "Raises on overlong encoding");
      Registration.Register_Routine (T, Test_Surrogate_Codepoint'Access, "Raises on surrogate codepoint");
      Registration.Register_Routine (T, Test_Codepoint_Out_Of_Range'Access, "Raises on codepoint out of range");
      Registration.Register_Routine (T, Test_To_String'Access, "Returns a proper Ada string");
      Registration.Register_Routine (T, Test_To_String_On_Empty'Access, "Returns an empty string");
      Registration.Register_Routine (T, Test_To_Codepoint'Access, "Returns a codepoint");
      Registration.Register_Routine (T, Test_To_Codepoint_On_Multibyte'Access, "Returns a multibyte codepoint");
      Registration.Register_Routine (T, Test_To_Codepoint_On_Empty'Access, "Raises on empty string");
      Registration.Register_Routine (T, Test_To_Codepoint_On_Too_Long'Access, "Raises on too long string");
      Registration.Register_Routine (T, Test_Equals_Codepoint_To_Character'Access, "Compares Codepoint to Character");
      Registration.Register_Routine (T, Test_1_Byte_Codepoint_To_String'Access, "Returns 1 byte String");
      Registration.Register_Routine (T, Test_2_Bytes_Codepoint_To_String'Access, "Returns 2 byte String");
      Registration.Register_Routine (T, Test_3_Bytes_Codepoint_To_String'Access, "Returns 3 byte String");
      Registration.Register_Routine (T, Test_4_Bytes_Codepoint_To_String'Access, "Returns 4 byte String");
      Registration.Register_Routine (T, Test_Surrogate_Codepoint_To_String'Access, "Raises on surrogate codepoint");
   end Register_Tests;

   procedure Test_Empty_String (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("");
   begin
      Assert (S.Byte_Length = 0, "Expected Byte_Length: 0");
      Assert (S.Codepoint_Count = 0, "Expected Codepoint_Count: 0");
   end Test_Empty_String;

   procedure Test_ASCII_String (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("ASCII");
   begin
      Assert (S.Byte_Length = 5, "Expected Byte_Length: 5");
      Assert (S.Codepoint_Count = 5, "Expected Codepoint_Count: 5");
   end Test_ASCII_String;

   procedure Test_3_Byte_String (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From
        ([Character'Val (16#E4#), Character'Val (16#B8#), Character'Val (16#AD#)]);
   begin
      Assert (S.Byte_Length = 3, "Expected Byte_Length: 3");
      Assert (S.Codepoint_Count = 1, "Expected Codepoint_Count: 1");
   end Test_3_Byte_String;

   procedure Test_Emoji (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From
        ([Character'Val (16#F0#), Character'Val (16#9F#), Character'Val (16#98#), Character'Val (16#84#)]);
   begin
      Assert (S.Byte_Length = 4, "Expected Byte_Length: 4");
      Assert (S.Codepoint_Count = 1, "Expected Codepoint_Count: 1");
   end Test_Emoji;

   procedure Test_Byte_Length (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("Cześć");
   begin
      Assert (S.Byte_Length = 7, "Expected Byte_Length: 7");
   end Test_Byte_Length;

   procedure Test_Codepoint_Count (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("Cześć");
   begin
      Assert (S.Codepoint_Count = 5, "Expected Codepoint_Count: 5");
   end Test_Codepoint_Count;

   procedure Invalid_Lead_Byte is
      Unused_S : UTF8_Strings.UTF8_String := UTF8_Strings.From ([Character'Val (16#FF#)]);
   begin
      null;
   end Invalid_Lead_Byte;

   procedure Test_Invalid_Lead_Byte (Unused_T : in out Test_Cases.Test_Case'Class) is
   begin
      Assert_Exception (Invalid_Lead_Byte'Access, "Expected Encoding_Error raised");
   end Test_Invalid_Lead_Byte;

   procedure Truncated_Byte_Sequence is
      Unused_S : UTF8_Strings.UTF8_String := UTF8_Strings.From ([Character'Val (16#C2#)]);
   begin
      null;
   end Truncated_Byte_Sequence;

   procedure Test_Truncated_Byte_Sequence (Unused_T : in out Test_Cases.Test_Case'Class) is
   begin
      Assert_Exception (Truncated_Byte_Sequence'Access, "Expected Encoding_Error raised");
   end Test_Truncated_Byte_Sequence;

   procedure Invalid_Continuation_Byte is
      Unused_S : UTF8_Strings.UTF8_String := UTF8_Strings.From ([Character'Val (16#C2#), Character'Val (16#00#)]);
   begin
      null;
   end Invalid_Continuation_Byte;

   procedure Test_Invalid_Continuation_Byte (Unused_T : in out Test_Cases.Test_Case'Class) is
   begin
      Assert_Exception (Invalid_Continuation_Byte'Access, "Expected Encoding_Error raised");
   end Test_Invalid_Continuation_Byte;

   procedure Overlong_Encoding is
      Unused_S : UTF8_Strings.UTF8_String := UTF8_Strings.From ([Character'Val (16#C0#), Character'Val (16#80#)]);
   begin
      null;
   end Overlong_Encoding;

   procedure Test_Overlong_Encoding (Unused_T : in out Test_Cases.Test_Case'Class) is
   begin
      Assert_Exception (Overlong_Encoding'Access, "Expected Encoding_Error raised");
   end Test_Overlong_Encoding;

   procedure Surrogate_Codepoint is
      Unused_S : UTF8_Strings.UTF8_String :=
        UTF8_Strings.From ([Character'Val (16#ED#), Character'Val (16#A0#), Character'Val (16#80#)]);
   begin
      null;
   end Surrogate_Codepoint;

   procedure Test_Surrogate_Codepoint (Unused_T : in out Test_Cases.Test_Case'Class) is
   begin
      Assert_Exception (Surrogate_Codepoint'Access, "Expected Encoding_Error raised");
   end Test_Surrogate_Codepoint;

   procedure Codepoint_Out_Of_Range is
      Unused_S : UTF8_Strings.UTF8_String :=
        UTF8_Strings.From ([Character'Val (16#F4#), Character'Val (16#90#), Character'Val (16#80#), Character'Val (16#80#)]);
   begin
      null;
   end Codepoint_Out_Of_Range;

   procedure Test_Codepoint_Out_Of_Range (Unused_T : in out Test_Cases.Test_Case'Class) is
   begin
      Assert_Exception (Codepoint_Out_Of_Range'Access, "Expected Encoding_Error raised");
   end Test_Codepoint_Out_Of_Range;

   procedure Test_To_String (Unused_T : in out Test_Cases.Test_Case'Class) is
      Input : constant String := "Cześć";
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From (Input);
   begin
      Assert (S.To_String = Input, "Expected: Cześć");
   end Test_To_String;

   procedure Test_To_String_On_Empty (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : UTF8_Strings.UTF8_String;
   begin
      Assert (S.To_String = "", "Expected: empty string");
   end Test_To_String_On_Empty;

   procedure Test_To_Codepoint (Unused_T : in out Test_Cases.Test_Case'Class) is
      use UTF8_Strings;

      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint ("A");
   begin
      Assert (C = 16#41#, "Expected: 16#41#");
   end Test_To_Codepoint;

   procedure Test_To_Codepoint_On_Multibyte (Unused_T : in out Test_Cases.Test_Case'Class) is
      use UTF8_Strings;

      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint ("Ą");
   begin
      Assert (C = 16#104#, "Expected: 16#104#");
   end Test_To_Codepoint_On_Multibyte;

   procedure To_Codepoint_On_Empty is
      Unused_C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint ("");
   begin
      null;
   end To_Codepoint_On_Empty;

   procedure Test_To_Codepoint_On_Empty (Unused_T : in out Test_Cases.Test_Case'Class) is
   begin
      Assert_Exception (To_Codepoint_On_Empty'Access, "Expected Encoding_Error raised");
   end Test_To_Codepoint_On_Empty;

   procedure To_Codepoint_On_Too_Long is
      Unused_C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint ("Hello");
   begin
      null;
   end To_Codepoint_On_Too_Long;

   procedure Test_To_Codepoint_On_Too_Long (Unused_T : in out Test_Cases.Test_Case'Class) is
   begin
      Assert_Exception (To_Codepoint_On_Too_Long'Access, "Expected Encoding_Error raised");
   end Test_To_Codepoint_On_Too_Long;

   procedure Test_Equals_Codepoint_To_Character (Unused_T : in out Test_Cases.Test_Case'Class) is
      use UTF8_Strings;

      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint (";");
   begin
      Assert (C = ';', "Expected: ;");
      Assert (C /= ',', "Not expected: ;");
   end Test_Equals_Codepoint_To_Character;

   procedure Test_1_Byte_Codepoint_To_String (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant String := "A";
      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint (S);
   begin
      Assert (UTF8_Strings.To_String (C) = S, "Expected: " & S);
   end Test_1_Byte_Codepoint_To_String;

   procedure Test_2_Bytes_Codepoint_To_String (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant String := "Ą";
      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint (S);
   begin
      Assert (UTF8_Strings.To_String (C) = S, "Expected: " & S);
   end Test_2_Bytes_Codepoint_To_String;

   procedure Test_3_Bytes_Codepoint_To_String (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant String :=
        [Character'Val (16#E4#), Character'Val (16#B8#), Character'Val (16#AD#)];
      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint (S);
   begin
      Assert (UTF8_Strings.To_String (C) = S, "Expected: " & S);
   end Test_3_Bytes_Codepoint_To_String;

   procedure Test_4_Bytes_Codepoint_To_String (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant String :=
        [Character'Val (16#F0#), Character'Val (16#9F#), Character'Val (16#98#), Character'Val (16#84#)];
      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint (S);
   begin
      Assert (UTF8_Strings.To_String (C) = S, "Expected: " & S);
   end Test_4_Bytes_Codepoint_To_String;

   procedure Surrogate_Codepoint_To_String is
      use UTF8_Strings;

      C : constant UTF8_Strings.Codepoint := Codepoint (16#D800#);
      Unused_S : constant String := UTF8_Strings.To_String (C);
   begin
      null;
   end Surrogate_Codepoint_To_String;

   procedure Test_Surrogate_Codepoint_To_String (Unused_T : in out Test_Cases.Test_Case'Class) is
   begin
      Assert_Exception (Surrogate_Codepoint_To_String'Access, "Expected Encoding_Error raised");
   end Test_Surrogate_Codepoint_To_String;
end Tackle_UTF8_Strings_Tests;
