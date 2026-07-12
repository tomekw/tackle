with Ada.Strings.Text_Buffers;

package Tackle.Targets is
   type Architecture_Kind is (Aarch64, X86_64, Unknown)
      with Put_Image => Arch_Put_Image;

   procedure Arch_Put_Image
      (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
       Value : Architecture_Kind);

   type Operating_System_Kind is (FreeBSD, Linux, MacOS, OpenBSD, Windows, Unknown)
      with Put_Image => OS_Put_Image;

   procedure OS_Put_Image
      (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
       Value : Operating_System_Kind);

   type Libc_Kind is (Musl, Other);

   procedure Libc_Put_Image
      (Buffer : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
       Value : Libc_Kind);

   type Target is private;

   function Init return Target;

   function Architecture (Self : Target) return Architecture_Kind;

   function Operating_System (Self : Target) return Operating_System_Kind;

   function Libc (Self : Target) return Libc_Kind;

private

   type Target is record
      Architecture : Architecture_Kind;
      Operating_System : Operating_System_Kind;
      Libc : Libc_Kind;
   end record;
end Tackle.Targets;
