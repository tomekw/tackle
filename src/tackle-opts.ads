with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Indefinite_Holders;
with Ada.Containers.Indefinite_Vectors;
with Ada.Strings.Hash;
with Ada.Strings.Text_Buffers;

package Tackle.Opts is
   Option_Error : exception;

   package Argument_Vectors is new Ada.Containers.Indefinite_Vectors
      (Index_Type => Positive,
       Element_Type => String);

   subtype Argument_List is Argument_Vectors.Vector;

   type Option is private
      with Put_Image => Option_Put_Image;

   type Option_List is array (Positive range <>) of Option;

   type Command is private;

   type Command_List is array (Positive range <>) of Command;

   type Result is private;

   function Consume_Arguments return Argument_List;

   function Arg (Long_Name : String; Short_Name : Character; Description : String) return Option;
   function Flag (Long_Name : String; Short_Name : Character; Description : String) return Option;
   function Cmd (Name : String; Description : String; Options : Option_List; Passthrough : Boolean := False) return Command;

   function Arg (R : Result; Key : String; Default : String := "") return String;
   function Has_Flag (R : Result; Key : String) return Boolean;
   function Cmd (R : Result) return String;
   function Passthrough_Args (R : Result) return Argument_List;

   function Parse (Arguments : Argument_List; Options : Option_List) return Result;
   function Parse (Arguments : Argument_List; Commands : Command_List) return Result;

   procedure Print_Usage (Program_Name : String; Options : Option_List);
   procedure Print_Usage (Command_Name : String; Program_Name : String; Commands : Command_List);

   procedure Option_Put_Image
      (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
       Value : Option);

private

   type Option_Kind is (Argument, Flag);

   type Option is record
      Kind : Option_Kind;
      Long_Name_Holder : String_Holders.Holder;
      Short_Name : Character;
      Description_Holder : String_Holders.Holder;
   end record;

   package Option_List_Holders is new Ada.Containers.Indefinite_Holders
      (Element_Type => Option_List);

   type Command is record
      Name_Holder : String_Holders.Holder;
      Description_Holder : String_Holders.Holder;
      Options_Holder : Option_List_Holders.Holder;
      Passthrough : Boolean;
   end record;

   type Parsed_Option (Kind : Option_Kind) is record
      case Kind is
         when Argument =>
            Value : String_Holders.Holder;
         when Flag =>
            null;
      end case;
   end record;

   package Param_Maps is new Ada.Containers.Indefinite_Hashed_Maps
      (Key_Type => String,
       Element_Type => Parsed_Option,
       Hash => Ada.Strings.Hash,
       Equivalent_Keys => "=");

   type Result is record
      Command_Holder : String_Holders.Holder;
      Params : Param_Maps.Map;
      Passthrough_Arguments : Argument_List := [];
   end record;
end Tackle.Opts;
