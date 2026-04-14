# Tackle [![Tests](https://github.com/tomekw/tackle/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/tomekw/tackle/actions/workflows/test.yml)

Or TACkLe. Or Tomek's Ada Class Library. Everything I find useful and I think should be a part of the (extended) standard library.

## Status

This is alpha software. I'm actively working it. YMMV.

In the future, I may split it into multiple libraries.

Tested on Linux x86_64, MacOS ARM, OpenBSD x86_64 and Windows x86_64.

## Usage

The best is to use it with [tada](https://github.com/tomekw/tada).

For now, it provides these packages:

### `Tackle.MIME`

A curated MIME type database.

  ``` ada
  with Ada.Text_IO;
  with Tackle.MIME

  procedure Demo is
     use Ada;
     use Tackle;

     Mime_DB : constant MIME.Database := MIME.Init;
  begin
     Text_IO.Put_Line (Mime_DB.Mime_Type ("txt")); --  "text/plain"
     Text_IO.Put_Line (Mime_DB.Mime_Type ("foo", "foo/bar")); --  "foo/bar"
  end Demo;
  ```

### `Tackle.Opts`

Declarative command line arguments parser.

Options:

  ``` ada
  with Ada.Text_IO;
  with Tackle.Opts;

  procedure Opts_Demo is
     use Ada;
     use Tackle;

     Options : constant Opts.Option_List := [Opts.Arg ("alpha", 'a', "Do alpha stuff"),
                                             Opts.Arg ("beta",  'b', "Do beta stuff"),
                                             Opts.Flag ("charlie", 'c', "Has charlie flag")];

     Arguments : constant Opts.Argument_List := Opts.Consume_Arguments;

     Result : constant Opts.Result := Opts.Parse (Arguments, Options);
  begin
     --  Help is implicit unless provided
     if Result.Has_Flag ("help") then
        Opts.Print_Usage ("opts_demo", Options);

        return;
     end if;

     Text_IO.Put_Line ("Alpha: " & Result.Arg ("alpha"));
     Text_IO.Put_Line ("Beta: " & Result.Arg ("beta"));
     Text_IO.Put_Line ("Charlie?: " & Result.Has_Flag ("beta")'Image);
  end Opts_Demo;
  ```

  ``` shell
  $ ./opts_demo --help
  Usage: opts_demo [options]

  Options:
    --alpha, -a <alpha>   Do alpha stuff
    --beta, -b <beta>     Do beta stuff
    --charlie, -c         Has charlie flag
  ```

  ``` shell
  $ ./opts_demo --alpha Yes -b No --charlie
  Alpha: Yes
  Beta: No
  Charlie?: FALSE
  ```

Commands:

  ``` ada
  procedure Opts_Demo is
     use Ada;
     use Tackle;

     Commands : constant Opts.Command_List := [Opts.Cmd ("alpha", "Do alpha stuff",
                                                         [Opts.Flag ("yes", 'y', "Yes?")]),
                                               Opts.Cmd ("beta", "Do beta stuff",
                                                         [Opts.Arg ("foo", 'f', "Foo!")], Passthrough => True)];

     Arguments : constant Opts.Argument_List := Opts.Consume_Arguments;

     Result : constant Opts.Result := Opts.Parse (Arguments, Commands);
  begin
     --  Help is implicit unless provided
     if Result.Cmd = "" or else
        Result.Has_Flag ("help")
     then
        Opts.Print_Usage (Result.Cmd, "opts_demo", Commands);

        return;
     end if;

     if Result.Cmd = "beta" then
        Text_IO.Put_Line ("Passthrough args: " & Result.Passthrough_Args'Image);
     end if;
  end Opts_Demo;
  ```

  ``` shell
  $ ./opts_demo --help
  Usage: opts_demo <command> [options]

  Commands:
    alpha   Do alpha stuff
    beta    Do beta stuff

  Run 'opts_demo <command> --help' for command options
  ```

  ``` shell
  $ ./opts_demo beta --help
  Usage: opts_demo beta [options] [-- <args>]

  Options:
    --foo, -f <foo>   Foo!
    -- <args>         Passthrough arguments
  ```

  ``` shell
  $ ./opts_demo beta --foo Bar -- baz qux
  Passthrough args:
  ["baz", "qux"]
  ```

### `Tackle.Targets`

Architecture and operating system information.

  ``` ada
  with Ada.Text_IO;
  with Tackle.Targets

  procedure Demo is
     use Ada;
     use Tackle;

     Target_Info : constant Targets.Target := Targets.Init;
  begin
     Text_IO.Put_Line (Target_Info.Architecture'Image); --  "x86_64"
     Text_IO.Put_Line (Target_Info.Operating_System'Image); --  "openbsd"
  end Demo;
  ```

### `Tackle.UTF8_Strings`

UTF8 strings in Ada. Use `String` as a literal vehicle and for IO. `UTF8_String` is eagerly validated for truncated sequences, improper continuation bytes, overlong encoding, surrogate and range checks. Raises `Encoding_Error` if invalid. For now, read the package spec.

### `Tackle.UTF8_Strings.Codepoint_Iterators`

`Ada.Containers`-like `Cursor` API to traverse `UTF8_String` codepoint by codepoint.  Example:

  ``` ada
  with Ada.Text_IO;
  with Tackle.UTF8_Strings;
  with Tackle.UTF8_Strings.Codepoint_Iterators;

  procedure Demo is
     use Ada;
     use Tackle.UTF8_Strings;
     use Tackle.UTF8_Strings.Codepoint_Iterators;

     S : constant UTF8_String := From ("Cześć! 😀");
     C : Cursor := First (S);
  begin
     while Has_Element (C) loop
        declare
           CP : constant Codepoint := Element (S, C);
        begin
           Text_IO.Put_Line (To_String (CP));
        end;
        C := Next (S, C);
     end loop;
  end Demo;
  ```

## Building

``` shell
tada build [--profile release|debug]
```

## Testing

``` shell
tada test [--profile release|debug]
```

## Disclaimer

This codebase is written by hand. Claude Code is used for Socratic design exploration and code review.

## License

[EUPL](LICENSE)
