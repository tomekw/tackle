# Tackle [![Tests](https://github.com/tomekw/tackle/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/tomekw/tackle/actions/workflows/test.yml)

Or TACkLe. Or Tomek's Ada Class Library. Everything I find useful and I think should be a part of the (extended) standard library.

## Status

This is alpha software. I'm actively working it. YMMV.

In the future, I may split it into multiple libraries.

Tested on Linux x86_64, MacOS ARM, OpenBSD x86_64 and Windows x86_64.

## Usage

The best is to use it with [tada](https://github.com/tomekw/tada).

For now, it provides these packages:

* `Tackle.Targets` - Architecture and Operating system information.
* `Tackle.UTF8_Strings` - UTF8 strings in Ada. Use `String` as a literal vehicle and for IO. `UTF8_String` is eagerly validated for truncated sequences, improper continuation bytes, overlong encoding, surrogate and range checks. Raises `Encoding_Error` if invalid. For now, read the package spec.
* `Tackle.UTF8_Strings.Codepoint_Iterators` - `Ada.Containers`-like `Cursor` API to traverse `UTF8_String` codepoint by codepoint.  Example:

  ```ada
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
