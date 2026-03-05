with Testy.Tests;

package Tackle_UTF8_Strings_Tests is
   use Testy.Tests;

   procedure Test_Empty_String (T : in out Test_Context);

   procedure Test_ASCII_String (T : in out Test_Context);

   procedure Test_3_Byte_String (T : in out Test_Context);

   procedure Test_Emoji (T : in out Test_Context);

   procedure Test_Byte_Length (T : in out Test_Context);

   procedure Test_Codepoint_Count (T : in out Test_Context);

   procedure Test_Invalid_Lead_Byte (T : in out Test_Context);

   procedure Test_Truncated_Byte_Sequence (T : in out Test_Context);

   procedure Test_Invalid_Continuation_Byte (T : in out Test_Context);

   procedure Test_Overlong_Encoding (T : in out Test_Context);

   procedure Test_Surrogate_Codepoint (T : in out Test_Context);

   procedure Test_Codepoint_Out_Of_Range (T : in out Test_Context);

   procedure Test_To_String (T : in out Test_Context);

   procedure Test_To_String_On_Empty (T : in out Test_Context);

   procedure Test_To_Codepoint (T : in out Test_Context);

   procedure Test_To_Codepoint_On_Multibyte (T : in out Test_Context);

   procedure Test_To_Codepoint_On_Empty (T : in out Test_Context);

   procedure Test_To_Codepoint_On_Too_Long (T : in out Test_Context);

   procedure Test_Equals_Codepoint_To_Character (T : in out Test_Context);

   procedure Test_1_Byte_Codepoint_To_String (T : in out Test_Context);

   procedure Test_2_Bytes_Codepoint_To_String (T : in out Test_Context);

   procedure Test_3_Bytes_Codepoint_To_String (T : in out Test_Context);

   procedure Test_4_Bytes_Codepoint_To_String (T : in out Test_Context);

   procedure Test_Surrogate_Codepoint_To_String (T : in out Test_Context);
end Tackle_UTF8_Strings_Tests;
