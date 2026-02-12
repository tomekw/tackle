with Tackle_Test;

package body Tackle_Suite is

   Result : aliased AUnit.Test_Suites.Test_Suite;
   Test_1 : aliased Tackle_Test.Test_Case;

   function Suite return AUnit.Test_Suites.Access_Test_Suite
   is
   begin
      AUnit.Test_Suites.Add_Test
        (Result'Access, Test_1'Access);
      return Result'Access;
   end Suite;

end Tackle_Suite;
