with Testy.Tests;

package Tackle_Opts_Tests is
   use Testy.Tests;

   procedure Test_Valid_Options (T : in out Test_Context);
   procedure Test_Invalid_Option (T : in out Test_Context);
   procedure Test_Missing_Argument (T : in out Test_Context);
   procedure Test_Missing_Arguments (T : in out Test_Context);
   procedure Test_Valid_Commands (T : in out Test_Context);
   procedure Test_Invalid_Passthrough (T : in out Test_Context);
end Tackle_Opts_Tests;
