(*Generated by Lem from adaptors/sail_interface.lem.*)
open HolKernel Parse boolLib bossLib;
open lem_numTheory lem_listTheory lem_functionTheory lem_basic_classesTheory lem_maybeTheory lem_stringTheory lem_assert_extraTheory showTheory missing_pervasivesTheory errorTheory byte_sequenceTheory elf_types_native_uintTheory lem_tupleTheory elf_headerTheory string_tableTheory elf_program_header_tableTheory hex_printingTheory elf_interpreted_sectionTheory elf_interpreted_segmentTheory elf_symbol_tableTheory elf_fileTheory;

val _ = numLib.prefer_num();



val _ = new_theory "sail_interface"

(*open import Basic_classes*)
(*open import Function*)
(*open import List*)
(*open import Maybe*)
(*open import Num*)
(*open import String*)
(*open import Tuple*)

(*open import Assert_extra*)

(*open import Byte_sequence*)
(*open import Error*)
(*open import Missing_pervasives*)
(*open import Show*)

(*open import Elf_header*)
(*open import Elf_file*)
(*open import Elf_interpreted_section*)
(*open import Elf_interpreted_segment*)
(*open import String_table*)
(*open import Elf_symbol_table*)
(*open import Elf_program_header_table*)
(*open import Elf_types_native_uint*)

(*open import Hex_printing*)

val _ = Hol_datatype `
 executable_process_image
  = ELF_Class_32 of elf32_executable_process_image
  | ELF_Class_64 of elf64_executable_process_image`;


(*val string_of_segment_provenance : segment_provenance -> string*)

(*val string_of_executable_process_image : executable_process_image -> string*)

(*val populate : string -> error executable_process_image*)

(*val obtain_global_symbol_init_info : string -> error global_symbol_init_info*)

(*val populate_and_obtain_global_symbol_init_info : string -> error (executable_process_image * global_symbol_init_info)*)
val _ = export_theory()

