with AUnit.Assertions; use AUnit.Assertions;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package body Tackle_Test is

   overriding
   function Name
     (Unused_T : Test_Case)
      return AUnit.Message_String
   is
   begin
      return AUnit.Format ("Tackle");
   end Name;

   overriding
   procedure Register_Tests (T : in out Test_Case) is
   begin
      Registration.Register_Routine
        (T, Test_True'Access,
         "True is True");
   end Register_Tests;

   procedure Test_True
     (Unused_T : in out AUnit.Test_Cases.Test_Case'Class)
   is
   begin
      Assert (True, "True is True");
   end Test_True;

end Tackle_Test;
