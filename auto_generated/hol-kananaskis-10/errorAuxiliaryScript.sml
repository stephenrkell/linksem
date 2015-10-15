(*Generated by Lem from error.lem.*)
open HolKernel Parse boolLib bossLib;
open lem_numTheory lem_listTheory lem_basic_classesTheory lem_maybeTheory lem_stringTheory showTheory errorTheory;

val _ = numLib.prefer_num();



open lemLib;
(* val _ = lemLib.run_interactive := true; *)
val _ = new_theory "errorAuxiliary"


(****************************************************)
(*                                                  *)
(* Termination Proofs                               *)
(*                                                  *)
(****************************************************)

(* val gst = Defn.tgoal_no_defn (repeatM_def, repeatM_ind) *)
val (repeatM_rw, repeatM_ind_rw) =
  Defn.tprove_no_defn ((repeatM_def, repeatM_ind),
    (* the termination proof *)
  )
val repeatM_rw = save_thm ("repeatM_rw", repeatM_rw);
val repeatM_ind_rw = save_thm ("repeatM_ind_rw", repeatM_ind_rw);


(* val gst = Defn.tgoal_no_defn (repeatM'_def, repeatM'_ind) *)
val (repeatM'_rw, repeatM'_ind_rw) =
  Defn.tprove_no_defn ((repeatM'_def, repeatM'_ind),
    (* the termination proof *)
  )
val repeatM'_rw = save_thm ("repeatM'_rw", repeatM'_rw);
val repeatM'_ind_rw = save_thm ("repeatM'_ind_rw", repeatM'_ind_rw);


(* val gst = Defn.tgoal_no_defn (mapM_def, mapM_ind) *)
val (mapM_rw, mapM_ind_rw) =
  Defn.tprove_no_defn ((mapM_def, mapM_ind),
    (* the termination proof *)
  )
val mapM_rw = save_thm ("mapM_rw", mapM_rw);
val mapM_ind_rw = save_thm ("mapM_ind_rw", mapM_ind_rw);


(* val gst = Defn.tgoal_no_defn (foldM_def, foldM_ind) *)
val (foldM_rw, foldM_ind_rw) =
  Defn.tprove_no_defn ((foldM_def, foldM_ind),
    (* the termination proof *)
  )
val foldM_rw = save_thm ("foldM_rw", foldM_rw);
val foldM_ind_rw = save_thm ("foldM_ind_rw", foldM_ind_rw);




val _ = export_theory()

