package Tackle.UTF8_Strings.Codepoint_Iterators is
   type Cursor is private;

   No_Element : constant Cursor;

   function First (Container : UTF8_String) return Cursor;

   function Has_Element (Position : Cursor) return Boolean;

   function Next (Container : UTF8_String; Position : Cursor) return Cursor;

   function Element (Container : UTF8_String; Position : Cursor) return Codepoint;

private

   type Cursor is record
      Index : Natural := 0;
   end record;

   No_Element : constant Cursor := (Index => 0);
end Tackle.UTF8_Strings.Codepoint_Iterators;
