with Testy.Tests;

with Tackle.Results;

package Tackle_Results_Tests is
   use Testy.Tests;
   use Tackle;

   package Integer_Results is new Results (Integer, Boolean);

   procedure Test_Success (T : in out Test_Context);

   procedure Test_Failure (T : in out Test_Context);

   procedure Test_Exception_When_Error_On_Success (T : in out Test_Context);

   procedure Test_Exception_When_Value_On_Failure (T : in out Test_Context);
end Tackle_Results_Tests;
