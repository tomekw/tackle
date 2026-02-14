with AUnit.Test_Cases;

with Tackle.Results;

package Tackle_Results_Tests is
   use AUnit;
   use Tackle;

   type Test_Case is new Test_Cases.Test_Case with null record;

   overriding
   function Name (Unused_T : Test_Case) return Message_String;

   overriding
   procedure Register_Tests (T : in out Test_Case);

   package Integer_Results is new Results (Integer, Boolean);

private

   procedure Test_Success (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Failure (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Exception_When_Error_On_Success (Unused_T : in out Test_Cases.Test_Case'Class);

   procedure Test_Exception_When_Value_On_Failure (Unused_T : in out Test_Cases.Test_Case'Class);

end Tackle_Results_Tests;
