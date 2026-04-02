with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings.Equal_Case_Insensitive;
with Ada.Strings.Hash_Case_Insensitive;

package Tackle.MIME is
   use Ada;

   type Database is private;

   function Init return Database;

   function Mime_Type (Self : Database; Extension : String; Default : String := "") return String;

private

   package Extension_To_Mime_Type_Maps is new Containers.Indefinite_Hashed_Maps
      (Key_Type => String,
       Element_Type => String,
       Hash => Strings.Hash_Case_Insensitive,
       Equivalent_Keys => Strings.Equal_Case_Insensitive);

   type Database is record
      Data : Extension_To_Mime_Type_Maps.Map;
   end record;
end Tackle.MIME;
