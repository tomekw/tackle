# Tackle

Or TACkLe. Or Tomek's Ada Class Library. Eveyrthing I find useful and I think should be a part of the (extended) standard library.

## Status

This is alpha software. I'm actively working it. YMMV.

In the future, I may split it into multiple libraries.

Tested on Linux x86_64, MacOS ARM and Windows x86_64.

## Usage

The best is to use it with [tada](https://github.com/tomekw/tada). Tada doesn't support dependencies yet, so, actually, the best way is to clone the code and use the provided `tackle.gpr`.

For now, it provides these packages:

* `Tackle.Results` - generic `Result` type. `Success` and `Failure`. For now, read the package spec. Example:

  ```ada
  with Ada.Text_IO;
  with Tackle.Results;

  procedure Demo is
     use Ada;

     type Math_Error is (Division_By_Zero);

     package Float_Results is new Tackle.Results
       (Value_Type => Float,
        Error_Type => Math_Error);

     use Float_Results;

     function Divide (A, B : Float) return Result is
     begin
        if B = 0.0 then
           return Failure (Division_By_Zero);
        end if;

        return Success (A / B);
     end Divide;

     procedure Print_Result (Label : String; R : Result) is
     begin
        Text_IO.Put (Label & ": ");
        case R.Status is
           when Success => Text_IO.Put_Line (R.Value'Image);
           when Failure => Text_IO.Put_Line ("error: " & R.Error'Image);
        end case;
     end Print_Result;
  begin
     Print_Result ("10.0 / 4.0", Divide (10.0, 4.0));
     Print_Result (" 1.0 / 0.0", Divide (1.0, 0.0));
  end Demo;
  ```

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
