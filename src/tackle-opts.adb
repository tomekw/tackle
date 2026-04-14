with Ada.Characters.Conversions;
with Ada.Command_Line;
with Ada.Text_IO;

package body Tackle.Opts is
   function Consume_Arguments return Argument_List is
      Arguments : Argument_List;
   begin
      for I in 1 .. Ada.Command_Line.Argument_Count loop
         Arguments.Append (Ada.Command_Line.Argument (I));
      end loop;

      return Arguments;
   end Consume_Arguments;

   function Arg (Long_Name : String; Short_Name : Character; Description : String) return Option is
      use String_Holders;
   begin
      return (Kind => Argument,
              Long_Name_Holder => To_Holder (Long_Name),
              Short_Name => Short_Name,
              Description_Holder => To_Holder (Description));
   end Arg;

   function Flag (Long_Name : String; Short_Name : Character; Description : String) return Option is
      use String_Holders;
   begin
      return (Kind => Flag,
              Long_Name_Holder => To_Holder (Long_Name),
              Short_Name => Short_Name,
              Description_Holder => To_Holder (Description));
   end Flag;

   function Cmd (Name : String; Description : String; Options : Option_List; Passthrough : Boolean := False) return Command is
   begin
      return (Name_Holder => String_Holders.To_Holder (Name),
              Description_Holder => String_Holders.To_Holder (Description),
              Options_Holder => Option_List_Holders.To_Holder (Options),
              Passthrough => Passthrough);
   end Cmd;

   function Arg (R : Result; Key : String; Default : String := "") return String is
      use Param_Maps;

      C : constant Cursor := R.Params.Find (Key);
   begin
      if C /= No_Element then
         declare
            Opt : constant Parsed_Option := Element (C);
         begin
            case Opt.Kind is
               when Argument =>
                  return Opt.Value.Element;
               when Flag =>
                  return Default;
            end case;
         end;
      end if;

      return Default;
   end Arg;

   function Has_Flag (R : Result; Key : String) return Boolean is
      use Param_Maps;

      C : constant Cursor := R.Params.Find (Key);
   begin
      if C /= No_Element then
         declare
            Opt : constant Parsed_Option := Element (C);
         begin
            case Opt.Kind is
               when Argument =>
                  return False;
               when Flag =>
                  return True;
            end case;
         end;
      end if;

      return False;
   end Has_Flag;

   function Cmd (R : Result) return String is
   begin
      return R.Command_Holder.Element;
   end Cmd;

   function Passthrough_Args (R : Result) return Argument_List is
   begin
      return R.Passthrough_Arguments;
   end Passthrough_Args;

   function Long_Name (Opt : Option) return String is
   begin
      return Opt.Long_Name_Holder.Element;
   end Long_Name;

   function Description (Opt : Option) return String is
   begin
      return Opt.Description_Holder.Element;
   end Description;

   procedure Option_Put_Image
      (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
       Value : Option)
   is
      use Ada.Characters.Conversions;
   begin
      Buffer.Wide_Wide_Put ("--" & To_Wide_Wide_String (Value.Long_Name));
      Buffer.Wide_Wide_Put (", ");
      Buffer.Wide_Wide_Put ("-" & To_Wide_Wide_String (String'(1 => Value.Short_Name)));

      case Value.Kind is
         when Argument =>
            Buffer.Wide_Wide_Put (" <" & To_Wide_Wide_String (Value.Long_Name) & ">");
         when Flag =>
            null;
      end case;
   end Option_Put_Image;

   function Overlaps (Left, Right : Option) return Boolean is
   begin
      return (Left.Long_Name = Right.Long_Name or else
              Left.Short_Name = Right.Short_Name);
   end Overlaps;

   procedure Validate (Options : Option_List) is
   begin
      for I in Options'Range loop
         for J in I + 1 .. Options'Last loop
            if Options (I).Overlaps (Options (J)) then
               raise Option_Error with "overlapping options: " & Options (I)'Image & " and " & Options (J)'Image;
            end if;
         end loop;
      end loop;
   end Validate;

   function Argument_List_Slice (Arguments : Argument_List; Low : Positive; High : Positive) return Argument_List is
      Result : Argument_List;
   begin
      for I in Low .. High loop
         Result.Append (Arguments (I));
      end loop;

      return Result;
   end Argument_List_Slice;

   function Parse (Arguments : Argument_List; Options : Option_List) return Result is
      use String_Holders;

      R : Result := (Command_Holder => To_Holder (""),
                     Params => Param_Maps.Empty_Map,
                     Passthrough_Arguments => []);

      Implicit_Help : constant Option := (Kind => Flag,
                                          Long_Name_Holder => To_Holder ("help"),
                                          Short_Name => 'h',
                                          Description_Holder => To_Holder ("Help"));

      Current_Arg_Index : Positive := Arguments.First_Index;

      function Find_Long_Option (Name : String) return Option is
      begin
         for I in Options'Range loop
            if Options (I).Long_Name = Name then
               return Options (I);
            end if;
         end loop;

         if Name = "help" then
            return Implicit_Help;
         end if;

         raise Option_Error with "unrecognized option: " & Name;
      end Find_Long_Option;

      function Find_Short_Option (Name : String) return Option is
      begin
         if Name'Length /= 1 then
            raise Option_Error with "invalid option: " & Name;
         end if;

         for I in Options'Range loop
            if Options (I).Short_Name = Name (Name'First) then
               return Options (I);
            end if;
         end loop;

         if Name = "h" then
            return Implicit_Help;
         end if;

         raise Option_Error with "unrecognized option: " & Name;
      end Find_Short_Option;

      procedure Register_Option (Opt : Option) is
      begin
         case Opt.Kind is
            when Argument =>
               if Current_Arg_Index + 1 <= Arguments.Last_Index then
                  declare
                     Next_Arg : constant String := Arguments (Current_Arg_Index + 1);
                  begin
                     if Next_Arg (Next_Arg'First) /= '-' then
                        R.Params.Insert (Opt.Long_Name,
                                         (Kind => Argument, Value => To_Holder (Arguments (Current_Arg_Index + 1))));
                     else
                        raise Option_Error with "option '" & Opt.Long_Name & "' requires an argument";
                     end if;
                  end;
               else
                  raise Option_Error with "option '" & Opt.Long_Name & "' requires an argument";
               end if;

               Current_Arg_Index := Current_Arg_Index + 2;
            when Flag  =>
               R.Params.Insert (Opt.Long_Name, (Kind => Flag));

               Current_Arg_Index := Current_Arg_Index + 1;
         end case;
      end Register_Option;
   begin
      Validate (Options);

      while Current_Arg_Index <= Arguments.Last_Index loop
         declare
            Arg : constant String := Arguments (Current_Arg_Index);
         begin
            if Arg = "--" and then
               Current_Arg_Index + 1 <= Arguments.Last_Index
            then
               R.Passthrough_Arguments := Argument_List_Slice (Arguments, Current_Arg_Index + 1, Arguments.Last_Index);

               return R;
            elsif Arg'Length > 2 and then Arg (Arg'First .. Arg'First + 1) = "--" then
               Register_Option (Find_Long_Option (Arg (Arg'First + 2 .. Arg'Last)));
            elsif Arg'Length > 1 and then
               Arg (Arg'First) = '-' and then
               Arg (Arg'First + 1) /= '-'
            then
               Register_Option (Find_Short_Option (Arg (Arg'First + 1 .. Arg'Last)));
            else
               raise Option_Error with "unrecognized option: " & Arg;
            end if;
         end;
      end loop;

      return R;
   end Parse;

   function Name (Cmd : Command) return String is
   begin
      return Cmd.Name_Holder.Element;
   end Name;

   function Description (Cmd : Command) return String is
   begin
      return Cmd.Description_Holder.Element;
   end Description;

   function Parse (Arguments : Argument_List; Commands : Command_List) return Result is
      function Find_Command (Name : String) return Command is
      begin
         for I in Commands'Range loop
            if Commands (I).Name = Name then
               return Commands (I);
            end if;
         end loop;

         raise Option_Error with "unrecognized command: " & Name;
      end Find_Command;
   begin
      if Arguments.Is_Empty or else
         Arguments.First_Element (Arguments.First_Element'First) = '-'
      then
         return Parse (Arguments, Option_List'[]);
      end if;

      declare
         R : Result;
         Cmd : constant Command := Find_Command (Arguments.First_Element);
         Tail_Arguments : constant Argument_List :=
            Argument_List_Slice (Arguments, Arguments.First_Index + 1, Arguments.Last_Index);
      begin
         R := Parse (Tail_Arguments, Cmd.Options_Holder.Element);
         R.Command_Holder := String_Holders.To_Holder (Cmd.Name);

         return R;
      end;
   end Parse;

   procedure Print_Usage (Program_Name : String; Options : Option_List) is
      use Ada;

      Max_Option_Length : Natural := 0;
   begin
       Text_IO.Put_Line (Text_IO.Standard_Error, "Usage: " & Program_Name & " [options]");
       Text_IO.New_Line (Text_IO.Standard_Error);
       Text_IO.Put_Line (Text_IO.Standard_Error, "Options:");

       for Opt of Options loop
          if Opt'Image'Length > Max_Option_Length then
             Max_Option_Length := Opt'Image'Length;
          end if;
       end loop;

       declare
          Column_Length : constant Positive := 2 + Max_Option_Length + 4;
       begin
          for Opt of Options loop
             Text_IO.Set_Col (Text_IO.Standard_Error, 1);
             Text_IO.Put (Text_IO.Standard_Error, "  " & Opt'Image);
             Text_IO.Set_Col (Text_IO.Standard_Error, Text_IO.Positive_Count (Column_Length));
             Text_IO.Put_Line (Text_IO.Standard_Error, Opt.Description);
          end loop;
       end;
   end Print_Usage;

   procedure Print_Usage (Command_Name : String; Program_Name : String; Commands : Command_List) is
      use Ada;

      function Find_Command return Command is
      begin
         for I in Commands'Range loop
            if Commands (I).Name = Command_Name then
               return Commands (I);
            end if;
         end loop;

         raise Option_Error with "unrecognized command: " & Command_Name;
      end Find_Command;
   begin
      if Command_Name = "" then
         declare
            Max_Command_Length : Natural := 0;
         begin
            Text_IO.Put_Line (Text_IO.Standard_Error, "Usage: " & Program_Name & " <command> [options]");
            Text_IO.New_Line (Text_IO.Standard_Error);
            Text_IO.Put_Line (Text_IO.Standard_Error, "Commands:");

            for Cmd of Commands loop
               if Cmd.Name'Length > Max_Command_Length then
                  Max_Command_Length := Cmd.Name'Length;
               end if;
            end loop;

            declare
               Column_Length : constant Positive := 2 + Max_Command_Length + 4;
            begin
               for Cmd of Commands loop
                  Text_IO.Set_Col (Text_IO.Standard_Error, 1);
                  Text_IO.Put (Text_IO.Standard_Error, "  " & Cmd.Name);
                  Text_IO.Set_Col (Text_IO.Standard_Error, Text_IO.Positive_Count (Column_Length));
                  Text_IO.Put_Line (Text_IO.Standard_Error, Cmd.Description);
               end loop;
            end;
            Text_IO.New_Line (Text_IO.Standard_Error);
            Text_IO.Put_Line ("Run '" & Program_Name & " <command> --help' for command options");
         end;
      else
         declare
            Cmd : constant Command := Find_Command;
            P_Args : constant String := "-- <args>";
            Max_Option_Length : Natural := (if Cmd.Passthrough then P_Args'Length else 0);
         begin
            Text_IO.Put (Text_IO.Standard_Error, "Usage: " & Program_Name & " " & Command_Name & " [options]");
            if Cmd.Passthrough then
               Text_IO.Put_Line (Text_IO.Standard_Error, " [" & P_Args & "]");
            else
               Text_IO.New_Line (Text_IO.Standard_Error);
            end if;
            Text_IO.New_Line (Text_IO.Standard_Error);
            Text_IO.Put_Line (Text_IO.Standard_Error, "Options:");

            for Opt of Cmd.Options_Holder.Element loop
               if Opt'Image'Length > Max_Option_Length then
                  Max_Option_Length := Opt'Image'Length;
               end if;
            end loop;

            declare
               Column_Length : constant Positive := 2 + Max_Option_Length + 4;
            begin
               for Opt of Cmd.Options_Holder.Element loop
                  Text_IO.Set_Col (Text_IO.Standard_Error, 1);
                  Text_IO.Put (Text_IO.Standard_Error, "  " & Opt'Image);
                  Text_IO.Set_Col (Text_IO.Standard_Error, Text_IO.Positive_Count (Column_Length));
                  Text_IO.Put_Line (Text_IO.Standard_Error, Opt.Description);
               end loop;

               if Cmd.Passthrough then
                  Text_IO.Set_Col (Text_IO.Standard_Error, 1);
                  Text_IO.Put (Text_IO.Standard_Error, "  " & P_Args);
                  Text_IO.Set_Col (Text_IO.Standard_Error, Text_IO.Positive_Count (Column_Length));
                  Text_IO.Put_Line (Text_IO.Standard_Error, "Passthrough arguments");
               end if;
            end;
         end;
      end if;
   end Print_Usage;
end Tackle.Opts;
