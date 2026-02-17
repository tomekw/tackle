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
      Registration.Register_Routine (T, Test_Byte_Length'Access, "Returns proper byte length");
      Registration.Register_Routine (T, Test_Codepoint_Count'Access, "Returns proper codepoint count");
      Registration.Register_Routine (T, Test_Invalid_Lead_Byte'Access, "Raises on invalid lead byte");
      Registration.Register_Routine (T, Test_Truncated_Byte_Sequence'Access, "Raises on truncated byte sequence");
      Registration.Register_Routine (T, Test_Invalid_Continuation_Byte'Access, "Raises on invalid continuation byte");
      Registration.Register_Routine (T, Test_Overlong_Encoding'Access, "Raises on overlong encoding");
      Registration.Register_Routine (T, Test_Surrogate_Codepoint'Access, "Raises on surrogate codepoint");
      Registration.Register_Routine (T, Test_Codepoint_Out_Of_Range'Access, "Raises on codepoint out of range");
   end Register_Tests;

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
end Tackle_UTF8_Strings_Tests;
