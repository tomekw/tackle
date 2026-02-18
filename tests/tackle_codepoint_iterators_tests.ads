with AUnit.Test_Cases;

package Tackle_Codepoint_Iterators_Tests is
   use AUnit;

   type Test_Case is new Test_Cases.Test_Case with null record;

   overriding
   function Name (Unused_T : Test_Case) return Message_String;

   overriding
   procedure Register_Tests (T : in out Test_Case);

private

   procedure Test_First_On_Empty_String (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Has_Element_On_No_Element (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Next_On_No_Element (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Element_On_No_Element (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Iterate_Over_ASCII (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Iterate_Over_Mixed (Unused_T : in out Test_Cases.Test_Case'Class);
end Tackle_Codepoint_Iterators_Tests;
