generic
   type Value_Type is private;
   type Error_Type is private;
package Tackle.Results is
   type Result_Status is (Success, Failure);

   type Result (Status : Result_Status) is record
      case Status is
         when Success =>
            Value : Value_Type;
         when Failure =>
            Error : Error_Type;
      end case;
   end record;

   function Success (Value : Value_Type) return Result;

   function Failure (Error : Error_Type) return Result;
end Tackle.Results;
