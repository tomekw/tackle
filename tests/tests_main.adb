with Testy.Runners;
with Testy.Reporters.Text;

with Tackle_Codepoint_Iterators_Tests;
with Tackle_Targets_Tests;
with Tackle_UTF8_Strings_Tests;

procedure Tests_Main is
   use Testy;

   Test_Runner : Runners.Runner := Runners.Create;
   Test_Reporter : Reporters.Text.Text_Reporter;
begin
   Test_Runner.Add ("First on Empty returns No_Element",
                    Tackle_Codepoint_Iterators_Tests.Test_First_On_Empty_String'Access);
   Test_Runner.Add ("Has_Element on No_Element returns False",
                    Tackle_Codepoint_Iterators_Tests.Test_Has_Element_On_No_Element'Access);
   Test_Runner.Add ("Next on No_Element returns No_Element",
                    Tackle_Codepoint_Iterators_Tests.Test_Next_On_No_Element'Access);
   Test_Runner.Add ("Element on No_Element raises Constraint_Error",
                    Tackle_Codepoint_Iterators_Tests.Test_Element_On_No_Element'Access);
   Test_Runner.Add ("Iterate over ASCII returns each 1 byte codepoint",
                    Tackle_Codepoint_Iterators_Tests.Test_Iterate_Over_ASCII'Access);
   Test_Runner.Add ("Iterate over mixed string returns each X byte codepoint",
                    Tackle_Codepoint_Iterators_Tests.Test_Iterate_Over_Mixed'Access);

   Test_Runner.Add ("Target returns proper Architecture and Operating_System",
                    Tackle_Targets_Tests.Test_Target_Info'Access);

   Test_Runner.Add ("Empty string has zero Length and Codepoint_Count",
                    Tackle_UTF8_Strings_Tests.Test_Empty_String'Access);
   Test_Runner.Add ("ASCII string byte Length equals Codepoint_Count",
                    Tackle_UTF8_Strings_Tests.Test_ASCII_String'Access);
   Test_Runner.Add ("3-byte codepoint has 3 bytes and 1 codepoint",
                    Tackle_UTF8_Strings_Tests.Test_3_Byte_String'Access);
   Test_Runner.Add ("4-byte emoji has 4 bytes and 1 codepoint",
                    Tackle_UTF8_Strings_Tests.Test_Emoji'Access);
   Test_Runner.Add ("Returns proper byte length",
                    Tackle_UTF8_Strings_Tests.Test_Byte_Length'Access);
   Test_Runner.Add ("Returns proper codepoint count",
                    Tackle_UTF8_Strings_Tests.Test_Codepoint_Count'Access);
   Test_Runner.Add ("Raises Encoding_Error on invalid lead byte",
                    Tackle_UTF8_Strings_Tests.Test_Invalid_Lead_Byte'Access);
   Test_Runner.Add ("Raises Encoding_Error on truncated byte sequence",
                    Tackle_UTF8_Strings_Tests.Test_Truncated_Byte_Sequence'Access);
   Test_Runner.Add ("Raises Encoding_Error on invalid continuation byte",
                    Tackle_UTF8_Strings_Tests.Test_Invalid_Continuation_Byte'Access);
   Test_Runner.Add ("Raises Encoding_Error on overlong encoding",
                    Tackle_UTF8_Strings_Tests.Test_Overlong_Encoding'Access);
   Test_Runner.Add ("Raises Encoding_Error on surrogate codepoint",
                    Tackle_UTF8_Strings_Tests.Test_Surrogate_Codepoint'Access);
   Test_Runner.Add ("Raises Encoding_Error on codepoint out of range",
                    Tackle_UTF8_Strings_Tests.Test_Codepoint_Out_Of_Range'Access);
   Test_Runner.Add ("To_String returns Ada String",
                    Tackle_UTF8_Strings_Tests.Test_To_String'Access);
   Test_Runner.Add ("To_String on empty string returns empty String",
                    Tackle_UTF8_Strings_Tests.Test_To_String_On_Empty'Access);
   Test_Runner.Add ("To_Codepoint returns a codepoint",
                    Tackle_UTF8_Strings_Tests.Test_To_Codepoint'Access);
   Test_Runner.Add ("To_Codepoint returns a multibyte codepoint",
                    Tackle_UTF8_Strings_Tests.Test_To_Codepoint_On_Multibyte'Access);
   Test_Runner.Add ("To_Codepoint raises Encoding_Error on empty string",
                    Tackle_UTF8_Strings_Tests.Test_To_Codepoint_On_Empty'Access);
   Test_Runner.Add ("To_Codepoint raises Encoding_Error on too long string",
                    Tackle_UTF8_Strings_Tests.Test_To_Codepoint_On_Too_Long'Access);
   Test_Runner.Add ("Compares Codepoint to Character",
                    Tackle_UTF8_Strings_Tests.Test_Equals_Codepoint_To_Character'Access);
   Test_Runner.Add ("To_String on 1 byte Codepoint returns 1 byte String",
                    Tackle_UTF8_Strings_Tests.Test_1_Byte_Codepoint_To_String'Access);
   Test_Runner.Add ("To_String on 2 bytes Codepoint returns 2 bytes String",
                    Tackle_UTF8_Strings_Tests.Test_2_Bytes_Codepoint_To_String'Access);
   Test_Runner.Add ("To_String on 3 bytes Codepoint returns 3 bytes String",
                    Tackle_UTF8_Strings_Tests.Test_3_Bytes_Codepoint_To_String'Access);
   Test_Runner.Add ("To_String on 4 bytes Codepoint returns 4 bytes String",
                    Tackle_UTF8_Strings_Tests.Test_4_Bytes_Codepoint_To_String'Access);
   Test_Runner.Add ("To_String on surrogate codepoint raises Encoding_Error",
                    Tackle_UTF8_Strings_Tests.Test_Surrogate_Codepoint_To_String'Access);

   Test_Runner.Run (Test_Reporter);
end Tests_Main;
