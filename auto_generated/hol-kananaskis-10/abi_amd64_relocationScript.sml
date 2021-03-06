(*Generated by Lem from abis/amd64/abi_amd64_relocation.lem.*)
open HolKernel Parse boolLib bossLib;
open lem_numTheory lem_basic_classesTheory lem_maybeTheory lem_stringTheory lem_assert_extraTheory missing_pervasivesTheory errorTheory elf_types_native_uintTheory elf_headerTheory lem_mapTheory elf_symbol_tableTheory elf_fileTheory elf_relocationTheory memory_imageTheory abi_classesTheory abi_utilitiesTheory;

val _ = numLib.prefer_num();



val _ = new_theory "abi_amd64_relocation"

(** [abi_amd64_relocation] contains types and definitions relating to ABI
  * specific relocation functionality for the AMD64 ABI.
  *)

(*open import Basic_classes*)
(*open import Map*)
(*open import Maybe*)
(*open import Num*)
(*open import String*)

(*open import Error*)
(*open import Missing_pervasives*)
(*open import Assert_extra*)

(*open import Elf_types_native_uint*)
(*open import Elf_file*)
(*open import Elf_header*)
(*open import Elf_relocation*)
(*open import Elf_symbol_table*)
(*open import Memory_image*)

(*open import Abi_classes*)
(*open import Abi_utilities*)

(** x86-64 relocation types. *)

val _ = Define `
 (r_x86_64_none : num= (( 0:num)))`;

val _ = Define `
 (r_x86_64_64 : num= (( 1:num)))`;

val _ = Define `
 (r_x86_64_pc32 : num= (( 2:num)))`;

val _ = Define `
 (r_x86_64_got32 : num= (( 3:num)))`;

val _ = Define `
 (r_x86_64_plt32 : num= (( 4:num)))`;

val _ = Define `
 (r_x86_64_copy : num= (( 5:num)))`;

val _ = Define `
 (r_x86_64_glob_dat : num= (( 6:num)))`;

val _ = Define `
 (r_x86_64_jump_slot : num= (( 7:num)))`;

val _ = Define `
 (r_x86_64_relative : num= (( 8:num)))`;

val _ = Define `
 (r_x86_64_gotpcrel : num= (( 9:num)))`;

val _ = Define `
 (r_x86_64_32 : num= (( 10:num)))`;

val _ = Define `
 (r_x86_64_32s : num= (( 11:num)))`;

val _ = Define `
 (r_x86_64_16 : num= (( 12:num)))`;

val _ = Define `
 (r_x86_64_pc16 : num= (( 13:num)))`;

val _ = Define `
 (r_x86_64_8 : num= (( 14:num)))`;

val _ = Define `
 (r_x86_64_pc8 : num= (( 15:num)))`;

val _ = Define `
 (r_x86_64_dtpmod64 : num= (( 16:num)))`;

val _ = Define `
 (r_x86_64_dtpoff64 : num= (( 17:num)))`;

val _ = Define `
 (r_x86_64_tpoff64 : num= (( 18:num)))`;

val _ = Define `
 (r_x86_64_tlsgd : num= (( 19:num)))`;

val _ = Define `
 (r_x86_64_tlsld : num= (( 20:num)))`;

val _ = Define `
 (r_x86_64_dtpoff32 : num= (( 21:num)))`;

val _ = Define `
 (r_x86_64_gottpoff : num= (( 22:num)))`;

val _ = Define `
 (r_x86_64_tpoff32 : num= (( 23:num)))`;

val _ = Define `
 (r_x86_64_pc64 : num= (( 24:num)))`;

val _ = Define `
 (r_x86_64_gotoff64 : num= (( 25:num)))`;

val _ = Define `
 (r_x86_64_gotpc32 : num= (( 26:num)))`;

val _ = Define `
 (r_x86_64_size32 : num= (( 32:num)))`;

val _ = Define `
 (r_x86_64_size64 : num= (( 33:num)))`;

val _ = Define `
 (r_x86_64_gotpc32_tlsdesc : num= (( 34:num)))`;

val _ = Define `
 (r_x86_64_tlsdesc_call : num= (( 35:num)))`;

val _ = Define `
 (r_x86_64_tlsdesc : num= (( 36:num)))`;

val _ = Define `
 (r_x86_64_irelative : num= (( 37:num)))`;


(** [string_of_x86_64_relocation_type m] produces a string representation of the
  * relocation type [m].
  *)
(*val string_of_amd64_relocation_type : natural -> string*)
val _ = Define `
 (string_of_amd64_relocation_type rel_type=  
 (if rel_type = r_x86_64_none then
    "R_X86_64_NONE"
  else if rel_type = r_x86_64_64 then
    "R_X86_64_64"
  else if rel_type = r_x86_64_pc32 then
    "R_X86_64_PC32"
  else if rel_type = r_x86_64_got32 then
    "R_X86_64_GOT32"
  else if rel_type = r_x86_64_plt32 then
    "R_X86_64_PLT32"
  else if rel_type = r_x86_64_copy then
    "R_X86_64_COPY"
  else if rel_type = r_x86_64_glob_dat then
    "R_X86_64_GLOB_DAT"
  else if rel_type = r_x86_64_jump_slot then
    "R_X86_64_JUMP_SLOT"
  else if rel_type = r_x86_64_relative then
    "R_X86_64_RELATIVE"
  else if rel_type = r_x86_64_gotpcrel then
    "R_X86_64_GOTPCREL"
  else if rel_type = r_x86_64_32 then
    "R_X86_64_32"
  else if rel_type = r_x86_64_32s then
    "R_X86_64_32S"
  else if rel_type = r_x86_64_16 then
    "R_X86_64_16"
  else if rel_type = r_x86_64_pc16 then
    "R_X86_64_PC16"
  else if rel_type = r_x86_64_8 then
    "R_X86_64_8"
  else if rel_type = r_x86_64_pc8 then
    "R_X86_64_PC8"
  else if rel_type = r_x86_64_dtpmod64 then
    "R_X86_64_DTPMOD64"
  else if rel_type = r_x86_64_dtpoff64 then
    "R_X86_64_DTPOFF64"
  else if rel_type = r_x86_64_tpoff64 then
    "R_X86_64_TPOFF64"
  else if rel_type = r_x86_64_tlsgd then
    "R_X86_64_TLSGD"
  else if rel_type = r_x86_64_tlsld then
    "R_X86_64_TLSLD"
  else if rel_type = r_x86_64_dtpoff32 then
    "R_X86_64_DTPOFF32"
  else if rel_type = r_x86_64_gottpoff then
    "R_X86_64_GOTTPOFF"
  else if rel_type = r_x86_64_tpoff32 then
    "R_X86_64_TPOFF32"
  else if rel_type = r_x86_64_pc64 then
    "R_X86_64_PC64"
  else if rel_type = r_x86_64_gotoff64 then
    "R_X86_64_GOTOFF64"
  else if rel_type = r_x86_64_gotpc32 then
    "R_X86_64_GOTPC32"
  else if rel_type = r_x86_64_size32 then
    "R_X86_64_SIZE32"
  else if rel_type = r_x86_64_size64 then
    "R_X86_64_SIZE64"
  else if rel_type = r_x86_64_gotpc32_tlsdesc then
    "R_X86_64_GOTPC32_TLSDESC"
  else if rel_type = r_x86_64_tlsdesc_call then
    "R_X86_64_TLSDESC_CALL"
  else if rel_type = r_x86_64_tlsdesc then
    "R_X86_64_TLSDESC"
  else if rel_type = r_x86_64_irelative then
    "R_X86_64_IRELATIVE"
  else
    "Invalid X86_64 relocation"))`;


(* How do we find the GOT? *)
(* We really want to find the GOT without knowing how it's labelled, because 
 * in this file 'abifeature is abstract. This is a real problem. So for now, 
 * we use the HACK of looking for a section called ".got".
 * Even then, we can't understand the content of the GOT without reading the tag.
 *
 * So we can
 * 
 * - accept an argument of type abi 'abifeature and call a function on it to get the GOT
       (but then type abi becomes a recursive record type);
 * - extend the AbiFeatureTagEquiv class into a generic class capturing ABIs;
       then we risk breaking various things in Isabelle because Lem's type classes don't work there;
 * - move the amd64_reloc function to abis.lem and define it only for any_abi_feature.
 *)

(** [abi_amd64_apply_relocation rel val_map ef]
  * calculates the effect of a relocation of type [rel] using relevant addresses,
  * offsets and fields represented by [b_val], [g_val], [got_val], [l_val], [p_val],
  * [s_val] and [z_val], stored in [val_map] with "B", "G", and so on as string
  * keys, which are:
  *
  *    - B  : Base address at which a shared-object has been loaded into memory
  *           during execution.
  *    - G  : Represents the offset into the GOT at which the relocation's entry
  *           will reside during execution.
  *    - GOT: Address of the GOT.
  *    - L  : Represents the address or offset of the PLT entry for a symbol.
  *    - P  : Represents the address or offset of the storage unit being
  *           relocated.
  *    - S  : Represents the value of the symbol whose index resides in the
  *           relocation entry.
  *    - Z  : Represents the size of the symbol whose index resides in the
  *           relocation entry.
  *
  * More details of the above can be found in the AMD64 ABI document's chapter
  * on relocations.
  *
  * The [abi_amd64_apply_relocation] function returns a relocation frame, either
  * indicating that the relocation is a copy relocation, or that some calculation
  * must be carried out at a certain location.  See the comment above the
  * [relocation_frame] type in [Abi_utilities.lem] for more details.
  *)
(*val abi_amd64_apply_relocation : elf64_relocation_a -> val_map string integer -> elf64_file
  -> error (relocation_frame elf64_addr integer)*)
val _ = Define `
 (abi_amd64_apply_relocation rel val_map ef=  
 (if is_elf64_relocatable_file ef.elf64_file_header then
    let rel_type = (get_elf64_relocation_a_type rel) in
    let a_val    = (w2i rel.elf64_ra_addend) in
      (** No width, No calculation *)
      if rel_type = r_x86_64_none then
        return (NoCopy (FEMPTY))
      (** Width: 64 Calculation: S + A *)
      else if rel_type = r_x86_64_64 then
        lookupM "S" val_map >>= (\ s_val . 
      	let result = (Lift (s_val + a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I64, CannotFail)))))
      (** Width: 32 Calculation: S + A - P *)
      else if rel_type = r_x86_64_pc32 then
        lookupM "S" val_map >>= (\ s_val . 
        lookupM "P" val_map >>= (\ p_val . 
      	let result = (Lift ((s_val + a_val) - p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I32, CanFail))))))
      (** Width: 32 Calculation: G + A *)
  		else if rel_type = r_x86_64_got32 then
  		  lookupM "G" val_map >>= (\ g_val . 
      	let result = (Lift (g_val + a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I32, CanFail)))))
      (** Width: 32 Calculation: L + A - P *)
  		else if rel_type = r_x86_64_plt32 then
  		  lookupM "L" val_map >>= (\ l_val . 
  		  lookupM "P" val_map >>= (\ p_val . 
  		  let result = (Lift ((l_val + a_val) - p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I32, CanFail))))))
    	(** No width, No calculation *)
		  else if rel_type = r_x86_64_copy then
		    return Copy
		  (** Width: 64 Calculation: S *)
		  else if rel_type = r_x86_64_glob_dat then
        lookupM "S" val_map >>= (\ s_val . 
      	let result = (Lift s_val) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I64, CannotFail)))))
		  (** Width: 64 Calculation: S *)
		  else if rel_type = r_x86_64_jump_slot then
        lookupM "S" val_map >>= (\ s_val . 
      	let result = (Lift s_val) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I64, CannotFail)))))
		  (** Width: 64 Calculation: B + A *)
		  else if rel_type = r_x86_64_relative then
        lookupM "B" val_map >>= (\ b_val . 
      	let result = (Lift (b_val + a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I64, CannotFail)))))
		  (** Width: 32 Calculation: G + GOT + A - P *)
		  else if rel_type = r_x86_64_gotpcrel then
        lookupM "G" val_map >>= (\ g_val . 
        lookupM "GOT" val_map >>= (\ got_val . 
        lookupM "P" val_map >>= (\ p_val . 
      	let result = (Lift (((g_val + got_val) + a_val) - p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I32, CanFail)))))))
		  (** Width: 32 Calculation: S + A *)
		  else if rel_type = r_x86_64_32 then
        lookupM "S" val_map >>= (\ s_val . 
      	let result = (Lift (s_val + a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I32, CanFail)))))
		  (** Width: 32 Calculation: S + A *)
		  else if rel_type = r_x86_64_32s then
        lookupM "S" val_map >>= (\ s_val . 
      	let result = (Lift (s_val + a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I32, CanFail)))))
		  (** Width: 16 Calculation: S + A *)
		  else if rel_type = r_x86_64_16 then
        lookupM "S" val_map >>= (\ s_val . 
      	let result = (Lift (s_val + a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I16, CanFail)))))
		  (** Width: 16 Calculation: S + A - P *)
		  else if rel_type = r_x86_64_pc16 then
        lookupM "S" val_map >>= (\ s_val . 
        lookupM "P" val_map >>= (\ p_val . 
      	let result = (Lift ((s_val + a_val) - p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I16, CanFail))))))
		  (** Width: 8 Calculation: S + A *)
		  else if rel_type = r_x86_64_8 then
        lookupM "S" val_map >>= (\ s_val . 
      	let result = (Lift (s_val + a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I8, CanFail)))))
      (** Width 8: Calculation: S + A - P *)
		  else if rel_type = r_x86_64_pc8 then
        lookupM "S" val_map >>= (\ s_val . 
        lookupM "P" val_map >>= (\ p_val . 
      	let result = (Lift ((s_val + a_val) - p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I8, CanFail))))))
      (** Width: 64 *)
		  else if rel_type = r_x86_64_dtpmod64 then
		    failwith "abi_amd64_apply_relocation: r_x86_64_dtpmod64 not implemented"
      (** Width: 64 *)
		  else if rel_type = r_x86_64_dtpoff64 then
		    failwith "abi_amd64_apply_relocation: r_x86_64_dtpoff64 not implemented"
      (** Width: 64 *)
		  else if rel_type = r_x86_64_tpoff64 then
		    failwith "abi_amd64_apply_relocation: r_x86_64_tpoff64 not implemented"
      (** Width: 32 *)
		  else if rel_type = r_x86_64_tlsgd then
		    failwith "abi_amd64_apply_relocation: r_x86_64_tlsgd not implemented"
      (** Width: 32 *)
		  else if rel_type = r_x86_64_tlsld then
		    failwith "abi_amd64_apply_relocation: r_x86_64_tlsld not implemented"
      (** Width: 32 *)
		  else if rel_type = r_x86_64_dtpoff32 then
		    failwith "abi_amd64_apply_relocation: r_x86_64_dtpoff32 not implemented"
      (** Width: 32 *)
		  else if rel_type = r_x86_64_gottpoff then
		    failwith "abi_amd64_apply_relocation: r_x86_64_gottpoff not implemented"
      (** Width: 32 *)
		  else if rel_type = r_x86_64_tpoff32 then
		    failwith "abi_amd64_apply_relocation: r_x86_64_tpoff32 not implemented"
		  (** Width: 64 Calculation: S + A - P *)
		  else if rel_type = r_x86_64_pc64 then
        lookupM "S" val_map >>= (\ s_val . 
        lookupM "P" val_map >>= (\ p_val . 
      	let result = (Lift ((s_val + a_val) - p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I64, CannotFail))))))
		  (** Width: 64 Calculation: S + A - GOT *)
		  else if rel_type = r_x86_64_gotoff64 then
        lookupM "S" val_map >>= (\ s_val . 
        lookupM "GOT" val_map >>= (\ got_val . 
      	let result = (Lift ((s_val + a_val) - got_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I64, CannotFail))))))
		  (** Width: 32 Calculation: GOT + A - P *)
		  else if rel_type = r_x86_64_gotpc32 then
        lookupM "GOT" val_map >>= (\ got_val . 
        lookupM "P" val_map >>= (\ p_val . 
      	let result = (Lift ((got_val + a_val) - p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I32, CanFail))))))
		  (** Width: 32 Calculation: Z + A *)
		  else if rel_type = r_x86_64_size32 then
        lookupM "Z" val_map >>= (\ z_val . 
      	let result = (Lift (z_val + a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I32, CanFail)))))
		  (** Width: 64 Calculation: Z + A *)
		  else if rel_type = r_x86_64_size64 then
        lookupM "Z" val_map >>= (\ z_val . 
      	let result = (Lift (z_val + a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (FEMPTY |+ (addr, (result, I64, CannotFail)))))
      (** Width: 32 *)
		  else if rel_type = r_x86_64_gotpc32_tlsdesc then
		    failwith "abi_amd64_apply_relocation: r_x86_64_gotpc32_tlsdesc not implemented"
      (** No width *)
		  else if rel_type = r_x86_64_tlsdesc_call then
		    failwith "abi_amd64_apply_relocation: r_x86_64_tlsdesc_call not implemented"
		  (** Width: 64X2 *)
		  else if rel_type = r_x86_64_tlsdesc then
		    failwith "abi_amd64_apply_relocation: r_x86_64_tlsdesc not implemented"
		  (** Calculation: indirect(B + A) *)
		  else if rel_type = r_x86_64_irelative then
        lookupM "B" val_map >>= (\ b_val . 
		    let result = (Apply(Indirect, Lift(b_val + a_val))) in
		    let addr   = (rel.elf64_ra_offset) in
		      return (NoCopy (FEMPTY |+ (addr, (result, I64, CannotFail)))))
		  else
		  	failwith "abi_amd64_apply_relocation: invalid relocation type"
  else
  	failwith "abi_amd64_apply_relocation: not a relocatable file"))`;

val _ = export_theory()

