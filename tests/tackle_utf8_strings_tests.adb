with Tackle.UTF8_Strings;

package body Tackle_UTF8_Strings_Tests is
   use Tackle;
   use Tackle.UTF8_Strings;

   procedure Test_Empty_String (T : in out Test_Context) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("");
   begin
      T.Expect (S.Byte_Length = 0, "Expected Byte_Length: 0");
      T.Expect (S.Codepoint_Count = 0, "Expected Codepoint_Count: 0");
   end Test_Empty_String;

   procedure Test_ASCII_String (T : in out Test_Context) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("ASCII");
   begin
      T.Expect (S.Byte_Length = 5, "Expected Byte_Length: 5");
      T.Expect (S.Codepoint_Count = 5, "Expected Codepoint_Count: 5");
   end Test_ASCII_String;

   procedure Test_3_Byte_String (T : in out Test_Context) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From
        ([Character'Val (16#E4#), Character'Val (16#B8#), Character'Val (16#AD#)]);
   begin
      T.Expect (S.Byte_Length = 3, "Expected Byte_Length: 3");
      T.Expect (S.Codepoint_Count = 1, "Expected Codepoint_Count: 1");
   end Test_3_Byte_String;

   procedure Test_Emoji (T : in out Test_Context) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From
        ([Character'Val (16#F0#), Character'Val (16#9F#), Character'Val (16#98#), Character'Val (16#84#)]);
   begin
      T.Expect (S.Byte_Length = 4, "Expected Byte_Length: 4");
      T.Expect (S.Codepoint_Count = 1, "Expected Codepoint_Count: 1");
   end Test_Emoji;

   procedure Test_Byte_Length (T : in out Test_Context) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("Cześć");
   begin
      T.Expect (S.Byte_Length = 7, "Expected Byte_Length: 7");
   end Test_Byte_Length;

   procedure Test_Codepoint_Count (T : in out Test_Context) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("Cześć");
   begin
      T.Expect (S.Codepoint_Count = 5, "Expected Codepoint_Count: 5");
   end Test_Codepoint_Count;

   procedure Invalid_Lead_Byte is
      Unused_S : UTF8_Strings.UTF8_String := UTF8_Strings.From ([Character'Val (16#FF#)]);
   begin
      null;
   end Invalid_Lead_Byte;

   procedure Test_Invalid_Lead_Byte (T : in out Test_Context) is
   begin
      T.Expect_Raises (Invalid_Lead_Byte'Access, Encoding_Error'Identity, "invalid lead byte");
   end Test_Invalid_Lead_Byte;

   procedure Truncated_Byte_Sequence is
      Unused_S : UTF8_Strings.UTF8_String := UTF8_Strings.From ([Character'Val (16#C2#)]);
   begin
      null;
   end Truncated_Byte_Sequence;

   procedure Test_Truncated_Byte_Sequence (T : in out Test_Context) is
   begin
      T.Expect_Raises (Truncated_Byte_Sequence'Access, Encoding_Error'Identity, "truncated byte sequence");
   end Test_Truncated_Byte_Sequence;

   procedure Invalid_Continuation_Byte is
      Unused_S : UTF8_Strings.UTF8_String := UTF8_Strings.From ([Character'Val (16#C2#), Character'Val (16#00#)]);
   begin
      null;
   end Invalid_Continuation_Byte;

   procedure Test_Invalid_Continuation_Byte (T : in out Test_Context) is
   begin
      T.Expect_Raises (Invalid_Continuation_Byte'Access, Encoding_Error'Identity, "invalid continuation byte");
   end Test_Invalid_Continuation_Byte;

   procedure Overlong_Encoding is
      Unused_S : UTF8_Strings.UTF8_String := UTF8_Strings.From ([Character'Val (16#C0#), Character'Val (16#80#)]);
   begin
      null;
   end Overlong_Encoding;

   procedure Test_Overlong_Encoding (T : in out Test_Context) is
   begin
      T.Expect_Raises (Overlong_Encoding'Access, Encoding_Error'Identity, "overlong encoding");
   end Test_Overlong_Encoding;

   procedure Surrogate_Codepoint is
      Unused_S : UTF8_Strings.UTF8_String :=
        UTF8_Strings.From ([Character'Val (16#ED#), Character'Val (16#A0#), Character'Val (16#80#)]);
   begin
      null;
   end Surrogate_Codepoint;

   procedure Test_Surrogate_Codepoint (T : in out Test_Context) is
   begin
      T.Expect_Raises (Surrogate_Codepoint'Access, Encoding_Error'Identity, "surrogate codepoint");
   end Test_Surrogate_Codepoint;

   procedure Codepoint_Out_Of_Range is
      Unused_S : UTF8_Strings.UTF8_String :=
        UTF8_Strings.From ([Character'Val (16#F4#), Character'Val (16#90#), Character'Val (16#80#), Character'Val (16#80#)]);
   begin
      null;
   end Codepoint_Out_Of_Range;

   procedure Test_Codepoint_Out_Of_Range (T : in out Test_Context) is
   begin
      T.Expect_Raises (Codepoint_Out_Of_Range'Access, Encoding_Error'Identity, "codepoint out of range");
   end Test_Codepoint_Out_Of_Range;

   procedure Test_To_String (T : in out Test_Context) is
      Input : constant String := "Cześć";
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From (Input);
   begin
      T.Expect (S.To_String = Input, "Expected: Cześć");
   end Test_To_String;

   procedure Test_To_String_On_Empty (T : in out Test_Context) is
      S : UTF8_Strings.UTF8_String;
   begin
      T.Expect (S.To_String = "", "Expected: empty string");
   end Test_To_String_On_Empty;

   procedure Test_To_Codepoint (T : in out Test_Context) is
      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint ("A");
   begin
      T.Expect (C = 16#41#, "Expected: 16#41#");
   end Test_To_Codepoint;

   procedure Test_To_Codepoint_On_Multibyte (T : in out Test_Context) is
      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint ("Ą");
   begin
      T.Expect (C = 16#104#, "Expected: 16#104#");
   end Test_To_Codepoint_On_Multibyte;

   procedure To_Codepoint_On_Empty is
      Unused_C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint ("");
   begin
      null;
   end To_Codepoint_On_Empty;

   procedure Test_To_Codepoint_On_Empty (T : in out Test_Context) is
   begin
      T.Expect_Raises (To_Codepoint_On_Empty'Access, Encoding_Error'Identity, "expected exactly one codepoint");
   end Test_To_Codepoint_On_Empty;

   procedure To_Codepoint_On_Too_Long is
      Unused_C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint ("Hello");
   begin
      null;
   end To_Codepoint_On_Too_Long;

   procedure Test_To_Codepoint_On_Too_Long (T : in out Test_Context) is
   begin
      T.Expect_Raises (To_Codepoint_On_Too_Long'Access, Encoding_Error'Identity, "expected exactly one codepoint");
   end Test_To_Codepoint_On_Too_Long;

   procedure Test_Equals_Codepoint_To_Character (T : in out Test_Context) is
      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint (";");
   begin
      T.Expect (C = ';', "Expected: ;");
      T.Expect (C /= ',', "Not expected: ;");
   end Test_Equals_Codepoint_To_Character;

   procedure Test_1_Byte_Codepoint_To_String (T : in out Test_Context) is
      S : constant String := "A";
      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint (S);
   begin
      T.Expect (UTF8_Strings.To_String (C) = S, "Expected: " & S);
   end Test_1_Byte_Codepoint_To_String;

   procedure Test_2_Bytes_Codepoint_To_String (T : in out Test_Context) is
      S : constant String := "Ą";
      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint (S);
   begin
      T.Expect (UTF8_Strings.To_String (C) = S, "Expected: " & S);
   end Test_2_Bytes_Codepoint_To_String;

   procedure Test_3_Bytes_Codepoint_To_String (T : in out Test_Context) is
      S : constant String :=
        [Character'Val (16#E4#), Character'Val (16#B8#), Character'Val (16#AD#)];
      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint (S);
   begin
      T.Expect (UTF8_Strings.To_String (C) = S, "Expected: " & S);
   end Test_3_Bytes_Codepoint_To_String;

   procedure Test_4_Bytes_Codepoint_To_String (T : in out Test_Context) is
      S : constant String :=
        [Character'Val (16#F0#), Character'Val (16#9F#), Character'Val (16#98#), Character'Val (16#84#)];
      C : constant UTF8_Strings.Codepoint := UTF8_Strings.To_Codepoint (S);
   begin
      T.Expect (UTF8_Strings.To_String (C) = S, "Expected: " & S);
   end Test_4_Bytes_Codepoint_To_String;

   procedure Surrogate_Codepoint_To_String is
      C : constant UTF8_Strings.Codepoint := Codepoint (16#D800#);
      Unused_S : constant String := UTF8_Strings.To_String (C);
   begin
      null;
   end Surrogate_Codepoint_To_String;

   procedure Test_Surrogate_Codepoint_To_String (T : in out Test_Context) is
   begin
      T.Expect_Raises (Surrogate_Codepoint_To_String'Access, Encoding_Error'Identity, "surrogate codepoint");
   end Test_Surrogate_Codepoint_To_String;
end Tackle_UTF8_Strings_Tests;
