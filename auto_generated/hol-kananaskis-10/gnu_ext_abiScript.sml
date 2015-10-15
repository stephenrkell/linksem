(*Generated by Lem from gnu_extensions/gnu_ext_abi.lem.*)
open HolKernel Parse boolLib bossLib;
open lem_numTheory lem_listTheory lem_functionTheory lem_basic_classesTheory lem_boolTheory lem_maybeTheory lem_stringTheory lem_assert_extraTheory showTheory lem_sortingTheory missing_pervasivesTheory byte_sequenceTheory elf_types_native_uintTheory lem_tupleTheory elf_headerTheory elf_program_header_tableTheory elf_section_header_tableTheory elf_interpreted_sectionTheory elf_interpreted_segmentTheory elf_symbol_tableTheory elf_fileTheory elf_relocationTheory memory_imageTheory;

val _ = numLib.prefer_num();



val _ = new_theory "gnu_ext_abi"

(*open import Basic_classes*)
(*open import Function*)
(*open import String*)
(*open import Tuple*)
(*open import Bool*)
(*open import List*)
(*open import Sorting*)
(*open import Num*)
(*open import Maybe*)
(*open import Assert_extra*)
(*open import Show*)
(*open import Missing_pervasives*)

(*open import Byte_sequence*)
(*open import Elf_file*)
(*open import Elf_header*)
(*open import Elf_interpreted_segment*)
(*open import Elf_interpreted_section*)
(*open import Elf_program_header_table*)
(*open import Elf_section_header_table*)
(*open import Elf_symbol_table*)
(*open import Elf_types_native_uint*)
(*open import Elf_relocation*)
(*open import Memory_image*)

(*val gnu_extend: forall 'abifeature. abi 'abifeature -> abi 'abifeature*)
val _ = Define `
 (gnu_extend a =   
 (<| is_valid_elf_header := a.is_valid_elf_header
    ; reloc               := a.reloc
    ; section_is_special  := (\ isec .  (\ img .  (
                                a.section_is_special isec img
                                \/ (missing_pervasives$string_prefix ( (STRLEN ".gnu.warning")) isec.elf64_section_name_as_string
                                 = SOME(".gnu.warning"))
        (* FIXME: This is a slight abuse. The GNU linker's treatment of 
         * ".gnu.warning.*" section is not really a function of the output
         * ABI -- it's a function of the input ABI, or arguably perhaps just
         * of the linker itself. We have to do something to make sure these
         * sections get silently processed separately from the usual linker
         * control script, because otherwise our link map output doesn't match
         * the GNU linker's. By declaring these sections "special" we achieve
         * this by saying they don't participate in linking proper, just like 
         * ".symtab" and similar sections don't. HMM. I suppose this is 
         * okay, in that although a non-GNU linker might happily link these
         * sections, arguably that is a failure to understand the input files. 
         * But the issue about it being a per-input-file property remains.
         * Q. What does the GNU linker do if a reloc input file whose OSABI
         * is *not* GNU contains a .gnu.warning.* section? That would be a fair
         * test about whether looking at the input ABI is worth doing. *)
                            )))
    ; section_is_large    := a.section_is_large
    ; maxpagesize         := a.maxpagesize
    ; minpagesize         := a.minpagesize
    ; commonpagesize      := a.commonpagesize
    ; symbol_is_generated_by_linker := a.symbol_is_generated_by_linker
    |>))`;

val _ = export_theory()

