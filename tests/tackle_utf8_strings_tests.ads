with AUnit.Test_Cases;

package Tackle_UTF8_Strings_Tests is
   use AUnit;

   type Test_Case is new Test_Cases.Test_Case with null record;

   overriding
   function Name (Unused_T : Test_Case) return Message_String;

   overriding
   procedure Register_Tests (T : in out Test_Case);

private

   procedure Test_Empty_String (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_ASCII_String (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_3_Byte_String (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Emoji (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Byte_Length (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Codepoint_Count (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Invalid_Lead_Byte (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Truncated_Byte_Sequence (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Invalid_Continuation_Byte (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Overlong_Encoding (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Surrogate_Codepoint (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Codepoint_Out_Of_Range (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_To_String (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_To_String_On_Empty (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_To_Codepoint (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_To_Codepoint_On_Multibyte (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_To_Codepoint_On_Empty (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_To_Codepoint_On_Too_Long (Unused_T : in out Test_Cases.Test_Case'Class);
end Tackle_UTF8_Strings_Tests;
