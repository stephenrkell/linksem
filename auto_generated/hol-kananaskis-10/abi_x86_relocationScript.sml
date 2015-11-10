(*Generated by Lem from abis/x86/abi_x86_relocation.lem.*)
open HolKernel Parse boolLib bossLib;
open lem_numTheory lem_basic_classesTheory lem_stringTheory showTheory;

val _ = numLib.prefer_num();



val _ = new_theory "abi_x86_relocation"

(** [abi_x86_relocation] contains X86 ABI specific definitions relating to
  * relocations.
  *)

(*open import Basic_classes*)
(*open import Num*)
(*open import String*)

(*open import Show*)

(** Relocation types. *)

val _ = Define `
 (r_386_none : num =( 0))`;

val _ = Define `
 (r_386_32 : num =( 1))`;

val _ = Define `
 (r_386_pc32 : num =( 2))`;

val _ = Define `
 (r_386_got32 : num =( 3))`;

val _ = Define `
 (r_386_plt32 : num =( 4))`;

val _ = Define `
 (r_386_copy : num =( 5))`;

val _ = Define `
 (r_386_glob_dat : num =( 6))`;

val _ = Define `
 (r_386_jmp_slot : num =( 7))`;

val _ = Define `
 (r_386_relative : num =( 8))`;

val _ = Define `
 (r_386_gotoff : num =( 9))`;

val _ = Define `
 (r_386_gotpc : num =( 10))`;


(** Found in the "wild" but not in the ABI docs: *)

val _ = Define `
 (r_386_tls_tpoff : num =( 14))`;

val _ = Define `
 (r_386_tls_dtpmod32 : num =( 35))`;

val _ = Define `
 (r_386_tls_dtpoff32 : num =( 36))`;

val _ = Define `
 (r_386_irelative : num =( 42))`;


(** [string_of_x86_relocation_type m] produces a string based representation of
  * X86 ABI relocation type [m].
  *)
(*val string_of_x86_relocation_type : natural -> string*)
val _ = Define `
 (string_of_x86_relocation_type m =  
(if m = r_386_none then
    "R_386_NONE"
  else if m = r_386_32 then
    "R_386_32"
  else if m = r_386_pc32 then
    "R_386_PC32"
  else if m = r_386_got32 then
    "R_386_GOT32"
  else if m = r_386_plt32 then
    "R_386_PLT32"
  else if m = r_386_copy then
    "R_386_COPY"
  else if m = r_386_glob_dat then
    "R_386_GLOB_DAT"
  else if m = r_386_jmp_slot then
    "R_386_JUMP_SLOT"
  else if m = r_386_relative then
    "R_386_RELATIVE"
  else if m = r_386_gotoff then
    "R_386_GOTOFF"
  else if m = r_386_gotpc then
    "R_386_GOTPC"
  else if m = r_386_tls_tpoff then
    "R_386_TLS_TPOFF"
  else if m = r_386_tls_dtpmod32 then
    "R_386_TLS_DTPMOD32"
  else if m = r_386_tls_dtpoff32 then
    "R_386_TLS_DTPOFF32"
  else if m = r_386_irelative then
    "R_386_IRELATIVE"
  else
    "Invalid x86 relocation"))`;

val _ = export_theory()
