package body Tackle.UTF8_Strings.Codepoint_Iterators is
   function First (Container : UTF8_String) return Cursor is
   begin
      if Container.Byte_Length > 0 then
         return (Index => 1);
      else
         return No_Element;
      end if;
   end First;

   function Has_Element (Position : Cursor) return Boolean is
   begin
      return Position /= No_Element;
   end Has_Element;

   function Next (Container : UTF8_String; Position : Cursor) return Cursor is
   begin
      if Position.Index = 0 then
         return No_Element;
      end if;

      declare
         Lead_Byte : constant Byte := Container.Bytes (Position.Index);
         Length : constant UTF8_Sequence_Length := Sequence_Length (Lead_Byte);
         Next_Index : constant Positive := Position.Index + Positive (Length);
      begin
         if Next_Index <= Container.Byte_Length then
            return (Index => Next_Index);
         else
            return No_Element;
         end if;
      end;
   end Next;

   function Element (Container : UTF8_String; Position : Cursor) return Codepoint is
   begin
      if not Has_Element (Position) then
         raise Constraint_Error with "Element called with No_Element";
      end if;

      declare
         Lead_Byte : constant Byte := Container.Bytes (Position.Index);
         Length : constant UTF8_Sequence_Length := Sequence_Length (Lead_Byte);
         CP : Codepoint_Internal;
      begin
         case Length is
            when 1 =>
               CP := Codepoint_Internal (Lead_Byte and 2#0111_1111#);
            when 2 =>
               CP := Shift_Left (Codepoint_Internal (Lead_Byte and 2#0001_1111#), 6) or
                     Continuation_Bits (Container.Bytes (Position.Index + 1));
            when 3 =>
               CP := Shift_Left (Codepoint_Internal (Lead_Byte and 2#0000_1111#), 12) or
                     Shift_Left (Continuation_Bits (Container.Bytes (Position.Index + 1)), 6) or
                     Continuation_Bits (Container.Bytes (Position.Index + 2));
            when 4 =>
               CP := Shift_Left (Codepoint_Internal (Lead_Byte and 2#0000_0111#), 18) or
                     Shift_Left (Continuation_Bits (Container.Bytes (Position.Index + 1)), 12) or
                     Shift_Left (Continuation_Bits (Container.Bytes (Position.Index + 2)), 6) or
                     Continuation_Bits (Container.Bytes (Position.Index + 3));
         end case;

         return Codepoint (CP);
      end;
   end Element;
end Tackle.UTF8_Strings.Codepoint_Iterators;
