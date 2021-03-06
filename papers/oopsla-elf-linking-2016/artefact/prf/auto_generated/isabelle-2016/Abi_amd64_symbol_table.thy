chapter {* Generated by Lem from abis/amd64/abi_amd64_symbol_table.lem. *}

theory "Abi_amd64_symbol_table" 

imports 
 	 Main
	 "../../lem-libs/isabelle-lib/Lem_num" 
	 "../../lem-libs/isabelle-lib/Lem_basic_classes" 

begin 

(** [abi_amd64_symbol_table], AMD64 ABI specific definitions for the ELF symbol
  * table.
  *)

(*open import Basic_classes*)
(*open import Num*)

(** AMD64 specific symbol types.  See doc/ifunc.txt and Section 4.3 of the
  * ABI.
  *)

(** Optional, like [stt_func] but always points to a function or piece of
  * executable code that takes no arguments and returns a function pointer.
  *)
definition stt_abi_amd64_gnu_ifunc  :: " nat "  where 
     " stt_abi_amd64_gnu_ifunc = (( 12 :: nat))"


(** [string_of_abi_amd64_symbol_type m] produces a string based representation
  * of AMD64 symbol type [m].
  *)
(*val string_of_abi_amd64_symbol_type : natural -> string*)
end
