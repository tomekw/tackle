with Ada.Strings.Fixed;

pragma Warnings (Off, "gnatwi");
with System.OS_Constants;
pragma Warnings (On, "gnatwi");

package body Tackle.Targets is
   procedure Arch_Put_Image
      (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
       Value : Architecture_Kind)
   is
   begin
      case Value is
         when Aarch64 => Buffer.Wide_Wide_Put ("aarch64");
         when X86_64 => Buffer.Wide_Wide_Put ("x86_64");
         when Unknown => Buffer.Wide_Wide_Put ("unknown");
      end case;
   end Arch_Put_Image;

   procedure OS_Put_Image
      (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
       Value : Operating_System_Kind)
   is
   begin
      case Value is
         when FreeBSD => Buffer.Wide_Wide_Put ("freebsd");
         when Linux => Buffer.Wide_Wide_Put ("linux");
         when MacOS => Buffer.Wide_Wide_Put ("macos");
         when OpenBSD => Buffer.Wide_Wide_Put ("openbsd");
         when Windows => Buffer.Wide_Wide_Put ("windows");
         when Unknown => Buffer.Wide_Wide_Put ("unknown");
      end case;
   end OS_Put_Image;

   function Init return Target is
      use Ada.Strings.Fixed;

      Target_Name : constant String := System.OS_Constants.Target_Name;
      Result : Target;
   begin
      if Index (Target_Name, "aarch64") = Target_Name'First then
         Result.Architecture := Aarch64;
      elsif Index (Target_Name, "x86_64") = Target_Name'First then
         Result.Architecture := X86_64;
      else
         Result.Architecture := Unknown;
      end if;

      if Index (Target_Name, "freebsd") /= 0 then
         Result.Operating_System := FreeBSD;
      elsif Index (Target_Name, "linux") /= 0 then
         Result.Operating_System := Linux;
      elsif Index (Target_Name, "apple") /= 0 then
         Result.Operating_System := MacOS;
      elsif Index (Target_Name, "openbsd") /= 0 then
         Result.Operating_System := OpenBSD;
      elsif Index (Target_Name, "mingw") /= 0 then
         Result.Operating_System := Windows;
      else
         Result.Operating_System := Unknown;
      end if;

      return Result;
   end Init;

   function Architecture (Self : Target) return Architecture_Kind is
   begin
      return Self.Architecture;
   end Architecture;

   function Operating_System (Self : Target) return Operating_System_Kind is
   begin
      return Self.Operating_System;
   end Operating_System;
end Tackle.Targets;
