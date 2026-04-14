with Tackle.Opts;

package body Tackle_Opts_Tests is
   use Tackle;
   use Tackle.Opts;

   Options : constant Option_List := [Arg  ("hostname", 'H', "Server hostname (default: localhost)"),
                                      Arg  ("port",     'p', "Server port (default: 1965)"),
                                      Arg  ("root",     'r', "Content root (default: ""content"" in the current directory)"),
                                      Arg  ("cert",     'c', "TLS certificate path (default: ""cert.pem"" in the current directory)"),
                                      Arg  ("key",      'k', "TLS key path (default: ""key.pem"" in the current directory)"),
                                      Flag ("help",     'h', "Print this message")];

   Commands : constant Command_List := [Cmd ("build", "Compile the package",
                                             [Arg ("profile", 'p', "Build profile, 'debug' or 'release'")]),
                                        Cmd ("cache", "Install the package to the local cache",
                                             [Flag ("force", 'f', "Overwrite cache")]),
                                        Cmd ("clean", "Remove build artifacts",
                                             []),
                                        Cmd ("config", "Display configuration",
                                             []),
                                        Cmd ("help", "Print this message",
                                             []),
                                        Cmd ("init", "Create a new package",
                                             [Arg ("name", 'n', "Package name"),
                                              Arg ("type", 't', "Package type, 'exe' or 'lib'")]),
                                        Cmd ("install", "Install dependencies",
                                             []),
                                        Cmd ("run", "Build and run the executable",
                                             [Arg ("profile", 'p', "Run profile, 'debug' or 'release'")],
                                             Passthrough => True),
                                        Cmd ("test", "Build and run the tests",
                                             [Arg ("profile", 'p', "Test profile, 'debug' or 'release'")]),
                                        Cmd ("version", "Display version",
                                             [])];

   procedure Test_Valid_Options (T : in out Test_Context) is
      Arguments : constant Argument_List :=
         ["-H", "example.com", "-p", "1024", "-r", "/var/gemini",
          "-c", "/etc/ssl/certs/cert.pem", "-k", "/etc/ssl/certs/key.pem", "--help"];
      Result : constant Opts.Result := Opts.Parse (Arguments, Options);
   begin
      T.Expect (Result.Arg ("hostname") = "example.com", "Hostname: expected example.com, got: " & Result.Arg ("hostname"));
      T.Expect (Result.Arg ("port") = "1024", "Port: expected 1024, got: " & Result.Arg ("port"));
      T.Expect (Result.Arg ("root") = "/var/gemini", "Content root: expected /var/gemini, got: " & Result.Arg ("root"));
      T.Expect (Result.Arg ("cert") = "/etc/ssl/certs/cert.pem", "Cert file: expected /etc/ssl/certs/cert.pem, got: " & Result.Arg ("cert"));
      T.Expect (Result.Arg ("key") = "/etc/ssl/certs/key.pem", "Key file: expected /etc/ssl/certs/key.pem, got: " & Result.Arg ("key"));

      T.Expect (Result.Has_Flag ("help"), "Help: expected flag to be set");
   end Test_Valid_Options;

   procedure Invalid_Option is
      Arguments : constant Argument_List := ["--foo"];
      Unused_Result : Opts.Result;
   begin
      Unused_Result := Opts.Parse (Arguments, Options);
   end Invalid_Option;

   procedure Test_Invalid_Option (T : in out Test_Context) is
   begin
      T.Expect_Raises (Invalid_Option'Access, Option_Error'Identity, "unrecognized option: foo");
   end Test_Invalid_Option;

   procedure Missing_Argument is
      Arguments : constant Argument_List := ["--hostname"];
      Unused_Result : Opts.Result;
   begin
      Unused_Result := Opts.Parse (Arguments, Options);
   end Missing_Argument;

   procedure Test_Missing_Argument (T : in out Test_Context) is
   begin
      T.Expect_Raises (Missing_Argument'Access, Option_Error'Identity, "option 'hostname' requires an argument");
   end Test_Missing_Argument;

   procedure Missing_Arguments is
      Arguments : constant Argument_List := ["--hostname", "--port"];
      Unused_Result : Opts.Result;
   begin
      Unused_Result := Opts.Parse (Arguments, Options);
   end Missing_Arguments;

   procedure Test_Missing_Arguments (T : in out Test_Context) is
   begin
      T.Expect_Raises (Missing_Arguments'Access, Option_Error'Identity, "option 'hostname' requires an argument");
   end Test_Missing_Arguments;

   procedure Test_Valid_Commands (T : in out Test_Context) is
      use type Argument_List;

      Arguments : constant Argument_List := ["run", "--profile", "release", "--", "foo", "bar"];
      Result : constant Opts.Result := Opts.Parse (Arguments, Commands);
   begin
      T.Expect (Result.Cmd = "run", "Cmd: expected: run, got: " & Result.Cmd);
      T.Expect (Result.Arg ("profile") = "release", "Profile: expected: release, got: " & Result.Arg ("profile"));
      T.Expect (Result.Passthrough_Args = ["foo", "bar"], "Passthrough args: expected: foo, bar, got: " & Result.Passthrough_Args'Image);
   end Test_Valid_Commands;

   procedure Invalid_Passthrough is
      Arguments : constant Argument_List := ["run", "--profile", "release", "--"];
      Unused_Result : Opts.Result;
   begin
      Unused_Result := Opts.Parse (Arguments, Commands);
   end Invalid_Passthrough;

   procedure Test_Invalid_Passthrough (T : in out Test_Context) is
   begin
      T.Expect_Raises (Invalid_Passthrough'Access, Option_Error'Identity, "unrecognized option: --");
   end Test_Invalid_Passthrough;
end Tackle_Opts_Tests;
