with AUnit.Assertions; use AUnit.Assertions;
with AUnit.Test_Cases; use AUnit.Test_Cases;

with Tackle.UTF8_Strings;
with Tackle.UTF8_Strings.Codepoint_Iterators;

package body Tackle_Codepoint_Iterators_Tests is
   use Tackle;
   use Tackle.UTF8_Strings;
   use Tackle.UTF8_Strings.Codepoint_Iterators;

   overriding
   function Name (Unused_T : Test_Case) return Message_String is
   begin
      return Format ("Tackle.UTF8_Strings.Codepoint_Iterators");
   end Name;

   overriding
   procedure Register_Tests (T : in out Test_Case) is
   begin
      Registration.Register_Routine (T, Test_First_On_Empty_String'Access, "Returns No_Element");
      Registration.Register_Routine (T, Test_Has_Element_On_No_Element'Access, "Returns False");
      Registration.Register_Routine (T, Test_Next_On_No_Element'Access, "Returns No_Element");
      Registration.Register_Routine (T, Test_Element_On_No_Element'Access, "Raises Constraint_Error");
      Registration.Register_Routine (T, Test_Iterate_Over_ASCII'Access, "Returns each 1 byte codepoint");
      Registration.Register_Routine (T, Test_Iterate_Over_Mixed'Access, "Returns each X byte codepoint");
   end Register_Tests;

   procedure Test_First_On_Empty_String (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("");
   begin
      Assert (Codepoint_Iterators.First (S) = No_Element, "Expected: No_Element");
   end Test_First_On_Empty_String;

   procedure Test_Has_Element_On_No_Element (Unused_T : in out Test_Cases.Test_Case'Class) is
   begin
      Assert (not Codepoint_Iterators.Has_Element (No_Element), "Expected: False");
   end Test_Has_Element_On_No_Element;

   procedure Test_Next_On_No_Element (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("Hello");
   begin
      Assert (Codepoint_Iterators.Next (S, No_Element) = No_Element, "Expected: No_Element");
   end Test_Next_On_No_Element;

   procedure Element_On_No_Element is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("");
      Unused_C : constant Codepoint := Codepoint_Iterators.Element (S, No_Element);
   begin
      null;
   end Element_On_No_Element;

   procedure Test_Element_On_No_Element (Unused_T : in out Test_Cases.Test_Case'Class) is
   begin
      Assert_Exception (Element_On_No_Element'Access, "Expected Constraint_Error raised");
   end Test_Element_On_No_Element;

   procedure Test_Iterate_Over_ASCII (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("Bar");
      Expected : constant array (Positive range <>) of Codepoint :=
        [To_Codepoint ("B"),
          To_Codepoint ("a"),
          To_Codepoint ("r")];
      C : Cursor := Codepoint_Iterators.First (S);
   begin
      for I in Expected'Range loop
         Assert (Has_Element (C), "Expected element at position " & I'Image);
         Assert (Element (S, C) = Expected (I), "Wrong codepoint at position " & I'Image);

         C := Next (S, C);
      end loop;

      Assert (not Has_Element (C), "Expected no more elements after last");
   end Test_Iterate_Over_ASCII;

   procedure Test_Iterate_Over_Mixed (Unused_T : in out Test_Cases.Test_Case'Class) is
      S : constant UTF8_Strings.UTF8_String := UTF8_Strings.From ("€r😀Ą");
      Expected : constant array (Positive range <>) of Codepoint :=
        [To_Codepoint ("€"),
          To_Codepoint ("r"),
          To_Codepoint ("😀"),
          To_Codepoint ("Ą")];
      C : Cursor := Codepoint_Iterators.First (S);
   begin
      for I in Expected'Range loop
         Assert (Has_Element (C), "Expected element at position " & I'Image);
         Assert (Element (S, C) = Expected (I), "Wrong codepoint at position " & I'Image);

         C := Next (S, C);
      end loop;

      Assert (not Has_Element (C), "Expected no more elements after last");
   end Test_Iterate_Over_Mixed;
end Tackle_Codepoint_Iterators_Tests;
