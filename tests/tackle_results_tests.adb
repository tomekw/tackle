with AUnit.Assertions; use AUnit.Assertions;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package body Tackle_Results_Tests is
   use Integer_Results;

   overriding
   function Name (Unused_T : Test_Case) return Message_String is
   begin
      return Format ("Tackle.Results");
   end Name;

   overriding
   procedure Register_Tests (T : in out Test_Case) is
   begin
      Registration.Register_Routine (T, Test_Success'Access, "Success returns Value");
      Registration.Register_Routine (T, Test_Failure'Access, "Failure returns Error");
      Registration.Register_Routine
        (T, Test_Exception_When_Error_On_Success'Access, "Raises when Error on Success");
      Registration.Register_Routine
        (T, Test_Exception_When_Value_On_Failure'Access, "Raises when Value on Failure");
   end Register_Tests;

   procedure Test_Success (Unused_T : in out Test_Cases.Test_Case'Class) is
      V : constant Integer := 42;
      R : constant Result := Success (V);
   begin
      Assert (R.Status = Success, "Expected Status: Success");
      Assert (R.Value = V, "Expected Value: 42");
   end Test_Success;

   procedure Test_Failure (Unused_T : in out Test_Cases.Test_Case'Class) is
      E : constant Boolean := False;
      R : constant Result := Failure (E);
   begin
      Assert (R.Status = Failure, "Expected Status: Failure");
      Assert (R.Error = E, "Expected Error: False");
   end Test_Failure;

   procedure Error_On_Success is
      Unused_E : Boolean;
   begin
      Unused_E := Success (42).Error;
   end Error_On_Success;

   procedure Test_Exception_When_Error_On_Success (Unused_T : in out Test_Cases.Test_Case'Class) is
   begin
      Assert_Exception (Error_On_Success'Access, "Expected exception");
   end Test_Exception_When_Error_On_Success;

   procedure Value_On_Failure is
      Unused_V : Integer;
   begin
      Unused_V := Failure (False).Value;
   end Value_On_Failure;

   procedure Test_Exception_When_Value_On_Failure (Unused_T : in out Test_Cases.Test_Case'Class) is
   begin
      Assert_Exception (Value_On_Failure'Access, "Expected exception");
   end Test_Exception_When_Value_On_Failure;
end Tackle_Results_Tests;
