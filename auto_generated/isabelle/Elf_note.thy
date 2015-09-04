chapter {* Generated by Lem from elf_note.lem. *}

theory "Elf_note" 

imports 
 	 Main
	 "/home/pes20/bitbucket/lem/isabelle-lib/Lem_num" 
	 "/home/pes20/bitbucket/lem/isabelle-lib/Lem_list" 
	 "/home/pes20/bitbucket/lem/isabelle-lib/Lem_basic_classes" 
	 "/home/pes20/bitbucket/lem/isabelle-lib/Lem_string" 
	 "Show" 
	 "Missing_pervasives" 
	 "Error" 
	 "Byte_sequence" 
	 "Endianness" 
	 "Elf_types_native_uint" 
	 "Elf_program_header_table" 
	 "Elf_section_header_table" 

begin 

(*open import Basic_classes*)
(*open import List*)
(*open import Num*)
(*open import String*)

(*open import Byte_sequence*)
(*open import Endianness*)
(*open import Error*)
(*open import Missing_pervasives*)
(*open import Show*)

(*open import Elf_program_header_table*)
(*open import Elf_section_header_table*)
(*open import Elf_types_native_uint*)

record elf32_note =
  
 elf32_note_namesz ::" uint32 "
   
 elf32_note_descsz ::" uint32 "
   
 elf32_note_type   ::" uint32 "
   
 elf32_note_name   ::" Elf_Types_Local.byte list "
   
 elf32_note_desc   ::" Elf_Types_Local.byte list "
   

   
record elf64_note =
  
 elf64_note_namesz ::" uint64 "
   
 elf64_note_descsz ::" uint64 "
   
 elf64_note_type   ::" uint64 "
   
 elf64_note_name   ::" Elf_Types_Local.byte list "
   
 elf64_note_desc   ::" Elf_Types_Local.byte list "
   

   
(*val read_elf32_note : endianness -> byte_sequence -> error (elf32_note * byte_sequence)*)
definition read_elf32_note  :: " endianness \<Rightarrow> byte_sequence \<Rightarrow>(elf32_note*byte_sequence)error "  where 
     " read_elf32_note endian bs0 = (
  read_elf32_word endian bs0 >>= (\<lambda> (namesz, bs0) . 
  read_elf32_word endian bs0 >>= (\<lambda> (descsz, bs0) . 
  read_elf32_word endian bs0 >>= (\<lambda> (typ1, bs0) . 
  repeatM' (unat namesz) bs0 read_char >>= (\<lambda> (name1, bs0) . 
  repeatM' (unat descsz) bs0 read_char >>= (\<lambda> (desc, bs0) . 
  error_return ((| elf32_note_namesz = namesz, elf32_note_descsz = descsz,
    elf32_note_type = typ1, elf32_note_name = name1, elf32_note_desc = desc |),
      bs0)))))))"

      
(*val read_elf64_note : endianness -> byte_sequence -> error (elf64_note * byte_sequence)*)
definition read_elf64_note  :: " endianness \<Rightarrow> byte_sequence \<Rightarrow>(elf64_note*byte_sequence)error "  where 
     " read_elf64_note endian bs0 = (
  read_elf64_xword endian bs0 >>= (\<lambda> (namesz, bs0) . 
  read_elf64_xword endian bs0 >>= (\<lambda> (descsz, bs0) . 
  read_elf64_xword endian bs0 >>= (\<lambda> (typ1, bs0) . 
  repeatM' (unat namesz) bs0 read_char >>= (\<lambda> (name1, bs0) . 
  repeatM' (unat descsz) bs0 read_char >>= (\<lambda> (desc, bs0) . 
  error_return ((| elf64_note_namesz = namesz, elf64_note_descsz = descsz,
    elf64_note_type = typ1, elf64_note_name = name1, elf64_note_desc = desc |),
      bs0)))))))"

      
(*val obtain_elf32_note_sections : endianness -> elf32_section_header_table ->
  byte_sequence -> error (list elf32_note)*)
definition obtain_elf32_note_sections  :: " endianness \<Rightarrow>(elf32_section_header_table_entry)list \<Rightarrow> byte_sequence \<Rightarrow>((elf32_note)list)error "  where 
     " obtain_elf32_note_sections endian sht bs0 = (
  (let note_sects =    
(List.filter (\<lambda> x . (elf32_sh_type  
      x) = Elf_Types_Local.uint32_of_nat sht_note
    ) sht)
  in
    mapM (\<lambda> x . 
      (let offset = (unat(elf32_sh_offset   x)) in
      (let size2   = (unat(elf32_sh_size   x)) in
      Byte_sequence.offset_and_cut offset size2 bs0 >>= (\<lambda> rel . 
      read_elf32_note endian rel >>= (\<lambda> (note1, _) . 
      error_return note1))))
    ) note_sects))"

    
(*val obtain_elf64_note_sections : endianness -> elf64_section_header_table ->
  byte_sequence -> error (list elf64_note)*)
definition obtain_elf64_note_sections  :: " endianness \<Rightarrow>(elf64_section_header_table_entry)list \<Rightarrow> byte_sequence \<Rightarrow>((elf64_note)list)error "  where 
     " obtain_elf64_note_sections endian sht bs0 = (
  (let note_sects =    
(List.filter (\<lambda> x . (elf64_sh_type  
      x) = Elf_Types_Local.uint32_of_nat sht_note
    ) sht)
  in
    mapM (\<lambda> x . 
      (let offset = (unat(elf64_sh_offset   x)) in
      (let size2   = (unat(elf64_sh_size   x)) in
      Byte_sequence.offset_and_cut offset size2 bs0 >>= (\<lambda> rel . 
      read_elf64_note endian rel >>= (\<lambda> (note1, _) . 
      error_return note1))))
    ) note_sects))"

    
(*val obtain_elf32_note_segments : endianness -> elf32_program_header_table ->
  byte_sequence -> error (list elf32_note)*)
definition obtain_elf32_note_segments  :: " endianness \<Rightarrow>(elf32_program_header_table_entry)list \<Rightarrow> byte_sequence \<Rightarrow>((elf32_note)list)error "  where 
     " obtain_elf32_note_segments endian pht bs0 = (
  (let note_segs =    
(List.filter (\<lambda> x . (elf32_p_type  
      x) = Elf_Types_Local.uint32_of_nat elf_pt_note
    ) pht)
  in
    mapM (\<lambda> x . 
      (let offset = (unat(elf32_p_offset   x)) in
      (let size2   = (unat(elf32_p_filesz   x)) in
      Byte_sequence.offset_and_cut offset size2 bs0 >>= (\<lambda> rel . 
      read_elf32_note endian rel >>= (\<lambda> (note1, _) . 
      error_return note1))))
    ) note_segs))"

    
(*val obtain_elf64_note_segments : endianness -> elf64_program_header_table ->
  byte_sequence -> error (list elf64_note)*)
definition obtain_elf64_note_segments  :: " endianness \<Rightarrow>(elf64_program_header_table_entry)list \<Rightarrow> byte_sequence \<Rightarrow>((elf64_note)list)error "  where 
     " obtain_elf64_note_segments endian pht bs0 = (
  (let note_segs =    
(List.filter (\<lambda> x . (elf64_p_type  
      x) = Elf_Types_Local.uint32_of_nat elf_pt_note
    ) pht)
  in
    mapM (\<lambda> x . 
      (let offset = (unat(elf64_p_offset   x)) in
      (let size2   = (unat(elf64_p_filesz   x)) in
      Byte_sequence.offset_and_cut offset size2 bs0 >>= (\<lambda> rel . 
      read_elf64_note endian rel >>= (\<lambda> (note1, _) . 
      error_return note1))))
    ) note_segs))"

    
(*val obtain_elf32_note_section_and_segments : endianness -> elf32_program_header_table ->
  elf32_section_header_table -> byte_sequence -> error (list elf32_note)*)
definition obtain_elf32_note_section_and_segments  :: " endianness \<Rightarrow>(elf32_program_header_table_entry)list \<Rightarrow>(elf32_section_header_table_entry)list \<Rightarrow> byte_sequence \<Rightarrow>((elf32_note)list)error "  where 
     " obtain_elf32_note_section_and_segments endian pht sht bs0 = (
  obtain_elf32_note_segments endian pht bs0 >>= (\<lambda> pht_notes . 
  obtain_elf32_note_sections endian sht bs0 >>= (\<lambda> sht_notes . 
  error_return (pht_notes @ sht_notes))))"

  
(*val obtain_elf64_note_section_and_segments : endianness -> elf64_program_header_table ->
  elf64_section_header_table -> byte_sequence -> error (list elf64_note)*)
definition obtain_elf64_note_section_and_segments  :: " endianness \<Rightarrow>(elf64_program_header_table_entry)list \<Rightarrow>(elf64_section_header_table_entry)list \<Rightarrow> byte_sequence \<Rightarrow>((elf64_note)list)error "  where 
     " obtain_elf64_note_section_and_segments endian pht sht bs0 = (
  obtain_elf64_note_segments endian pht bs0 >>= (\<lambda> pht_notes . 
  obtain_elf64_note_sections endian sht bs0 >>= (\<lambda> sht_notes . 
  error_return (pht_notes @ sht_notes))))"

    
(*val name_string_of_elf32_note : elf32_note -> string*)
definition name_string_of_elf32_note  :: " elf32_note \<Rightarrow> string "  where 
     " name_string_of_elf32_note note1 = (
  (let bs0   = (Byte_sequence.from_byte_lists [(elf32_note_name   note1)]) in
    Byte_sequence.string_of_byte_sequence bs0))"

    
(*val name_string_of_elf64_note : elf64_note -> string*)
definition name_string_of_elf64_note  :: " elf64_note \<Rightarrow> string "  where 
     " name_string_of_elf64_note note1 = (
  (let bs0   = (Byte_sequence.from_byte_lists [(elf64_note_name   note1)]) in
    Byte_sequence.string_of_byte_sequence bs0))"
 
end