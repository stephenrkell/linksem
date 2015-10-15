(*Generated by Lem from gnu_extensions/gnu_ext_symbol_versioning.lem.*)
open HolKernel Parse boolLib bossLib;
open lem_numTheory lem_listTheory lem_basic_classesTheory lem_boolTheory lem_maybeTheory lem_stringTheory showTheory missing_pervasivesTheory errorTheory byte_sequenceTheory endiannessTheory elf_types_native_uintTheory elf_headerTheory elf_section_header_tableTheory elf_symbol_tableTheory elf_fileTheory elf_dynamicTheory gnu_ext_dynamicTheory gnu_ext_section_header_tableTheory;

val _ = numLib.prefer_num();



val _ = new_theory "gnu_ext_symbol_versioning"

(** The [gnu_ext_symbol_versioning] defines constants, types and functions
  * relating to the GNU symbol versioning extensions (i.e. contents of
  * GNU_VERSYM sections).
  *
  * TODO: work out what is going on with symbol versioning.  The specification
  * is completely opaque.
  *)

(*open import Basic_classes*)
(*open import Bool*)
(*open import List*)
(*open import Maybe*)
(*open import Num*)
(*open import String*)

(*open import Byte_sequence*)
(*open import Endianness*)
(*open import Error*)

(*open import Elf_dynamic*)
(*open import Elf_file*)
(*open import Elf_header*)
(*open import Elf_section_header_table*)
(*open import Elf_symbol_table*)
(*open import Elf_types_native_uint*)

(*open import Missing_pervasives*)
(*open import Show*)

(*open import Gnu_ext_dynamic*)
(*open import Gnu_ext_section_header_table*)

(** [gnu_ext_elf32_symbol_version_table] is an array (linked list, here) of
  * [elf32_half] entries.
  *)
val _ = type_abbrev( "gnu_ext_elf32_symbol_version_table" , ``:  word 16
  list``);
  
val _ = type_abbrev( "gnu_ext_elf64_symbol_version_table" , ``:  word 16
  list``);

(*val obtain_gnu_ext_elf32_symbol_version_table : elf32_file -> byte_sequence -> error gnu_ext_elf32_symbol_version_table*)
val _ = Define `
 (obtain_gnu_ext_elf32_symbol_version_table f1 bs0 =  
(let sht = (f1.elf32_file_section_header_table) in
  let endian = (get_elf32_header_endianness f1.elf32_file_header) in
  let vers = (FILTER (\ ent . 
    ent.elf32_sh_type = n2w sht_gnu_versym
  ) sht)
  in
    (case vers of
        []    => return []
      | [ver] =>
        let off = (w2n  ver.elf32_sh_offset) in
        let siz = (w2n ver.elf32_sh_size) in
        let lnk = (w2n ver.elf32_sh_link) in
        get_elf32_symbol_table_by_index f1 lnk >>= (\ symtab . 
        let dlen = ( (LENGTH symtab)) in
        byte_sequence$offset_and_cut off siz bs0         >>= (\ ver      . 
        error$repeatM' dlen bs0 (read_elf32_half endian) >>= 
  (\p .  (case (p ) of ( (ver, _) ) => return ver ))))
      | _     => fail0 "obtain_gnu_ext_elf32_symbol_version_table: multiple sections of type .gnu_versym present in file"
    )))`;

 
(*val obtain_gnu_ext_elf64_symbol_version_table : endianness -> elf64_section_header_table -> elf64_symbol_table -> byte_sequence -> error gnu_ext_elf64_symbol_version_table*)
val _ = Define `
 (obtain_gnu_ext_elf64_symbol_version_table endian sht dynsym bs0 =  
(let dlen = ( (LENGTH dynsym)) in
    if dlen = 0 then
      return []
    else
      let vers = (FILTER (\ ent . 
          ent.elf64_sh_type = n2w sht_gnu_versym
        ) sht)
      in
        (case vers of
            []    => return []
          | [ver] =>
            let off = (w2n   ver.elf64_sh_offset) in
            let siz = (w2n ver.elf64_sh_size) in
            byte_sequence$offset_and_cut off siz bs0         >>= (\ ver      . 
            error$repeatM' dlen bs0 (read_elf64_half endian) >>= 
  (\p .  (case (p ) of ( (ver, _) ) => return ver )))
          | _     => fail0 "obtain_gnu_ext_elf64_symbol_version_table: multiple sections of type .gnu_versym present in file"
        )))`;

  
val _ = Hol_datatype `
 gnu_ext_elf32_verdef =
  <| gnu_ext_elf32_vd_version :  word 16
   ; gnu_ext_elf32_vd_flags   :  word 16
   ; gnu_ext_elf32_vd_ndx     :  word 16
   ; gnu_ext_elf32_vd_cnt     :  word 16
   ; gnu_ext_elf32_vd_hash    :  word 32
   ; gnu_ext_elf32_vd_aux     :  word 32
   ; gnu_ext_elf32_vd_next    :  word 32
   |>`;

   
val _ = Hol_datatype `
 gnu_ext_elf64_verdef =
  <| gnu_ext_elf64_vd_version :  word 16
   ; gnu_ext_elf64_vd_flags   :  word 16
   ; gnu_ext_elf64_vd_ndx     :  word 16
   ; gnu_ext_elf64_vd_cnt     :  word 16
   ; gnu_ext_elf64_vd_hash    :  word 32
   ; gnu_ext_elf64_vd_aux     :  word 32
   ; gnu_ext_elf64_vd_next    :  word 32
   |>`;

   
(*val string_of_gnu_ext_elf32_verdef : gnu_ext_elf32_verdef -> string*)
  
(*val string_of_gnu_ext_elf64_verdef : gnu_ext_elf64_verdef -> string*)
   
(*val read_gnu_ext_elf32_verdef : endianness -> byte_sequence -> error (gnu_ext_elf32_verdef * byte_sequence)*)
val _ = Define `
 (read_gnu_ext_elf32_verdef endian bs0 =  
(read_elf32_half endian bs0 >>= (\ (ver, bs0) . 
  read_elf32_half endian bs0 >>= (\ (flg, bs0) . 
  read_elf32_half endian bs0 >>= (\ (ndx, bs0) . 
  read_elf32_half endian bs0 >>= (\ (cnt, bs0) . 
  read_elf32_word endian bs0 >>= (\ (hsh, bs0) . 
  read_elf32_word endian bs0 >>= (\ (aux, bs0) . 
  read_elf32_word endian bs0 >>= (\ (nxt, bs0) . 
    return (<| gnu_ext_elf32_vd_version := ver; gnu_ext_elf32_vd_flags := flg;
      gnu_ext_elf32_vd_ndx := ndx; gnu_ext_elf32_vd_cnt := cnt;
        gnu_ext_elf32_vd_hash := hsh; gnu_ext_elf32_vd_aux := aux;
      gnu_ext_elf32_vd_next := nxt |>, bs0))))))))))`;

      
(*val read_gnu_ext_elf64_verdef : endianness -> byte_sequence -> error (gnu_ext_elf64_verdef * byte_sequence)*)
val _ = Define `
 (read_gnu_ext_elf64_verdef endian bs0 =  
(read_elf64_half endian bs0 >>= (\ (ver, bs0) . 
  read_elf64_half endian bs0 >>= (\ (flg, bs0) . 
  read_elf64_half endian bs0 >>= (\ (ndx, bs0) . 
  read_elf64_half endian bs0 >>= (\ (cnt, bs0) . 
  read_elf64_word endian bs0 >>= (\ (hsh, bs0) . 
  read_elf64_word endian bs0 >>= (\ (aux, bs0) . 
  read_elf64_word endian bs0 >>= (\ (nxt, bs0) . 
    return (<| gnu_ext_elf64_vd_version := ver; gnu_ext_elf64_vd_flags := flg;
      gnu_ext_elf64_vd_ndx := ndx; gnu_ext_elf64_vd_cnt := cnt;
        gnu_ext_elf64_vd_hash := hsh; gnu_ext_elf64_vd_aux := aux;
      gnu_ext_elf64_vd_next := nxt |>, bs0))))))))))`;

      
(*val gnu_ext_elf32_verdef_size : natural*)
val _ = Define `
 (gnu_ext_elf32_verdef_size =( 160))`;

  
(*val gnu_ext_elf64_verdef_size : natural*)
val _ = Define `
 (gnu_ext_elf64_verdef_size =( 256))`;

      
(*val read_gnu_ext_elf32_verdefs : endianness -> byte_sequence -> natural -> error (list gnu_ext_elf32_verdef)*)
 val read_gnu_ext_elf32_verdefs_defn = Hol_defn "read_gnu_ext_elf32_verdefs" `
 (read_gnu_ext_elf32_verdefs endian bs0 off =  
(byte_sequence$offset_and_cut off gnu_ext_elf32_verdef_size bs0 >>= (\ vd . 
  read_gnu_ext_elf32_verdef endian vd >>= 
  (\p .  (case (p ) of
             ( (verdef, _) ) =>
         let off = (w2n verdef.gnu_ext_elf32_vd_next) in
         read_gnu_ext_elf32_verdefs endian bs0 off >>=
           (\ tail .  return (verdef :: tail))
         )))))`;

val _ = Lib.with_flag (computeLib.auto_import_definitions, false) Defn.save_defn read_gnu_ext_elf32_verdefs_defn;
  
(*val read_gnu_ext_elf64_verdefs : endianness -> byte_sequence -> natural -> error (list gnu_ext_elf64_verdef)*)
 val read_gnu_ext_elf64_verdefs_defn = Hol_defn "read_gnu_ext_elf64_verdefs" `
 (read_gnu_ext_elf64_verdefs endian bs0 off =  
(byte_sequence$offset_and_cut off gnu_ext_elf32_verdef_size bs0 >>= (\ vd . 
  read_gnu_ext_elf64_verdef endian vd >>= 
  (\p .  (case (p ) of
             ( (verdef, _) ) =>
         let off = (w2n verdef.gnu_ext_elf64_vd_next) in
         read_gnu_ext_elf64_verdefs endian bs0 off >>=
           (\ tail .  return (verdef :: tail))
         )))))`;

val _ = Lib.with_flag (computeLib.auto_import_definitions, false) Defn.save_defn read_gnu_ext_elf64_verdefs_defn;
      
(*val obtain_gnu_ext_elf32_verdef : elf32_file -> byte_sequence -> error (list gnu_ext_elf32_verdef)*)
val _ = Define `
 (obtain_gnu_ext_elf32_verdef f1 bs0 =  
(let endian = (get_elf32_header_endianness f1.elf32_file_header) in
  let sht = (f1.elf32_file_section_header_table) in
  let verdefs = (FILTER (\ ent . 
    ent.elf32_sh_type = n2w sht_gnu_verdef) sht)
  in
    (case verdefs of
        []  => return [] (* XXX? *)
      | [x] =>
        let off = (w2n x.elf32_sh_offset) in
        read_gnu_ext_elf32_verdefs endian bs0 off
      | _   => fail0 "obtain_gnu_ext_elf32_verdef: multiple VERDEF sections present in file"
    )))`;

    
(*val obtain_gnu_ext_elf64_verdef : endianness -> elf64_section_header_table -> byte_sequence -> error (list gnu_ext_elf64_verdef)*)
val _ = Define `
 (obtain_gnu_ext_elf64_verdef endian sht bs0 =  
(let verdefs = (FILTER (\ ent . 
    ent.elf64_sh_type = n2w sht_gnu_verdef) sht)
  in
    (case verdefs of
        []  => return [] (* XXX? *)
      | [x] =>
        let off = (w2n x.elf64_sh_offset) in
        read_gnu_ext_elf64_verdefs endian bs0 off
      | _   => fail0 "obtain_gnu_ext_elf64_verdef: multiple VERDEF sections present in file"
    )))`;

   
val _ = Hol_datatype `
 gnu_ext_elf32_veraux =
  <| gnu_ext_elf32_vda_name :  word 32
   ; gnu_ext_elf32_vda_next :  word 32
   |>`;

   
val _ = Hol_datatype `
 gnu_ext_elf64_veraux =
  <| gnu_ext_elf64_vda_name :  word 32
   ; gnu_ext_elf64_vda_next :  word 32
   |>`;

   
(*val gnu_ext_elf32_veraux_size : natural*)
val _ = Define `
 (gnu_ext_elf32_veraux_size =( 64))`;


(*val gnu_ext_elf64_veraux_size : natural*)
val _ = Define `
 (gnu_ext_elf64_veraux_size =( 128))`;

   
(*val read_gnu_ext_elf32_veraux : endianness -> byte_sequence -> error (gnu_ext_elf32_veraux * byte_sequence)*)
val _ = Define `
 (read_gnu_ext_elf32_veraux endian bs0 =  
(read_elf32_word endian bs0 >>= (\ (nme, bs0) . 
  read_elf32_word endian bs0 >>= (\ (nxt, bs0) . 
    return (<| gnu_ext_elf32_vda_name := nme; gnu_ext_elf32_vda_next := nxt |>, bs0)))))`;

    
(*val read_gnu_ext_elf64_veraux : endianness -> byte_sequence -> error (gnu_ext_elf64_veraux * byte_sequence)*)
val _ = Define `
 (read_gnu_ext_elf64_veraux endian bs0 =  
(read_elf64_word endian bs0 >>= (\ (nme, bs0) . 
  read_elf64_word endian bs0 >>= (\ (nxt, bs0) . 
    return (<| gnu_ext_elf64_vda_name := nme; gnu_ext_elf64_vda_next := nxt |>, bs0)))))`;

    
(*val obtain_gnu_ext_elf32_veraux : endianness -> list gnu_ext_elf32_verdef -> byte_sequence -> error (list gnu_ext_elf32_veraux)*)
 val obtain_gnu_ext_elf32_veraux_defn = Hol_defn "obtain_gnu_ext_elf32_veraux" `
 (obtain_gnu_ext_elf32_veraux endian verdefs bs0 =  
((case verdefs of
      []    => return []
    | x::xs =>
      let off = (w2n x.gnu_ext_elf32_vd_aux) in
      byte_sequence$offset_and_cut off gnu_ext_elf32_veraux_size bs0 >>= (\ vd . 
      read_gnu_ext_elf32_veraux endian bs0 >>= 
  (\p .  (case (p ) of
             ( (veraux, _) ) =>
         obtain_gnu_ext_elf32_veraux endian xs bs0 >>=
           (\ tail .  return (veraux :: tail))
         )))
  )))`;

val _ = Lib.with_flag (computeLib.auto_import_definitions, false) Defn.save_defn obtain_gnu_ext_elf32_veraux_defn;
  
(*val obtain_gnu_ext_elf64_veraux : endianness -> list gnu_ext_elf64_verdef -> byte_sequence -> error (list gnu_ext_elf64_veraux)*)
 val obtain_gnu_ext_elf64_veraux_defn = Hol_defn "obtain_gnu_ext_elf64_veraux" `
 (obtain_gnu_ext_elf64_veraux endian verdefs bs0 =  
((case verdefs of
      []    => return []
    | x::xs =>
      let off = (w2n x.gnu_ext_elf64_vd_aux) in
      byte_sequence$offset_and_cut off gnu_ext_elf64_veraux_size bs0 >>= (\ vd . 
      read_gnu_ext_elf64_veraux endian bs0 >>= 
  (\p .  (case (p ) of
             ( (veraux, _) ) =>
         obtain_gnu_ext_elf64_veraux endian xs bs0 >>=
           (\ tail .  return (veraux :: tail))
         )))
  )))`;

val _ = Lib.with_flag (computeLib.auto_import_definitions, false) Defn.save_defn obtain_gnu_ext_elf64_veraux_defn;
   
val _ = Hol_datatype `
 gnu_ext_elf32_verneed =
  <| gnu_ext_elf32_vn_version :  word 16
   ; gnu_ext_elf32_vn_cnt     :  word 16
   ; gnu_ext_elf32_vn_file    :  word 32
   ; gnu_ext_elf32_vn_aux     :  word 32
   ; gnu_ext_elf32_vn_next    :  word 32
   |>`;

   
val _ = Hol_datatype `
 gnu_ext_elf64_verneed =
  <| gnu_ext_elf64_vn_version :  word 16
   ; gnu_ext_elf64_vn_cnt     :  word 16
   ; gnu_ext_elf64_vn_file    :  word 32
   ; gnu_ext_elf64_vn_aux     :  word 32
   ; gnu_ext_elf64_vn_next    :  word 32
   |>`;

   
(*val gnu_ext_elf32_verneed_size : natural*)
val _ = Define `
 (gnu_ext_elf32_verneed_size =( 128))`;


(*val gnu_ext_elf64_verneed_size : natural*)
val _ = Define `
 (gnu_ext_elf64_verneed_size =( 224))`;

   
(*val read_gnu_ext_elf32_verneed : endianness -> byte_sequence -> error (gnu_ext_elf32_verneed * byte_sequence)*)
val _ = Define `
 (read_gnu_ext_elf32_verneed endian bs0 =  
(read_elf32_half endian bs0 >>= (\ (ver, bs0) . 
  read_elf32_half endian bs0 >>= (\ (cnt, bs0) . 
  read_elf32_word endian bs0 >>= (\ (fle, bs0) . 
  read_elf32_word endian bs0 >>= (\ (aux, bs0) . 
  read_elf32_word endian bs0 >>= (\ (nxt, bs0) . 
    return (<| gnu_ext_elf32_vn_version := ver; gnu_ext_elf32_vn_cnt := cnt;
      gnu_ext_elf32_vn_file := fle; gnu_ext_elf32_vn_aux := aux;
        gnu_ext_elf32_vn_next := nxt |>, bs0))))))))`;


(*val read_gnu_ext_elf64_verneed : endianness -> byte_sequence -> error (gnu_ext_elf64_verneed * byte_sequence)*)
val _ = Define `
 (read_gnu_ext_elf64_verneed endian bs0 =  
(read_elf64_half endian bs0 >>= (\ (ver, bs0) . 
  read_elf64_half endian bs0 >>= (\ (cnt, bs0) . 
  read_elf64_word endian bs0 >>= (\ (fle, bs0) . 
  read_elf64_word endian bs0 >>= (\ (aux, bs0) . 
  read_elf64_word endian bs0 >>= (\ (nxt, bs0) . 
    return (<| gnu_ext_elf64_vn_version := ver; gnu_ext_elf64_vn_cnt := cnt;
      gnu_ext_elf64_vn_file := fle; gnu_ext_elf64_vn_aux := aux;
        gnu_ext_elf64_vn_next := nxt |>, bs0))))))))`;

   
(*val read_gnu_ext_elf32_verneeds : endianness -> byte_sequence -> natural -> error (list gnu_ext_elf32_verneed)*)
 val read_gnu_ext_elf32_verneeds_defn = Hol_defn "read_gnu_ext_elf32_verneeds" `
 (read_gnu_ext_elf32_verneeds endian bs0 off =  
(byte_sequence$offset_and_cut off gnu_ext_elf32_verneed_size bs0 >>= (\ vd . 
  read_gnu_ext_elf32_verneed endian vd >>= 
  (\p .  (case (p ) of
             ( (verneed, _) ) =>
         let off = (w2n verneed.gnu_ext_elf32_vn_next) in
         read_gnu_ext_elf32_verneeds endian bs0 off >>=
           (\ tail .  return (verneed :: tail))
         )))))`;

val _ = Lib.with_flag (computeLib.auto_import_definitions, false) Defn.save_defn read_gnu_ext_elf32_verneeds_defn;
  
(*val read_gnu_ext_elf64_verneeds : endianness -> byte_sequence -> natural -> error (list gnu_ext_elf64_verneed)*)
 val read_gnu_ext_elf64_verneeds_defn = Hol_defn "read_gnu_ext_elf64_verneeds" `
 (read_gnu_ext_elf64_verneeds endian bs0 off =  
(byte_sequence$offset_and_cut off gnu_ext_elf64_verneed_size bs0 >>= (\ vd . 
  read_gnu_ext_elf64_verneed endian vd >>= 
  (\p .  (case (p ) of
             ( (verneed, _) ) =>
         let off = (w2n verneed.gnu_ext_elf64_vn_next) in
         read_gnu_ext_elf64_verneeds endian bs0 off >>=
           (\ tail .  return (verneed :: tail))
         )))))`;

val _ = Lib.with_flag (computeLib.auto_import_definitions, false) Defn.save_defn read_gnu_ext_elf64_verneeds_defn;
   
(*   
val obtain_gnu_ext_elf32_verneed : elf32_file -> byte_sequence -> error (list gnu_ext_elf32_verneed)
let obtain_gnu_ext_elf32_verneed f1 bs0 =
  let endian = get_elf32_header_endianness f1.elf32_file_header in
  let sht = f1.elf32_file_section_header_table in
  let verneeds = List.filter (fun ent ->
    ent.elf32_sh_type = elf32_word_of_natural sht_gnu_verneed) sht
  in
    match verneeds with
      | []  -> return [] (* XXX? *)
      | [x] ->
        let off = natural_of_elf32_off x.elf32_sh_offset in
        read_gnu_ext_elf32_verneeds endian bs0 off
      | _   -> fail "obtain_gnu_ext_elf32_verneed: multiple VERNEED sections present in file"
    end
*)    
(*val obtain_gnu_ext_elf64_verneed : endianness -> elf64_section_header_table -> byte_sequence -> error (list gnu_ext_elf64_verneed)*)
val _ = Define `
 (obtain_gnu_ext_elf64_verneed endian sht bs0 =  
(let verneeds = (FILTER (\ ent . 
    ent.elf64_sh_type = n2w sht_gnu_verneed) sht)
  in
    (case verneeds of
        []  => return [] (* XXX? *)
      | [x] =>
        let off = (w2n x.elf64_sh_offset) in
        read_gnu_ext_elf64_verneeds endian bs0 off
      | _   => fail0 "obtain_gnu_ext_elf64_verneed: multiple VERNEED sections present in file"
    )))`;

   
val _ = Hol_datatype `
 gnu_ext_elf32_vernaux =
  <| gnu_ext_elf32_vna_hash  :  word 32
   ; gnu_ext_elf32_vna_flags :  word 16
   ; gnu_ext_elf32_vna_other :  word 16
   ; gnu_ext_elf32_vna_name  :  word 32
   ; gnu_ext_elf32_vna_next  :  word 32
   |>`;

   
val _ = Hol_datatype `
 gnu_ext_elf64_vernaux =
  <| gnu_ext_elf64_vna_hash  :  word 32
   ; gnu_ext_elf64_vna_flags :  word 16
   ; gnu_ext_elf64_vna_other :  word 16
   ; gnu_ext_elf64_vna_name  :  word 32
   ; gnu_ext_elf64_vna_next  :  word 32
   |>`;

   
(*val string_of_gnu_ext_elf32_vernaux : gnu_ext_elf32_vernaux -> string*)
  
(*val string_of_gnu_ext_elf64_vernaux : gnu_ext_elf64_vernaux -> string*)
   
(*val gnu_ext_elf32_vernaux_size : natural*)
val _ = Define `
 (gnu_ext_elf32_vernaux_size =( 16))`;


(*val gnu_ext_elf64_vernaux_size : natural*)
val _ = Define `
 (gnu_ext_elf64_vernaux_size =( 224))`;

   
(*val read_gnu_ext_elf32_vernaux : endianness -> byte_sequence -> error (gnu_ext_elf32_vernaux * byte_sequence)*)
val _ = Define `
 (read_gnu_ext_elf32_vernaux endian bs0 =  
(read_elf32_word endian bs0 >>= (\ (hsh, bs0) . 
  read_elf32_half endian bs0 >>= (\ (flg, bs0) . 
  read_elf32_half endian bs0 >>= (\ (otr, bs0) . 
  read_elf32_word endian bs0 >>= (\ (nme, bs0) . 
  read_elf32_word endian bs0 >>= (\ (nxt, bs0) . 
    return (<| gnu_ext_elf32_vna_hash := hsh; gnu_ext_elf32_vna_flags := flg;
      gnu_ext_elf32_vna_other := otr; gnu_ext_elf32_vna_name := nme;
    gnu_ext_elf32_vna_next := nxt |>, bs0))))))))`;

    
(*val read_gnu_ext_elf64_vernaux : endianness -> byte_sequence -> error (gnu_ext_elf64_vernaux * byte_sequence)*)
val _ = Define `
 (read_gnu_ext_elf64_vernaux endian bs0 =  
(read_elf64_word endian bs0 >>= (\ (hsh, bs0) . 
  read_elf64_half endian bs0 >>= (\ (flg, bs0) . 
  read_elf64_half endian bs0 >>= (\ (otr, bs0) . 
  read_elf64_word endian bs0 >>= (\ (nme, bs0) . 
  read_elf64_word endian bs0 >>= (\ (nxt, bs0) . 
    return (<| gnu_ext_elf64_vna_hash := hsh; gnu_ext_elf64_vna_flags := flg;
      gnu_ext_elf64_vna_other := otr; gnu_ext_elf64_vna_name := nme;
    gnu_ext_elf64_vna_next := nxt |>, bs0))))))))`;


(*val read_gnu_ext_elf32_vernauxs : endianness -> byte_sequence -> natural -> error (list gnu_ext_elf32_vernaux)*)
 val read_gnu_ext_elf32_vernauxs_defn = Hol_defn "read_gnu_ext_elf32_vernauxs" `
 (read_gnu_ext_elf32_vernauxs endian bs0 off =  
(if off = 0 then
    return []
  else
    byte_sequence$offset_and_cut off gnu_ext_elf32_vernaux_size bs0 >>= (\ vd . 
    read_gnu_ext_elf32_vernaux endian vd >>= 
  (\p .  (case (p ) of
             ( (vernaux, _) ) =>
         let off = (w2n vernaux.gnu_ext_elf32_vna_next) in
         read_gnu_ext_elf32_vernauxs endian bs0 off >>=
           (\ tail .  return (vernaux :: tail))
         )))))`;

val _ = Lib.with_flag (computeLib.auto_import_definitions, false) Defn.save_defn read_gnu_ext_elf32_vernauxs_defn;
    
(*val obtain_gnu_ext_elf32_verneed_and_vernaux : elf32_file -> byte_sequence -> error (list (gnu_ext_elf32_verneed * list gnu_ext_elf32_vernaux))*)
val _ = Define `
 (obtain_gnu_ext_elf32_verneed_and_vernaux f1 bs0 =  
(let endian = (get_elf32_header_endianness f1.elf32_file_header) in
  let sht = (f1.elf32_file_section_header_table) in
  obtain_elf32_dynamic_section_contents f1 gnu_ext_os_additional_ranges gnu_ext_tag_correspondence_of_tag gnu_ext_tag_correspondence_of_tag bs0 >>= (\ dyn . 
    (case FILTER (\ ent .  ent.elf32_sh_type = n2w sht_gnu_verneed) sht of
        [] => fail0 "obtain_gnu_ext_elf32_verneed: no section header entry of type SHT_VERNEED"
      | [verneed] =>
        let off = (w2n verneed.elf32_sh_offset) in
        let siz = (w2n verneed.elf32_sh_size) in
        byte_sequence$offset_and_cut off siz bs0 >>= (\ rel . 
        (case FILTER (\ d .  w2i d.elf32_dyn_tag = int_of_num elf_dt_gnu_verneednum) dyn of
            []    => fail0 "obtain_gnu_ext_elf32_verneed: no DT_VERNEEDNUM entry in .dynamic section"
          | [dyn] =>
            (case dyn.elf32_dyn_d_un of
                D_Val v =>
                let count1 = (w2n v) in
                repeatM' count1 rel (read_gnu_ext_elf32_verneed endian) >>= (\ (tbl, bs1) . 
                mapM (\ verneed . 
                  let count1 = (w2n verneed.gnu_ext_elf32_vn_cnt) in
                  let off = (w2n verneed.gnu_ext_elf32_vn_aux) in
                  byte_sequence$offset_and_cut off (count1 * gnu_ext_elf32_vernaux_size) bs0 >>= (\ rel . 
                  read_gnu_ext_elf32_vernauxs endian rel off >>= (\ vernauxs . 
                  return (verneed, vernauxs)))
                ) tbl)
              | _       => fail0 "obtain_gnu_ext_elf32_verneed: .dynamic entry must be a value"
            )
          | _     => fail0 "obtain_gnu_ext_elf32_verneed: more than one DT_VERNEEDNUM entry in .dynamic section"
        ))
      | _  => fail0 "obtain_gnu_ext_elf32_verneed: multiple section header entries of type SHT_VERNEED"
    ))))`;

  
(*val obtain_gnu_ext_elf64_vernaux : endianness -> list gnu_ext_elf64_verneed -> byte_sequence -> error (list gnu_ext_elf64_vernaux)*)
 val obtain_gnu_ext_elf64_vernaux_defn = Hol_defn "obtain_gnu_ext_elf64_vernaux" `
 (obtain_gnu_ext_elf64_vernaux endian verneed bs0 =  
((case verneed of
      []    => return []
    | x::xs =>
      let off = (w2n x.gnu_ext_elf64_vn_aux) in
      byte_sequence$offset_and_cut off gnu_ext_elf64_vernaux_size bs0 >>= (\ vn . 
      read_gnu_ext_elf64_vernaux endian vn >>= 
  (\p .  (case (p ) of
             ( (vernaux, _) ) =>
         obtain_gnu_ext_elf64_vernaux endian xs bs0 >>=
           (\ tail .  return (vernaux :: tail))
         )))
  )))`;

val _ = Lib.with_flag (computeLib.auto_import_definitions, false) Defn.save_defn obtain_gnu_ext_elf64_vernaux_defn;
  
(*val obtain_gnu_ext_elf32_symbol_version_information : nat -> gnu_ext_elf32_symbol_version_table -> list (gnu_ext_elf32_verneed * list gnu_ext_elf32_vernaux) -> byte_sequence -> error string*)
val _ = Define `
 (obtain_gnu_ext_elf32_symbol_version_information index versym vernaux bs0 =  
((case lem_list$list_index (lem_list$list_combine versym vernaux) index of
      NONE => fail0 "obtain_gnu_ext_elf32_symbol_version_information: index outside range"
    | SOME (versym, vernaux) => return ""
  )))`;

val _ = export_theory()

