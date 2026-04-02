with Tackle.Targets;

package body Tackle_Targets_Tests is
   use Tackle;

   procedure Test_Target_Info (T : in out Test_Context) is
      use type Targets.Architecture_Kind;
      use type Targets.Operating_System_Kind;

      Actual : constant Targets.Target := Targets.Init;
   begin
      T.Expect (Actual.Architecture /= Targets.Unknown, "Expected Architecture not Unknown");
      T.Expect (Actual.Operating_System /= Targets.Unknown, "Expected Operating_System not Unknown");
      T.Expect (Actual.Architecture'Image /= "unknown", "Expected Architecture'Image not unknown");
      T.Expect (Actual.Operating_System'Image /= "unknown", "Expected Operating_System'Image not unknown");
   end Test_Target_Info;
end Tackle_Targets_Tests;
