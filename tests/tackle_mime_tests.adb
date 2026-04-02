with Tackle.MIME;

package body Tackle_MIME_Tests is
   use Tackle;

   procedure Test_MIME_Exists (T : in out Test_Context) is
      Mime_DB : constant MIME.Database := MIME.Init;
      Actual : constant String := Mime_DB.Mime_Type ("txt");
   begin
      T.Expect (Actual = "text/plain", "Expected: text/plain, got: " & Actual);
   end Test_MIME_Exists;

   procedure Test_MIME_Does_Not_Exist (T : in out Test_Context) is
      Mime_DB : constant MIME.Database := MIME.Init;
      Actual : constant String := Mime_DB.Mime_Type ("foo");
   begin
      T.Expect (Actual = "", "Expected: """", got: " & Actual);
   end Test_MIME_Does_Not_Exist;

   procedure Test_MIME_Does_Not_Exist_With_Default (T : in out Test_Context) is
      Mime_DB : constant MIME.Database := MIME.Init;
      Actual : constant String := Mime_DB.Mime_Type ("foo", "foo/bar");
   begin
      T.Expect (Actual = "foo/bar", "Expected: foo/bar, got: " & Actual);
   end Test_MIME_Does_Not_Exist_With_Default;
end Tackle_MIME_Tests;
