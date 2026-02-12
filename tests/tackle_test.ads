with AUnit.Test_Cases;

package Tackle_Test is

   type Test_Case is new AUnit.Test_Cases.Test_Case
     with null record;

   overriding
   function Name
     (Unused_T : Test_Case)
      return AUnit.Message_String;

   overriding
   procedure Register_Tests (T : in out Test_Case);

private

   procedure Test_True
     (Unused_T : in out AUnit.Test_Cases.Test_Case'Class);

end Tackle_Test;
