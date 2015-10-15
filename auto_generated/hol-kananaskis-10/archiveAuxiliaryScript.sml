(*Generated by Lem from archive.lem.*)
open HolKernel Parse boolLib bossLib;
open lem_numTheory lem_listTheory lem_basic_classesTheory lem_boolTheory lem_maybeTheory lem_stringTheory lem_assert_extraTheory showTheory missing_pervasivesTheory errorTheory byte_sequenceTheory archiveTheory;

val _ = numLib.prefer_num();



open lemLib;
(* val _ = lemLib.run_interactive := true; *)
val _ = new_theory "archiveAuxiliary"


(****************************************************)
(*                                                  *)
(* Termination Proofs                               *)
(*                                                  *)
(****************************************************)

(* val gst = Defn.tgoal_no_defn (accum_archive_contents_def, accum_archive_contents_ind) *)
val (accum_archive_contents_rw, accum_archive_contents_ind_rw) =
  Defn.tprove_no_defn ((accum_archive_contents_def, accum_archive_contents_ind),
    (* the termination proof *)
  )
val accum_archive_contents_rw = save_thm ("accum_archive_contents_rw", accum_archive_contents_rw);
val accum_archive_contents_ind_rw = save_thm ("accum_archive_contents_ind_rw", accum_archive_contents_ind_rw);




val _ = export_theory()

