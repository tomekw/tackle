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
end Tackle_UTF8_Strings_Tests;
