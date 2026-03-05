package body Tackle_Results_Tests is
   use Integer_Results;

   procedure Test_Success (T : in out Test_Context) is
      V : constant Integer := 42;
      R : constant Result := Success (V);
   begin
      T.Expect (R.Status = Success, "Expected Status: Success");
      T.Expect (R.Value = V, "Expected Value: 42");
   end Test_Success;

   procedure Test_Failure (T : in out Test_Context) is
      E : constant Boolean := False;
      R : constant Result := Failure (E);
   begin
      T.Expect (R.Status = Failure, "Expected Status: Failure");
      T.Expect (R.Error = E, "Expected Error: False");
   end Test_Failure;

   procedure Error_On_Success is
      Unused_E : Boolean;
   begin
      Unused_E := Success (42).Error;
   end Error_On_Success;

   procedure Test_Exception_When_Error_On_Success (T : in out Test_Context) is
   begin
      T.Expect_Raises (Error_On_Success'Access, Constraint_Error'Identity);
   end Test_Exception_When_Error_On_Success;

   procedure Value_On_Failure is
      Unused_V : Integer;
   begin
      Unused_V := Failure (False).Value;
   end Value_On_Failure;

   procedure Test_Exception_When_Value_On_Failure (T : in out Test_Context) is
   begin
      T.Expect_Raises (Value_On_Failure'Access, Constraint_Error'Identity);
   end Test_Exception_When_Value_On_Failure;
end Tackle_Results_Tests;
