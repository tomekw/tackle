with AUnit.Test_Cases;

package Tackle_UTF8_Strings_Tests is
   use AUnit;

   type Test_Case is new Test_Cases.Test_Case with null record;

   overriding
   function Name (Unused_T : Test_Case) return Message_String;

   overriding
   procedure Register_Tests (T : in out Test_Case);

private

   procedure Test_Byte_Length (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Codepoint_Count (Unused_T : in out Test_Cases.Test_Case'Class);
end Tackle_UTF8_Strings_Tests;
