# Tackle

Or TACkLe. Or Tomek's Ada Class Library. Eveyrthing I find useful and I think should be a part of the (extended) standard library.

## Status

This is alpha software. I'm actively working it. YMMV.

In the future, I may split it into multiple libraries.

Tested on Linux x86_64, MacOS ARM and Windows x86_64.

## Usage

The best is to use it with [tada](https://github.com/tomekw/tada). Tada doesn't support dependencies yet, so, actually, the best way is to clone the code and use the provided `tackle.gpr`.

For now, it provides these packages:

* `Tackle.Results` - generic `Result` type. `Success` and `Failure`. For now, read the package spec.
* `Tackle.UTF8_Strings` - UTF8 strings in Ada. Use `String` as a literal vehicle and for IO. `UTF8_String` is eagerly validated for truncated sequences, improper continuation bytes, overlong encoding, surrogate and range checks. Raises `Encoding_Error` if invalid. For now, read the package spec.
* `Tackle.UTF8_Strings.Codepoint_Iterators` - (soon) - `Ada.Containers`-like `Cursor` API to traverse `UTF8_String` codepoint by codepoint.

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

[MIT](LICENSE)
