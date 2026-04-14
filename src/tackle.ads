with Ada.Containers.Indefinite_Holders;

package Tackle is
   package String_Holders is new Ada.Containers.Indefinite_Holders
      (Element_Type => String);
end Tackle;
