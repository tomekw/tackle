with Tackle.UTF8_Strings;
with Tackle.UTF8_Strings.Codepoint_Iterators;

package body Tackle_Codepoint_Iterators_Tests is
   use Tackle;
   use Tackle.UTF8_Strings;
   use Tackle.UTF8_Strings.Codepoint_Iterators;

   procedure Test_First_On_Empty_String (T : in out Test_Context) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("");
   begin
      T.Expect (Codepoint_Iterators.First (S) = No_Element, "Expected: No_Element");
   end Test_First_On_Empty_String;

   procedure Test_Has_Element_On_No_Element (T : in out Test_Context) is
   begin
      T.Expect (not Codepoint_Iterators.Has_Element (No_Element), "Expected: False");
   end Test_Has_Element_On_No_Element;

   procedure Test_Next_On_No_Element (T : in out Test_Context) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("Hello");
   begin
      T.Expect (Codepoint_Iterators.Next (S, No_Element) = No_Element, "Expected: No_Element");
   end Test_Next_On_No_Element;

   procedure Element_On_No_Element is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("");
      Unused_C : constant Codepoint := Codepoint_Iterators.Element (S, No_Element);
   begin
      null;
   end Element_On_No_Element;

   procedure Test_Element_On_No_Element (T : in out Test_Context) is
   begin
      T.Expect_Raises (Element_On_No_Element'Access, Constraint_Error'Identity);
   end Test_Element_On_No_Element;

   procedure Test_Iterate_Over_ASCII (T : in out Test_Context) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("Bar");
      Expected : constant array (Positive range <>) of Codepoint :=
        [To_Codepoint ("B"),
          To_Codepoint ("a"),
          To_Codepoint ("r")];
      C : Cursor := Codepoint_Iterators.First (S);
   begin
      for I in Expected'Range loop
         T.Expect (Has_Element (C), "Expected element at position " & I'Image);
         T.Expect (Element (S, C) = Expected (I), "Wrong codepoint at position " & I'Image);

         C := Next (S, C);
      end loop;

      T.Expect (not Has_Element (C), "Expected no more elements after last");
   end Test_Iterate_Over_ASCII;

   procedure Test_Iterate_Over_Mixed (T : in out Test_Context) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("€r😀Ą");
      Expected : constant array (Positive range <>) of Codepoint :=
        [To_Codepoint ("€"),
          To_Codepoint ("r"),
          To_Codepoint ("😀"),
          To_Codepoint ("Ą")];
      C : Cursor := Codepoint_Iterators.First (S);
   begin
      for I in Expected'Range loop
         T.Expect (Has_Element (C), "Expected element at position " & I'Image);
         T.Expect (Element (S, C) = Expected (I), "Wrong codepoint at position " & I'Image);

         C := Next (S, C);
      end loop;

      T.Expect (not Has_Element (C), "Expected no more elements after last");
   end Test_Iterate_Over_Mixed;
end Tackle_Codepoint_Iterators_Tests;
