with Tackle_Results_Tests;
with Tackle_UTF8_Strings_Tests;

package body Tackle_Suite is

   Result : aliased AUnit.Test_Suites.Test_Suite;
   Tackle_Results : aliased Tackle_Results_Tests.Test_Case;
   Tackle_UTF8_Strings : aliased Tackle_UTF8_Strings_Tests.Test_Case;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
   begin
      AUnit.Test_Suites.Add_Test (Result'Access, Tackle_Results'Access);
      AUnit.Test_Suites.Add_Test (Result'Access, Tackle_UTF8_Strings'Access);
      return Result'Access;
   end Suite;

end Tackle_Suite;
