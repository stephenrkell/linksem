theory Termination imports Main Import_everything begin

termination takebytes
  apply lexicographic_order
done

termination dropbytes
  apply(relation "measure (\<lambda>(l,_). l)")
  apply(auto simp add: naturalZero_def)
done

lemma dropbytes_length:
  fixes len :: "nat" and bs bs1 :: "byte_sequence"
  assumes "dropbytes len bs = Success bs1"
  shows "len + length0 bs1 = length0 bs"
using assms proof(cases bs, clarify)
  fix xs :: "byte list"
  assume "dropbytes len (Sequence xs) = Success bs1"
  thus "len + length0 bs1 = length0 (Sequence xs)"
  proof(induction xs arbitrary: len)
    fix len :: "nat"
    assume "dropbytes len (Sequence []) = Success bs1"
    thus "len + length0 bs1 = length0 (Sequence [])"
    proof(cases len)
      assume "len = 0"
      hence "Success bs1 = dropbytes 0 (Sequence [])"
        using `dropbytes len (Sequence []) = Success bs1` by auto
      moreover have "... = error_return (Sequence [])"
        using dropbytes.simps naturalZero_def by auto
      moreover have "... = Success (Sequence [])"
        using error_return_def by metis
      ultimately have "bs1 = Sequence []"
        by auto
      thus "len + length0 bs1 = length0 (Sequence [])"
        using length0.simps `len = 0` by auto
    next
      fix l :: "nat"
      assume "len = Suc l"
      hence "dropbytes len (Sequence []) = dropbytes (Suc l) (Sequence [])"
        by auto
      moreover have "... = error_fail ''dropbytes: cannot drop more bytes than are contained in sequence''"
        using naturalZero_def dropbytes.simps by auto
      moreover have "... = Fail ''dropbytes: cannot drop more bytes than are contained in sequence''"
        using error_fail_def by auto
      ultimately have "... = Success bs1"
        using `dropbytes len (Sequence []) = Success bs1` by metis
      thus "len + length0 bs1 = length0 (Sequence [])"
        by auto
    qed
  next
    fix x :: "byte" and xs :: "byte list" and len :: "nat"
    assume IH: "(\<And>len. dropbytes len (Sequence xs) = Success bs1 \<Longrightarrow> len + length0 bs1 = length0 (Sequence xs))"
      and "dropbytes len (Sequence (x # xs)) = Success bs1"
    thus "len + length0 bs1 = length0 (Sequence (x # xs))"
    proof(cases len)
      assume "len = 0"
      hence "Success bs1 = dropbytes 0 (Sequence (x # xs))"
        using `dropbytes len (Sequence (x#xs)) = Success bs1` by auto
      moreover have "... = error_return (Sequence (x#xs))"
        using naturalZero_def by auto
      moreover have "... = Success (Sequence (x#xs))"
        using error_return_def by metis
      ultimately have "bs1 = Sequence (x#xs)"
        by auto
      thus "len + length0 bs1 = length0 (Sequence (x # xs))"
        using `len = 0` by auto
    next
      fix l :: "nat"
      assume "len = Suc l"
      hence "Success bs1 = dropbytes (Suc l) (Sequence (x#xs))"
        using `dropbytes len (Sequence (x#xs)) = Success bs1` by auto
      moreover have "... = dropbytes l (Sequence xs)"
        using naturalZero_def by auto
      ultimately have "dropbytes l (Sequence xs) = Success bs1"
        by auto
      hence "l + length0 bs1 = length0 (Sequence xs)"
        using IH by simp
      thus "len + length0 bs1 = length0 (Sequence (x # xs))"
        using `len = Suc l` length0.simps by auto
    qed
  qed
qed

termination list_take_with_accum
  apply lexicographic_order
done

lemma list_take_with_accum_length:
  fixes len :: "nat" and xs accum :: "'a list"
  assumes "len \<le> length xs"
  shows "length (list_take_with_accum len accum xs) = len + length accum"
using assms proof(induction len arbitrary: accum xs)
  fix xs :: "'a list" and accum :: "'a list"
  show "length (list_take_with_accum 0 accum xs) = 0 + length accum" by auto
next
  fix len :: "nat" and accum :: "'a list" and xs :: "'a list"
  assume IH: "(\<And>accum xs :: 'a list. len \<le> length xs \<Longrightarrow> length (list_take_with_accum len accum xs) = len + length accum)"
    and *: "Suc len \<le> length xs"
  show "length (list_take_with_accum (Suc len) accum xs) = Suc len + length accum"
  proof(cases xs)
    assume "xs = []"
    thus ?thesis using * by auto
  next
    fix y :: "'a" and ys :: "'a list"
    assume **: "xs = y#ys"
    hence ***: "len \<le> length ys"
      using * by simp
    have "length (list_take_with_accum (Suc len) accum xs) = length (list_take_with_accum (Suc len) accum (y#ys))"
      using ** by auto
    moreover have "... = length (list_take_with_accum len (y#accum) ys)"
      by auto
    moreover have "... = len + length (y#accum)"
      using IH *** by simp
    ultimately show "length (list_take_with_accum (Suc len) accum xs) = Suc len + length accum"
      by auto
  qed
qed

lemma takebytes_r_with_length_length:
  assumes "len = length0 bs" and "takebytes_r_with_length cnt len bs = Success bs1"
  shows "length0 bs1 = cnt"
using assms proof(cases bs, clarify)
  fix xs :: "byte list"
  assume "takebytes_r_with_length cnt (length0 (Sequence xs)) (Sequence xs) = Success bs1"
  thus "length0 bs1 = cnt"
  proof(cases "cnt \<le> length0 (Sequence xs)")
    assume "cnt \<le> length0 (Sequence xs)"
    have "Success bs1 = takebytes_r_with_length cnt (length0 (Sequence xs)) (Sequence xs)"
      using `takebytes_r_with_length cnt (length0 (Sequence xs)) (Sequence xs) = Success bs1` by auto
    moreover have "... = error_return (Sequence (list_take_with_accum cnt [] xs))"
      using `cnt \<le> length0 (Sequence xs)` takebytes_r_with_length.simps by simp
    moreover have "... = Success (Sequence (list_take_with_accum cnt [] xs))"
      using error_return_def by metis
    ultimately have "bs1 = Sequence (list_take_with_accum cnt [] xs)"
      using error.simps by metis
    hence "length0 bs1 = length0 (Sequence (list_take_with_accum cnt [] xs))"
      by auto
    thus "length0 bs1 = cnt"
      using list_take_with_accum_length length0.simps `cnt \<le> length0 (Sequence xs)` by force
  next
    assume "\<not> cnt \<le> length0 (Sequence xs)"
    have "Success bs1 = takebytes_r_with_length cnt (length0 (Sequence xs)) (Sequence xs)"
      using `takebytes_r_with_length cnt (length0 (Sequence xs)) (Sequence xs) = Success bs1` by auto
    moreover have "... = error_fail ''takebytes: cannot take more bytes than are contained in sequence''"
      using takebytes_r_with_length.simps `\<not>cnt \<le> length0 (Sequence xs)` by auto
    moreover have "... = Fail ''takebytes: cannot take more bytes than are contained in sequence''"
      using error_fail_def by metis
    ultimately have "Success bs1 = Fail ''takebytes: cannot take more bytes than are contained in sequence''"
      by auto
    thus "length0 bs1 = cnt"
      using error.simps by simp
  qed
qed

lemma takebytes_length:
  fixes len :: "nat" and bs bs1 :: "byte_sequence"
  assumes "takebytes len bs = Success bs1"
  shows "length0 bs1 = len"
using assms
  apply(case_tac bs, clarify)
  apply(simp only: takebytes.simps)
  apply(simp only: Let_def)
  apply(rule_tac len="length x" and bs="Sequence x" in takebytes_r_with_length_length)
  apply(simp only: length0.simps)
  apply auto
done

lemma offset_and_cut_length:
  assumes "offset_and_cut off len bs0 = Success bs1"
  shows "length0 bs1 = len"
using assms unfolding offset_and_cut_def
  apply(case_tac "dropbytes off bs0", simp_all add: error_bind.simps)
  apply(case_tac "takebytes len x1", simp_all add: error_bind.simps error_return_def)
  apply(rule takebytes_length, assumption)
done

lemma takebytes_with_length_length:
  assumes "len = length0 bs0" and "takebytes_with_length cnt len bs0 = Success bs1"
  shows "length0 bs1 = cnt"
using assms
  apply(cases bs0)
  apply(simp add: takebytes_with_length.simps)
  apply(rule_tac len="length x" and bs="Sequence x" in takebytes_r_with_length_length)
  apply(simp add: length0.simps)+
done

lemma partition_with_length_length:
  assumes "partition_with_length off len bs0 = Success (bs1, bs2)"
  shows "length0 bs1 = off \<and> length0 bs2 = len"
using assms unfolding partition_with_length_def
  apply(case_tac "takebytes_with_length off len bs0", simp_all add: error_bind.simps)
  apply(case_tac "dropbytes off bs0", simp_all add: error_bind.simps)
  apply(simp only: error_return_def error.simps prod.simps)
  apply(drule dropbytes_length)
  apply(drule takebytes_with_length_length)
  apply simp

lemma read_archive_entry_header_length:
  assumes "read_archive_entry_header len bs = Success (hdr, sz, bs1)"
  shows "Byte_sequence.length0 bs1 < Byte_sequence.length0 bs"
using assms unfolding read_archive_entry_header_def
  apply(simp only: Let_def)
  apply(case_tac "partition_with_length 60 len bs", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "offset_and_cut 58 2 a", simp_all add: error_bind.simps)
  apply(case_tac "offset_and_cut 0 16 a", simp_all add: error_bind.simps)
  apply(case_tac "offset_and_cut 16 12 a", simp_all add: error_bind.simps)
  apply(case_tac "offset_and_cut 28 6 a", simp_all add: error_bind.simps)
  apply(case_tac "offset_and_cut 34 6 a", simp_all add: error_bind.simps)
  apply(case_tac "offset_and_cut 40 8 a", simp_all add: error_bind.simps)
  apply(case_tac "offset_and_cut 48 10 a", simp_all add: error_bind.simps)
  apply(simp add: error_return_def)
  apply(drule offset_and_cut_length)+
  apply(drule partition_with_length_length)
  apply(erule conjE)+
  sorry (* XXX: definition needs changing *)

lemma set_split_union:
  assumes "split dict e s = (x, y)"
  shows "s = x \<union> { e } \<union> y"
using assms unfolding split_def
  apply(rule Product_Type.Pair_inject)
  apply clarify
  sorry

lemma set_choose_member:
  assumes "s \<noteq> {}"
  shows "set_choose s \<in> s"
using assms by auto

lemma chooseAndSplit_card1:
  assumes "chooseAndSplit dict s = Some (x, y)"
  shows "card x < card s"
using assms
sorry

lemma chooseAndSplit_card2:
  assumes "chooseAndSplit dict s = Some (x, y, z)"
  shows "card z < card s"
using assms unfolding chooseAndSplit_def
  sorry

lemma lt_technical1:
  fixes q :: nat
  assumes "0 < q"
  shows "0 < 2 * q"
using assms by auto

lemma lt_technical2:
  fixes m :: nat
  shows "0 < Suc m"
by auto

lemma read_elf32_dyn_cong [fundef_cong]:
  assumes "endian0 = endian1" and "bs0 = bs1" and "shared_object0 = shared_object1" and "os_additional_ranges0 = os_additional_ranges1"
     and "os0 = os1" and "proc0 = proc1"
  shows "read_elf32_dyn endian0 bs0 shared_object0 os_additional_ranges0 os0 proc0 = read_elf32_dyn endian1 bs1 shared_object1 os_additional_ranges1 os1 proc1"
using assms by simp

lemma find_first_not_in_range_cong [fundef_cong]:
  assumes "start1 = start2" and "ranges1 = ranges2"
  shows "find_first_not_in_range start1 ranges1 = find_first_not_in_range start2 ranges2"
using assms by simp

lemma find_first_in_range_cong [fundef_cong]:
  assumes "start1 = start2" and "ranges1 = ranges2"
  shows "find_first_in_range start1 ranges1 = find_first_in_range start2 ranges2"
using assms by simp

section {* Termination *}

termination accum_archive_contents
  apply(relation "measure (\<lambda>(_,_,_,b). length0 b)")
  apply simp
  apply(case_tac x1, simp)
  apply(frule read_archive_entry_header_length)
  apply(case_tac "size0 a mod 2", simp add: Let_def)
  apply(case_tac "name a = ''/               ''", simp)
  apply(frule dropbytes_length)
  apply linarith
  apply(frule dropbytes_length)
  apply linarith
  apply simp
  apply(subgoal_tac "0 < Suc (size0 a)")
  apply(frule dropbytes_length)
  apply linarith
  apply auto
done

termination repeat
  apply(relation "measure (\<lambda>(l,_). l)")
  apply auto
done

termination concat_byte_sequence
  apply lexicographic_order
done

lemma read_char_length:
  assumes "read_char bs0 = Success (c, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(case_tac x, simp)
  apply(simp_all add: read_char.simps error_fail_def error_return_def)
  apply(auto simp add: length0.simps)
done

lemma read_2_bytes_be_length:
  assumes "read_2_bytes_be bs0 = Success (bytes, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(simp only: read_2_bytes_be_def)
  apply(case_tac "read_char (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_char b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp add: error_return_def)
  apply(drule read_char_length)+
  apply linarith
done

lemma read_2_bytes_le_length:
  assumes "read_2_bytes_le bs0 = Success (bytes, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(simp only: read_2_bytes_le_def)
  apply(case_tac "read_char (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_char b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp add: error_return_def)
  apply(drule read_char_length)+
  apply linarith
done

lemma read_4_bytes_be_length:
  assumes "read_4_bytes_be bs0 = Success (bytes, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(simp only: read_4_bytes_be_def)
  apply(case_tac "read_char (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_char b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(case_tac "read_char ba", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac "read_char bb", simp_all add: error_bind.simps)
  apply(case_tac x1c, simp add: error_return_def)
  apply(drule read_char_length)+
  apply linarith
done

lemma read_4_bytes_le_length:
  assumes "read_4_bytes_le bs0 = Success (bytes, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(simp only: read_4_bytes_le_def)
  apply(case_tac "read_char (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_char b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(case_tac "read_char ba", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac "read_char bb", simp_all add: error_bind.simps)
  apply(case_tac x1c, simp add: error_return_def)
  apply(drule read_char_length)+
  apply linarith
done

lemma read_8_bytes_be_length:
  assumes "read_8_bytes_be bs0 = Success (bytes, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(simp only: read_8_bytes_be_def)
  apply(case_tac "read_char (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_char b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(case_tac "read_char ba", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac "read_char bb", simp_all add: error_bind.simps)
  apply(case_tac x1c, simp)
  apply(case_tac "read_char bc", simp_all add: error_bind.simps)
  apply(case_tac x1d, simp)
  apply(case_tac "read_char bd", simp_all add: error_bind.simps)
  apply(case_tac x1e, simp)
  apply(case_tac "read_char be", simp_all add: error_bind.simps)
  apply(case_tac x1f, simp)
  apply(case_tac "read_char bf", simp_all add: error_bind.simps)
  apply(case_tac x1g, simp add: error_return_def)
  apply(drule read_char_length)+
  apply linarith
done

lemma read_8_bytes_le_length:
  assumes "read_8_bytes_le bs0 = Success (bytes, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(simp only: read_8_bytes_le_def)
  apply(case_tac "read_char (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_char b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(case_tac "read_char ba", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac "read_char bb", simp_all add: error_bind.simps)
  apply(case_tac x1c, simp)
  apply(case_tac "read_char bc", simp_all add: error_bind.simps)
  apply(case_tac x1d, simp)
  apply(case_tac "read_char bd", simp_all add: error_bind.simps)
  apply(case_tac x1e, simp)
  apply(case_tac "read_char be", simp_all add: error_bind.simps)
  apply(case_tac x1f, simp)
  apply(case_tac "read_char bf", simp_all add: error_bind.simps)
  apply(case_tac x1g, simp add: error_return_def)
  apply(drule read_char_length)+
  apply linarith
done

lemma read_elf32_sword_length:
  assumes "read_elf32_sword endian bs0 = Success (wrd, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(case_tac endian, simp_all)
  apply(simp_all only: read_elf32_sword.simps)
  apply(case_tac "read_4_bytes_be (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(simp add: error_return_def)
  apply(drule read_4_bytes_be_length)
  apply linarith
  apply(case_tac "read_4_bytes_le (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(simp add: error_return_def)
  apply(drule read_4_bytes_le_length)
  apply linarith
done

lemma read_elf32_word_length:
  assumes "read_elf32_word endian bs0 = Success (wrd, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(case_tac endian, simp)
  apply(simp only: read_elf32_word.simps)
  apply(case_tac "read_4_bytes_be (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(simp add: error_return_def)
  apply(drule read_4_bytes_be_length)
  apply assumption
  apply(simp only: read_elf32_word.simps)
  apply(case_tac "read_4_bytes_le (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(simp add: error_return_def)
  apply(drule read_4_bytes_le_length)
  apply assumption
done

lemma read_elf32_addr_length:
  assumes "read_elf32_addr endian bs0 = Success (wrd, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(case_tac endian, simp)
  apply(simp only: read_elf32_addr.simps)
  apply(case_tac "read_4_bytes_be (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(simp add: error_return_def)
  apply(drule read_4_bytes_be_length)
  apply assumption
  apply(simp only: read_elf32_addr.simps)
  apply(case_tac "read_4_bytes_le (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(simp add: error_return_def)
  apply(drule read_4_bytes_le_length)
  apply assumption
done

lemma read_elf32_off_length:
  assumes "read_elf32_off endian bs0 = Success (wrd, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(case_tac endian, simp)
  apply(simp only: read_elf32_off.simps)
  apply(case_tac "read_4_bytes_be (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(simp add: error_return_def)
  apply(drule read_4_bytes_be_length)
  apply assumption
  apply(simp only: read_elf32_off.simps)
  apply(case_tac "read_4_bytes_le (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(simp add: error_return_def)
  apply(drule read_4_bytes_le_length)
  apply assumption
done

lemma read_elf32_half_length:
  assumes "read_elf32_half endian bs0 = Success (wrd, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(case_tac endian, simp)
  apply(simp only: read_elf32_half.simps)
  apply(case_tac "read_2_bytes_be (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(simp add: error_return_def)
  apply(drule read_2_bytes_be_length)
  apply assumption
  apply(simp only: read_elf32_half.simps)
  apply(case_tac "read_2_bytes_le (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(simp add: error_return_def)
  apply(drule read_2_bytes_le_length)
  apply assumption
done

lemma read_unsigned_char_length:
  assumes "read_unsigned_char end bs0 = Success (bytes, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(simp only: read_unsigned_char_def)
  apply(case_tac "read_char (Sequence x)", simp_all add: error_bind.simps error_return_def)
  apply(drule read_char_length)
  apply assumption
done

termination obtain_elf32_dynamic_section_contents'
  apply(relation "measure (\<lambda>(_, b, _, _, _, _). length0 b)")
  apply simp+
  apply(case_tac bs0)
  apply simp
  apply(simp only: read_elf32_dyn_def Let_def)
  apply(case_tac "read_elf32_sword endian (Sequence xa)")
  apply(simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "tag_correspondence_of_tag shared_object (nat \<bar>sint a\<bar>) os_additional_ranges os proc", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp_all)
  apply(case_tac "read_elf32_word endian b", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(drule read_elf32_sword_length)
  apply(drule read_elf32_word_length)
  apply linarith
  apply(case_tac "read_elf32_addr endian b", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(drule read_elf32_sword_length)
  apply(drule read_elf32_addr_length)
  apply linarith
  apply(case_tac endian, simp_all)
  apply(case_tac "read_4_bytes_be b", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac aa, simp)
  apply(drule read_elf32_sword_length)
  apply(drule read_4_bytes_be_length)
  apply linarith
  apply(case_tac "read_4_bytes_le b", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac aa, simp)
  apply(drule read_elf32_sword_length)
  apply(drule read_4_bytes_le_length)
  apply linarith
done

lemma read_elf64_word_length:
  assumes "read_elf64_word endian bs0 = Success (wrd, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(case_tac endian, simp_all add: read_elf64_word.simps)
  apply(case_tac "read_4_bytes_be (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp add: error_return_def)
  apply(drule read_4_bytes_be_length, assumption)
  apply(case_tac "read_4_bytes_le (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp add: error_return_def)
  apply(drule read_4_bytes_le_length, assumption)
done

lemma read_elf64_xword_length:
  assumes "read_elf64_xword endian bs0 = Success (wrd, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(case_tac endian, simp_all add: read_elf64_xword.simps)
  apply(case_tac "read_8_bytes_be (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(case_tac g, simp add: error_return_def)
  apply(drule read_8_bytes_be_length, assumption)
  apply(case_tac "read_8_bytes_le (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(case_tac g, simp add: error_return_def)
  apply(drule read_8_bytes_le_length, assumption)
done

lemma read_elf64_sxword_length:
  assumes "read_elf64_sxword endian bs0 = Success (wrd, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(case_tac endian, simp_all add: read_elf64_sxword.simps)
  apply(case_tac "read_8_bytes_be (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(case_tac g, simp add: error_return_def)
  apply(drule read_8_bytes_be_length, assumption)
  apply(case_tac "read_8_bytes_le (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(case_tac g, simp add: error_return_def)
  apply(drule read_8_bytes_le_length, assumption)
done

lemma read_elf64_addr_length:
  assumes "read_elf64_addr endian bs0 = Success (wrd, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(case_tac endian, simp_all add: read_elf64_addr.simps)
  apply(case_tac "read_8_bytes_be (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(case_tac g, simp add: error_return_def)
  apply(drule read_8_bytes_be_length, assumption)
  apply(case_tac "read_8_bytes_le (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(case_tac g, simp add: error_return_def)
  apply(drule read_8_bytes_le_length, assumption)
done

lemma read_elf64_off_length:
  assumes "read_elf64_off endian bs0 = Success (wrd, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(case_tac endian, simp_all add: read_elf64_off.simps)
  apply(case_tac "read_8_bytes_be (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(case_tac g, simp add: error_return_def)
  apply(drule read_8_bytes_be_length, assumption)
  apply(case_tac "read_8_bytes_le (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp)
  apply(case_tac g, simp add: error_return_def)
  apply(drule read_8_bytes_le_length, assumption)
done

lemma read_elf64_half_length:
  assumes "read_elf64_half endian bs0 = Success (wrd, bs1)"
  shows "length0 bs1 < length0 bs0"
using assms
  apply(case_tac bs0, simp)
  apply(case_tac endian, simp_all add: read_elf64_half.simps)
  apply(case_tac "read_2_bytes_be (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp add: error_return_def)
  apply(drule read_2_bytes_be_length, assumption)
  apply(case_tac "read_2_bytes_le (Sequence x)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac a, simp add: error_return_def)
  apply(drule read_2_bytes_le_length, assumption)
done

termination obtain_elf64_dynamic_section_contents'
  apply(relation "measure (\<lambda>(_, b, _, _, _, _). length0 b)")
  apply simp+
  apply(case_tac bs0)
  apply simp
  apply(simp only: read_elf64_dyn_def Let_def)
  apply(case_tac "read_elf64_sxword endian (Sequence xa)")
  apply(simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "tag_correspondence_of_tag shared_object (nat \<bar>sint a\<bar>) os_additional_ranges os proc", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp_all)
  apply(case_tac "read_elf64_xword endian b", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(drule read_elf64_xword_length)
  apply(drule read_elf64_sxword_length)
  apply linarith
  apply(case_tac "read_elf64_addr endian b", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(drule read_elf64_sxword_length)
  apply(drule read_elf64_addr_length)
  apply linarith
  apply(case_tac endian, simp_all)
  apply(case_tac "read_8_bytes_be b", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac aa, simp)
  apply(case_tac g, simp)
  apply(drule read_elf64_sxword_length)
  apply(drule read_8_bytes_be_length)
  apply linarith
  apply(case_tac "read_8_bytes_le b", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac aa, simp)
  apply(case_tac g, simp)
  apply(drule read_elf64_sxword_length)
  apply(drule read_8_bytes_le_length)
  apply linarith
done

fun (in linorder) merge :: "'a list \<Rightarrow> 'a list \<Rightarrow> 'a list" where
  "merge [] ys = ys" |
  "merge xs [] = xs" |
  "merge (x#xs) (y#ys) =
     (if x \<le> y then
       x#merge xs (y#ys)
     else
       y#merge (x#xs) ys)"

fun (in linorder) sort :: "'a list \<Rightarrow> 'a list" where
  "sort []  = []" |
  "sort [x] = [x]" |
  "sort xs  =
     (let len = List.length xs div 2 in
      let lft = List.take len xs in
      let rgt = List.drop len xs in
        merge (sort lft) (sort rgt))"

inductive (in linorder) sorted :: "'a list \<Rightarrow> bool" where
  sorted_empty [intro!]: "sorted []" |
  sorted_singleton [intro!]: "sorted [x]" |
  sorted_step [intro!]: "\<lbrakk> sorted (x#xs); y \<le> x \<rbrakk> \<Longrightarrow> sorted (y#x#xs)"

declare [[show_types]]

lemma list_induct':
  assumes "P []" and "\<And>x. P [x]"
    and "\<And>x y xs. P (x#xs) \<Longrightarrow> P (y#x#xs)"
  shows "P xs"
using assms
  apply(induct_tac xs)
  apply(rule assms(1))
  apply(case_tac list, clarify)
  apply(rule assms(2))
  apply clarify
  apply(rule assms(3))
  apply assumption
done

instantiation prod :: (linorder, linorder)linorder begin

  fun less_eq_prod :: "'a \<times> 'b \<Rightarrow> 'a \<times> 'b \<Rightarrow> bool" where
    "less_eq_prod (l1, r1) (l2, r2) =
       (if l1 < l2 then
          True
        else if l1 = l2 then
          r1 \<le> r2
        else
          False)"

  fun less_prod :: "'a \<times> 'b \<Rightarrow> 'a \<times> 'b \<Rightarrow> bool" where
    "less_prod (l1, r1) (l2, r2) =
       (if l1 < l2 then
          True
        else if l1 = l2 then
          r1 < r2
        else
          False)"

  instance proof
    fix x y :: "'a \<times> 'b"
    show "(x < y) = (x \<le> y \<and> \<not> y \<le> x)"
      apply(case_tac x; case_tac y, clarify)
      apply auto
    done
  next
    fix x :: "'a \<times> 'b"
    show "x \<le> x"
      apply(case_tac x, clarify)
      apply auto
    done
  next
    fix x y z :: "'a \<times> 'b"
    assume "x \<le> y" and "y \<le> z"
    thus "x \<le> z"
      apply(case_tac x; case_tac y; case_tac z, simp)
      apply(metis less_not_sym less_trans order.trans)
    done
  next
    fix x y :: "'a \<times> 'b"
    assume "x \<le> y" and "y \<le> x"
    thus "x = y"
      apply(case_tac x; case_tac y; simp)
      apply(metis antisym not_less_iff_gr_or_eq)
    done
  next
    fix x y :: "'a \<times> 'b"
    show "x \<le> y \<or> y \<le> x"
      apply(case_tac x; case_tac y; clarify)
      apply(fastforce simp add: neq_iff)
    done
  qed
end

termination find_first_not_in_range
  apply(relation "measure (\<lambda>(s, r). s - Max (collapse r))")
  apply simp
  apply(case_tac ranges, simp_all)
  apply(case_tac a, simp_all)
  apply(case_tac "aa \<le> start \<and> start \<le> b", simp_all)
  apply auto

termination find_first_in_range
  sorry

termination compute_differences
  apply(relation "measure (\<lambda>(s, m, _). m - s)")
  sorry

termination read_elf32_program_header_table'
  apply(relation "measure (\<lambda>(_, b). length0 b)")
  apply simp
  apply(case_tac bs0, simp)
  apply(simp only: read_elf32_program_header_table_entry_def)
  apply(case_tac "read_elf32_word endian (Sequence xa)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_elf32_off endian b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(case_tac "read_elf32_addr endian ba", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac "read_elf32_addr endian bb", simp_all add: error_bind.simps)
  apply(case_tac x1c, simp)
  apply(case_tac "read_elf32_word endian bc", simp_all add: error_bind.simps)
  apply(case_tac x1d, simp)
  apply(case_tac "read_elf32_word endian bd", simp_all add: error_bind.simps)
  apply(case_tac x1e, simp)
  apply(case_tac "read_elf32_word endian be", simp_all add: error_bind.simps)
  apply(case_tac x1f, simp)
  apply(case_tac "read_elf32_word endian bf", simp_all add: error_bind.simps)
  apply(case_tac x1g, simp)
  apply(drule read_elf32_word_length)+
  apply(drule read_elf32_addr_length)+
  apply(drule read_elf32_off_length)
  apply linarith
done

termination read_elf64_program_header_table'
  apply(relation "measure (\<lambda>(_, b). length0 b)")
  apply simp
  apply(case_tac bs0, simp)
  apply(simp only: read_elf64_program_header_table_entry_def)
  apply(case_tac "read_elf64_word endian (Sequence xa)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_elf64_word endian b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(case_tac "read_elf64_off endian ba", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac "read_elf64_addr endian bb", simp_all add: error_bind.simps)
  apply(case_tac x1c, simp)
  apply(case_tac "read_elf64_addr endian bc", simp_all add: error_bind.simps)
  apply(case_tac x1d, simp)
  apply(case_tac "read_elf64_xword endian bd", simp_all add: error_bind.simps)
  apply(case_tac x1e, simp)
  apply(case_tac "read_elf64_xword endian be", simp_all add: error_bind.simps)
  apply(case_tac x1f, simp)
  apply(case_tac "read_elf64_xword endian bf", simp_all add: error_bind.simps)
  apply(case_tac x1g, simp)
  apply(drule read_elf64_word_length)+
  apply(drule read_elf64_xword_length)+
  apply(drule read_elf64_addr_length)+
  apply(drule read_elf64_off_length)
  apply linarith
done

termination read_elf32_relocation_section'
  apply(relation "measure (\<lambda>(_, b). length0 b)")
  apply simp
  apply(case_tac bs0, simp)
  apply(simp only: read_elf32_relocation_def)
  apply(case_tac "read_elf32_addr endian (Sequence xa)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_elf32_word endian b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(drule read_elf32_addr_length)
  apply(drule read_elf32_word_length)
  apply linarith
done

termination read_elf64_relocation_section'
  apply(relation "measure (\<lambda>(_, b). length0 b)")
  apply simp
  apply(case_tac bs0, simp)
  apply(simp only: read_elf64_relocation_def)
  apply(case_tac "read_elf64_addr endian (Sequence xa)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_elf64_xword endian b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(drule read_elf64_addr_length)
  apply(drule read_elf64_xword_length)
  apply linarith
done

termination read_elf32_relocation_a_section'
  apply(relation "measure (\<lambda>(_, b). length0 b)")
  apply simp
  apply(case_tac bs0, simp)
  apply(simp only: read_elf32_relocation_a_def)
  apply(case_tac "read_elf32_addr endian (Sequence xa)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_elf32_word endian b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(case_tac "read_elf32_sword endian ba", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(drule read_elf32_addr_length)
  apply(drule read_elf32_word_length)
  apply(drule read_elf32_sword_length)
  apply linarith
done

termination read_elf64_relocation_a_section'
  apply(relation "measure (\<lambda>(_, b). length0 b)")
  apply simp
  apply(case_tac bs0, simp)
  apply(simp only: read_elf64_relocation_a_def)
  apply(case_tac "read_elf64_addr endian (Sequence xa)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_elf64_xword endian b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(case_tac "read_elf64_sxword endian ba", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(drule read_elf64_addr_length)
  apply(drule read_elf64_xword_length)
  apply(drule read_elf64_sxword_length)
  apply linarith
done

termination read_elf32_section_header_table'
  apply(relation "measure (\<lambda>(_, b). length0 b)")
  apply simp
  apply(case_tac bs0, simp)
  apply(simp only: read_elf32_section_header_table_entry_def)
  apply(case_tac "read_elf32_word endian (Sequence xa)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_elf32_word endian b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(case_tac "read_elf32_word endian ba", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac "read_elf32_addr endian bb", simp_all add: error_bind.simps)
  apply(case_tac x1c, simp)
  apply(case_tac "read_elf32_off endian bc", simp_all add: error_bind.simps)
  apply(case_tac x1d, simp)
  apply(case_tac "read_elf32_word endian bd", simp_all add: error_bind.simps)
  apply(case_tac x1e, simp)
  apply(case_tac "read_elf32_word endian be", simp_all add: error_bind.simps)
  apply(case_tac x1f, simp)
  apply(case_tac "read_elf32_word endian bf", simp_all add: error_bind.simps)
  apply(case_tac x1g, simp)
  apply(case_tac "read_elf32_word endian bg", simp_all add: error_bind.simps)
  apply(case_tac x1h, simp)
  apply(case_tac "read_elf32_word endian bh", simp_all add: error_bind.simps)
  apply(case_tac x1i, simp)
  apply(drule read_elf32_word_length)+
  apply(drule read_elf32_addr_length)+
  apply(drule read_elf32_off_length)+
  apply linarith
done

termination read_elf64_section_header_table'
  apply(relation "measure (\<lambda>(_, b). length0 b)")
  apply simp
  apply(case_tac bs0, simp)
  apply(simp only: read_elf64_section_header_table_entry_def)
  apply(case_tac "read_elf64_word endian (Sequence xa)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_elf64_word endian b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(case_tac "read_elf64_xword endian ba", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac "read_elf64_addr endian bb", simp_all add: error_bind.simps)
  apply(case_tac x1c, simp)
  apply(case_tac "read_elf64_off endian bc", simp_all add: error_bind.simps)
  apply(case_tac x1d, simp)
  apply(case_tac "read_elf64_xword endian bd", simp_all add: error_bind.simps)
  apply(case_tac x1e, simp)
  apply(case_tac "read_elf64_word endian be", simp_all add: error_bind.simps)
  apply(case_tac x1f, simp)
  apply(case_tac "read_elf64_word endian bf", simp_all add: error_bind.simps)
  apply(case_tac x1g, simp)
  apply(case_tac "read_elf64_xword endian bg", simp_all add: error_bind.simps)
  apply(case_tac x1h, simp)
  apply(case_tac "read_elf64_xword endian bh", simp_all add: error_bind.simps)
  apply(case_tac x1i, simp)
  apply(drule read_elf64_word_length)+
  apply(drule read_elf64_addr_length)+
  apply(drule read_elf64_xword_length)+
  apply(drule read_elf64_off_length)+
  apply linarith
done

termination get_elf32_section_to_segment_mapping
  apply lexicographic_order
done

termination get_elf64_section_to_segment_mapping
  apply lexicographic_order
done

termination read_elf32_symbol_table
  apply(relation "measure (\<lambda>(_, b). length0 b)")
  apply simp
  apply(case_tac bs0, simp)
  apply(simp only: read_elf32_symbol_table_entry_def)
  apply(case_tac "read_elf32_word endian (Sequence xa)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_elf32_addr endian b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(case_tac "read_elf32_word endian ba", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac "read_unsigned_char endian bb", simp_all add: error_bind.simps)
  apply(case_tac x1c, simp)
  apply(case_tac "read_unsigned_char endian bc", simp_all add: error_bind.simps)
  apply(case_tac x1d, simp)
  apply(case_tac "read_elf32_half endian bd", simp_all add: error_bind.simps)
  apply(case_tac x1e, simp)
  apply(drule read_elf32_word_length)+
  apply(drule read_elf32_addr_length)+
  apply(drule read_unsigned_char_length)+
  apply(drule read_elf32_half_length)+
  apply linarith
done

termination read_elf64_symbol_table
  apply(relation "measure (\<lambda>(_, b). length0 b)")
  apply simp
  apply(case_tac bs0, simp)
  apply(simp only: read_elf64_symbol_table_entry_def)
  apply(case_tac "read_elf64_word endian (Sequence xa)", simp_all add: error_bind.simps)
  apply(case_tac x1, simp)
  apply(case_tac "read_unsigned_char endian b", simp_all add: error_bind.simps)
  apply(case_tac x1a, simp)
  apply(case_tac "read_unsigned_char endian ba", simp_all add: error_bind.simps)
  apply(case_tac x1b, simp)
  apply(case_tac "read_elf64_half endian bb", simp_all add: error_bind.simps)
  apply(case_tac x1c, simp)
  apply(case_tac "read_elf64_addr endian bc", simp_all add: error_bind.simps)
  apply(case_tac x1d, simp)
  apply(case_tac "read_elf64_xword endian bd", simp_all add: error_bind.simps)
  apply(case_tac x1e, simp)
  apply(drule read_elf64_word_length)+
  apply(drule read_elf64_xword_length)+
  apply(drule read_elf64_addr_length)+
  apply(drule read_unsigned_char_length)+
  apply(drule read_elf64_half_length)+
  apply linarith
done

termination repeatM
  apply lexicographic_order
done

termination repeatM'
  apply lexicographic_order
done

termination mapM
  apply lexicographic_order
done

termination foldM
  apply lexicographic_order
done

termination group_elf32_words
  apply lexicographic_order
done

termination group_elf64_words
  apply lexicographic_order
done

termination read_gnu_ext_elf32_verdefs
(* XXX: not terminating *)
  sorry

termination read_gnu_ext_elf64_verdefs
(* XXX: see above? *)
  sorry

termination obtain_gnu_ext_elf32_veraux
  apply lexicographic_order
done

termination obtain_gnu_ext_elf64_veraux
  apply lexicographic_order
done

termination read_gnu_ext_elf32_verneeds
(* XXX: not terminating *)
  sorry

termination read_gnu_ext_elf64_verneeds
(* XXX: not terminating *)
  sorry

termination read_gnu_ext_elf32_vernauxs
(* XXX: not terminating *)
  sorry

termination obtain_gnu_ext_elf64_vernaux (* XXX: why the discrepancy with the function above? *)
  apply lexicographic_order
done

termination concatS'
  apply lexicographic_order
done

termination nat_range
  apply lexicographic_order
done

termination expand_sorted_ranges
  apply lexicographic_order
done

termination make_byte_pattern_revacc
  apply lexicographic_order
done

termination relax_byte_pattern_revacc
  apply lexicographic_order
done

termination byte_list_matches_pattern
  apply lexicographic_order
done

termination accum_pattern_possible_starts_in_one_byte_sequence
  apply lexicographic_order
done

termination natural_of_decimal_string_helper
  apply lexicographic_order
done

termination hex_string_of_natural
  apply lexicographic_order
done

termination merge_by
  apply lexicographic_order
done

termination mapMaybei'
  apply lexicographic_order
done

termination partitionii'
  apply lexicographic_order
done

termination intercalate'
  apply lexicographic_order
done

termination take
  apply lexicographic_order
done

termination string_index_of'
  apply lexicographic_order
done

termination find_index_helper
  apply lexicographic_order
done

termination replicate_revacc
  apply lexicographic_order
done

termination list_reverse_concat_map_helper
  apply lexicographic_order
done

termination findLowestEquiv
  apply(relation "measure (\<lambda>(_,_,_,_,_,s,_). Finite_Set.card s)")
  apply simp
  apply(case_tac x2, simp)
  apply(drule chooseAndSplit_card1, assumption)
  apply(case_tac x2, simp)
  apply(drule chooseAndSplit_card1, assumption)
  apply(case_tac x2, simp)
  apply(drule chooseAndSplit_card1, assumption)
  apply(case_tac x2, simp)
  apply(drule chooseAndSplit_card1, assumption)
  apply(case_tac x2, simp)
  apply(drule chooseAndSplit_card2, assumption)
done

termination findHighestEquiv
  apply(relation "measure (\<lambda>(_,_,_,_,_,s,_). Finite_Set.card s)")
  apply simp
  apply(case_tac x2, simp)
  apply(drule chooseAndSplit_card2, assumption)
  apply(case_tac x2, simp)
  apply(drule chooseAndSplit_card2, assumption)
  apply(case_tac x2, simp)
  apply(drule chooseAndSplit_card2, assumption)
  apply(case_tac x2, simp)
  apply(drule chooseAndSplit_card2, assumption)
  apply(case_tac x2, simp)
  apply(drule chooseAndSplit_card1, assumption)
done

end