package body Tackle.Results is
   function Success (Value : Value_Type) return Result is
   begin
      return (Status => Success,
              Value => Value);
   end Success;

   function Failure (Error : Error_Type) return Result is
   begin
      return (Status => Failure,
              Error => Error);
   end Failure;
end Tackle.Results;
