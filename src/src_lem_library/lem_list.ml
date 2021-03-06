(*Generated by Lem from list.lem.*)
 

open Lem_bool
open Lem_maybe
open Lem_basic_classes
open Lem_tuple
open Lem_num

(* ========================================================================== *)
(* Basic list functions                                                       *)
(* ========================================================================== *)

(* The type of lists as well as list literals like [], [1;2], ... are hardcoded. 
   Thus, we can directly dive into derived definitions. *)


(* ----------------------- *)
(* cons                    *)
(* ----------------------- *)

(*val :: : forall 'a. 'a -> list 'a -> list 'a*)


(* ----------------------- *)
(* Emptyness check         *)
(* ----------------------- *)

(*val null : forall 'a. list 'a -> bool*)
let list_null l = ((match l with [] -> true | _ -> false ))

(* ----------------------- *)
(* Length                  *)
(* ----------------------- *)

(*val length : forall 'a. list 'a -> nat*)
(*let rec length l =
  match l with
    | [] -> 0
    | x :: xs -> (Instance_Num_NumAdd_nat.+) (length xs) 1
  end*)

(* ----------------------- *)
(* Equality                *)
(* ----------------------- *)

(*val listEqual : forall 'a. Eq 'a => list 'a -> list 'a -> bool*)
(*val listEqualBy : forall 'a. ('a -> 'a -> bool) -> list 'a -> list 'a -> bool*)

let rec listEqualBy eq l1 l2 = ((match (l1,l2) with
  | ([], []) -> true
  | ([], (_::_)) -> false
  | ((_::_), []) -> false
  | (x::xs, y :: ys) -> (eq x y && listEqualBy eq xs ys)
))

let instance_Basic_classes_Eq_list_dict dict_Basic_classes_Eq_a =({

  isEqual_method = (listEqualBy  
  dict_Basic_classes_Eq_a.isEqual_method);

  isInequal_method = (fun l1 l2->not ((listEqualBy  
  dict_Basic_classes_Eq_a.isEqual_method l1 l2)))})


(* ----------------------- *)
(* compare                 *)
(* ----------------------- *)

(*val lexicographicCompare : forall 'a. Ord 'a => list 'a -> list 'a -> ordering*)
(*val lexicographicCompareBy : forall 'a. ('a -> 'a -> ordering) -> list 'a -> list 'a -> ordering*)

let rec lexicographic_compare cmp l1 l2 = ((match (l1,l2) with
  | ([], []) -> 0
  | ([], _::_) -> (-1)
  | (_::_, []) -> 1
  | (x::xs, y::ys) -> begin  
  Lem.ordering_cases (cmp x y) (-1) (lexicographic_compare cmp xs ys) 1
    end
))

(*val lexicographicLess : forall 'a. Ord 'a => list 'a -> list 'a -> bool*)
(*val lexicographicLessBy : forall 'a. ('a -> 'a -> bool) -> ('a -> 'a -> bool) -> list 'a -> list 'a -> bool*)
let rec lexicographic_less less less_eq l1 l2 = ((match (l1,l2) with
  | ([], []) -> false
  | ([], _::_) -> true
  | (_::_, []) -> false
  | (x::xs, y::ys) -> ((less x y) || ((less_eq x y) && (lexicographic_less less less_eq xs ys)))
))

(*val lexicographicLessEq : forall 'a. Ord 'a => list 'a -> list 'a -> bool*)
(*val lexicographicLessEqBy : forall 'a. ('a -> 'a -> bool) -> ('a -> 'a -> bool) -> list 'a -> list 'a -> bool*)
let rec lexicographic_less_eq less less_eq l1 l2 = ((match (l1,l2) with
  | ([], []) -> true
  | ([], _::_) -> true
  | (_::_, []) -> false
  | (x::xs, y::ys) -> (less x y || (less_eq x y && lexicographic_less_eq less less_eq xs ys))
))


let instance_Basic_classes_Ord_list_dict dict_Basic_classes_Ord_a =({

  compare_method = (lexicographic_compare  
  dict_Basic_classes_Ord_a.compare_method);

  isLess_method = (lexicographic_less  
  dict_Basic_classes_Ord_a.isLess_method  dict_Basic_classes_Ord_a.isLessEqual_method);

  isLessEqual_method = (lexicographic_less_eq  
  dict_Basic_classes_Ord_a.isLess_method  dict_Basic_classes_Ord_a.isLessEqual_method);

  isGreater_method = (fun x y->(lexicographic_less  
  dict_Basic_classes_Ord_a.isLess_method  dict_Basic_classes_Ord_a.isLessEqual_method y x));

  isGreaterEqual_method = (fun x y->(lexicographic_less_eq  
  dict_Basic_classes_Ord_a.isLess_method  dict_Basic_classes_Ord_a.isLessEqual_method y x))})


(* ----------------------- *)
(* Append                  *)
(* ----------------------- *)

(*val ++ : forall 'a. list 'a -> list 'a -> list 'a*) (* originally append *)
(*let rec ++ xs ys = match xs with
                     | [] -> ys
                     | x :: xs' -> x :: (xs' ++ ys)
                   end*)

(* ----------------------- *)
(* snoc                    *)
(* ----------------------- *)

(*val snoc : forall 'a. 'a -> list 'a -> list 'a*)
let snoc e l =  (List.append l [e])


(* ----------------------- *)
(* Map                     *)
(* ----------------------- *)

(*val map : forall 'a 'b. ('a -> 'b) -> list 'a -> list 'b*)
(*let rec map f l = match l with
  | [] -> []
  | x :: xs -> (f x) :: map f xs
end*)

(* ----------------------- *)
(* Reverse                 *)
(* ----------------------- *)

(* First lets define the function [reverse_append], which is
   closely related to reverse. [reverse_append l1 l2] appends the list [l2] to the reverse of [l1].
   This can be implemented more efficienctly than appending and is
   used to implement reverse. *)

(*val reverseAppend : forall 'a. list 'a -> list 'a -> list 'a*) (* originally named rev_append *)
(*let rec reverseAppend l1 l2 = match l1 with 
                                | [] -> l2
                                | x :: xs -> reverseAppend xs (x :: l2)
                               end*)

(* Reversing a list *)
(*val reverse : forall 'a. list 'a -> list 'a*) (* originally named rev *)
(*let reverse l = reverseAppend l []*)


(* ----------------------- *)
(* Reverse Map             *)
(* ----------------------- *)

(*val reverseMap : forall 'a 'b. ('a -> 'b) -> list 'a -> list 'b*)



(* ========================================================================== *)
(* Folding                                                                    *)
(* ========================================================================== *)

(* ----------------------- *)
(* fold left               *)
(* ----------------------- *)

(*val foldl : forall 'a 'b. ('a -> 'b -> 'a) -> 'a -> list 'b -> 'a*) (* originally foldl *)

(*let rec foldl f b l = match l with
  | []      -> b
  | x :: xs -> foldl f (f b x) xs
end*)


(* ----------------------- *)
(* fold right              *)
(* ----------------------- *)

(*val foldr : forall 'a 'b. ('a -> 'b -> 'b) -> 'b -> list 'a -> 'b*) (* originally foldr with different argument order *)
(*let rec foldr f b l = match l with
  | []      -> b
  | x :: xs -> f x (foldr f b xs)
end*)


(* ----------------------- *)
(* concatenating lists     *)
(* ----------------------- *)

(*val concat : forall 'a. list (list 'a) -> list 'a*) (* before also called "flatten" *)
(*let concat = foldr (++) []*)


(* -------------------------- *)
(* concatenating with mapping *)
(* -------------------------- *)

(*val concatMap : forall 'a 'b. ('a -> list 'b) -> list 'a -> list 'b*)


(* ------------------------- *)
(* universal qualification   *)
(* ------------------------- *)

(*val all : forall 'a. ('a -> bool) -> list 'a -> bool*) (* originally for_all *)
(*let all P l = foldl (fun r e -> P e && r) true l*)



(* ------------------------- *)
(* existential qualification *)
(* ------------------------- *)

(*val any : forall 'a. ('a -> bool) -> list 'a -> bool*) (* originally exist *)
(*let any P l = foldl (fun r e -> P e || r) false l*)


(* ------------------------- *)
(* dest_init                 *)
(* ------------------------- *)

(* get the initial part and the last element of the list in a safe way *)

(*val dest_init : forall 'a. list 'a -> maybe (list 'a * 'a)*) 

let rec dest_init_aux rev_init last_elem_seen to_process =  
((match to_process with
    | []    -> (List.rev rev_init, last_elem_seen)
    | x::xs -> dest_init_aux (last_elem_seen::rev_init) x xs
  ))

let dest_init l = ((match l with
  | [] -> None
  | x::xs -> Some (dest_init_aux [] x xs)
))


(* ========================================================================== *)
(* Indexing lists                                                             *)
(* ========================================================================== *)

(* ------------------------- *)
(* index / nth with maybe   *)
(* ------------------------- *)

(*val index : forall 'a. list 'a -> nat -> maybe 'a*)

let rec list_index l n = ((match l with 
  | []      -> None
  | x :: xs -> if n = 0 then Some x else list_index xs (Nat_num.nat_monus n( 1))
))

(* ------------------------- *)
(* findIndices               *)
(* ------------------------- *)

(* [findIndices P l] returns the indices of all elements of list [l] that satisfy predicate [P]. 
   Counting starts with 0, the result list is sorted ascendingly *)
(*val findIndices : forall 'a. ('a -> bool) -> list 'a -> list nat*)

let rec find_indices_aux (i:int) p0 l =  
((match l with
    | []      -> []
    | x :: xs -> if p0 x then i :: find_indices_aux (i + 1) p0 xs else find_indices_aux (i + 1) p0 xs
 ))
let find_indices p0 l = (find_indices_aux( 0) p0 l)



(* ------------------------- *)
(* findIndex                 *)
(* ------------------------- *)

(* findIndex returns the first index of a list that satisfies a given predicate. *)
(*val findIndex : forall 'a. ('a -> bool) -> list 'a -> maybe nat*)
let find_index p0 l = ((match find_indices p0 l with
  | [] -> None
  | x :: _ -> Some x
))

(* ------------------------- *)
(* elemIndices               *)
(* ------------------------- *)

(*val elemIndices : forall 'a. Eq 'a => 'a -> list 'a -> list nat*)

(* ------------------------- *)
(* elemIndex                 *)
(* ------------------------- *)

(*val elemIndex : forall 'a. Eq 'a => 'a -> list 'a -> maybe nat*)


(* ========================================================================== *)
(* Creating lists                                                             *)
(* ========================================================================== *)

(* ------------------------- *)
(* genlist                   *)
(* ------------------------- *)

(* [genlist f n] generates the list [f 0; f 1; ... (f (n-1))] *)
(*val genlist : forall 'a. (nat -> 'a) -> nat -> list 'a*)


let rec genlist f n = 
  (
  if(n =  0) then ([]) else
    (let n'0 =(Nat_num.nat_monus n ( 1)) in snoc (f n'0) (genlist f n'0)))


(* ------------------------- *)
(* replicate                 *)
(* ------------------------- *)

(*val replicate : forall 'a. nat -> 'a -> list 'a*)
let rec replicate n x = 
  (
  if(n =  0) then ([]) else
    (let n'0 =(Nat_num.nat_monus n ( 1)) in x :: replicate n'0 x))


(* ========================================================================== *)
(* Sublists                                                                   *)
(* ========================================================================== *)

(* ------------------------- *)
(* splitAt                   *)
(* ------------------------- *)

(* [splitAt n xs] returns a tuple (xs1, xs2), with "append xs1 xs2 = xs" and 
   "length xs1 = n". If there are not enough elements 
   in [xs], the original list and the empty one are returned. *)
(*val splitAt : forall 'a. nat -> list 'a -> (list 'a * list 'a)*)
let rec split_at n l =  
 ((match l with
    | []    -> ([], [])
    | x::xs -> 
       if n <= 0 then ([], l) else
       begin
         let (l1, l2) = (split_at (Nat_num.nat_monus n( 1)) xs) in
         ((x::l1), l2)
       end    
  ))


(* ------------------------- *)
(* take                      *)
(* ------------------------- *)

(* take n xs returns the prefix of xs of length n, or xs itself if n > length xs *)
(*val take : forall 'a. nat -> list 'a -> list 'a*)
let take n l = (fst (split_at n l))



(* ------------------------- *)
(* drop                      *)
(* ------------------------- *)

(* [drop n xs] drops the first [n] elements of [xs]. It returns the empty list, if [n] > [length xs]. *)
(*val drop : forall 'a. nat -> list 'a -> list 'a*)
let drop n l = (snd (split_at n l))

(* ------------------------- *)
(* dropWhile                 *)
(* ------------------------- *)

(* [dropWhile p xs] drops the first elements of [xs] that satisfy [p]. *)
(*val dropWhile : forall 'a. ('a -> bool) -> list 'a -> list 'a*)
let rec dropWhile p l = ((match l with 
  | [] -> []
  | x::xs -> if p x then dropWhile p xs else l
))


(* ------------------------- *)
(* takeWhile                 *)
(* ------------------------- *)

(* [takeWhile p xs] takes the first elements of [xs] that satisfy [p]. *)
(*val takeWhile : forall 'a. ('a -> bool) -> list 'a -> list 'a*)
let rec takeWhile p l = ((match l with 
  | [] -> []
  | x::xs -> if p x then x::takeWhile p xs else []
))


(* ------------------------- *)
(* isPrefixOf                *)
(* ------------------------- *)

(*val isPrefixOf : forall 'a. Eq 'a => list 'a -> list 'a -> bool*)
let rec isPrefixOf dict_Basic_classes_Eq_a l1 l2 = ((match (l1, l2) with
  | ([], _) -> true
  | (_::_, []) -> false
  | (x::xs, y::ys) -> ( 
  dict_Basic_classes_Eq_a.isEqual_method x y) && isPrefixOf dict_Basic_classes_Eq_a xs ys
))

(* ------------------------- *)
(* update                    *)
(* ------------------------- *)
(*val update : forall 'a. list 'a -> nat -> 'a -> list 'a*)
let rec list_update l n e =  
 ((match l with
    | []      -> []
    | x :: xs -> if n = 0 then e :: xs else x :: (list_update xs ( Nat_num.nat_monus n( 1)) e)
))



(* ========================================================================== *)
(* Searching lists                                                            *)
(* ========================================================================== *)

(* ------------------------- *)
(* Membership test           *)
(* ------------------------- *)

(* The membership test, one of the basic list functions, is actually tricky for
   Lem, because it is tricky, which equality to use. From Lem`s point of 
   perspective, we want to use the equality provided by the equality type - class.
   This allows for example to check whether a set is in a list of sets.

   However, in order to use the equality type class, elem essentially becomes
   existential quantification over lists. For types, which implement semantic
   equality (=) with syntactic equality, this is overly complicated. In
   our theorem prover backend, we would end up with overly complicated, harder
   to read definitions and some of the automation would be harder to apply.
   Moreover, nearly all the old Lem generated code would change and require 
   (hopefully minor) adaptions of proofs.

   For now, we ignore this problem and just demand, that all instances of
   the equality type class do the right thing for the theorem prover backends.   
*)

(*val elem : forall 'a. Eq 'a => 'a -> list 'a -> bool*)
(*val elemBy : forall 'a. ('a -> 'a -> bool) -> 'a -> list 'a -> bool*)

let elemBy eq e l = (List.exists (eq e) l)
(*let elem = elemBy  dict_Basic_classes_Eq_a.isEqual_method*)

(* ------------------------- *)
(* Find                      *)
(* ------------------------- *)
(*val find : forall 'a. ('a -> bool) -> list 'a -> maybe 'a*) (* previously not of maybe type *)
let rec list_find_opt p0 l = ((match l with 
  | []      -> None
  | x :: xs -> if p0 x then Some x else list_find_opt p0 xs
))


(* ----------------------------- *)
(* Lookup in an associative list *)
(* ----------------------------- *)
(*val lookup   : forall 'a 'b. Eq 'a              => 'a -> list ('a * 'b) -> maybe 'b*)
(*val lookupBy : forall 'a 'b. ('a -> 'a -> bool) -> 'a -> list ('a * 'b) -> maybe 'b*)

(* DPM: eta-expansion for Coq backend type-inference. *)
let lookupBy eq k m = (Lem.option_map (fun x -> snd x) (list_find_opt (fun (k', _) -> eq k k') m))

(* ------------------------- *)
(* filter                    *)
(* ------------------------- *)
(*val filter : forall 'a. ('a -> bool) -> list 'a -> list 'a*)
(*let rec filter P l = match l with
                       | [] -> []
                       | x :: xs -> if (P x) then x :: (filter P xs) else filter P xs
                     end*)


(* ------------------------- *)
(* partition                 *)
(* ------------------------- *)
(*val partition : forall 'a. ('a -> bool) -> list 'a -> list 'a * list 'a*)
(*let partition P l = (filter P l, filter (fun x -> not (P x)) l)*)

(*val reversePartition : forall 'a. ('a -> bool) -> list 'a -> list 'a * list 'a*)
let reversePartition p0 l = (List.partition p0 (List.rev l))


(* ------------------------- *)
(* delete first element      *)
(* with certain property     *)
(* ------------------------- *)

(*val deleteFirst : forall 'a. ('a -> bool) -> list 'a -> maybe (list 'a)*) 
let rec list_delete_first p0 l = ((match l with
                            | [] -> None
                            | x :: xs -> if (p0 x) then Some xs else Lem.option_map (fun xs' -> x :: xs') (list_delete_first p0 xs)
                          ))


(*val delete : forall 'a. Eq 'a => 'a -> list 'a -> list 'a*)
(*val deleteBy : forall 'a. ('a -> 'a -> bool) -> 'a -> list 'a -> list 'a*)

let list_delete eq x l = (Lem.option_default l (list_delete_first (eq x) l))


(* ========================================================================== *)
(* Zipping and unzipping lists                                                *)
(* ========================================================================== *)

(* ------------------------- *)
(* zip                       *)
(* ------------------------- *)

(* zip takes two lists and returns a list of corresponding pairs. If one input list is short, excess elements of the longer list are discarded. *)
(*val zip : forall 'a 'b. list 'a -> list 'b -> list ('a * 'b)*) (* before combine *)
let rec list_combine l1 l2 = ((match (l1, l2) with
  | (x :: xs, y :: ys) -> (x, y) :: list_combine xs ys
  | _ -> []
))

(* ------------------------- *)
(* unzip                     *)
(* ------------------------- *)

(*val unzip: forall 'a 'b. list ('a * 'b) -> (list 'a * list 'b)*)
(*let rec unzip l = match l with
  | [] -> ([], [])
  | (x, y) :: xys -> let (xs, ys) = unzip xys in (x :: xs, y :: ys)
end*)


let instance_Basic_classes_SetType_list_dict dict_Basic_classes_SetType_a =({

  setElemCompare_method = (lexicographic_compare  
  dict_Basic_classes_SetType_a.setElemCompare_method)})

(* ------------------------- *)
(* distinct elements         *)
(* ------------------------- *)

(*val allDistinct : forall 'a. Eq 'a => list 'a -> bool*)
let rec allDistinct dict_Basic_classes_Eq_a l =  
 ((match l with
    | [] -> true
    | (x::l') -> not (List.mem x l') && allDistinct 
  dict_Basic_classes_Eq_a l'
  ))

(* some more useful functions *)
(*val mapMaybe : forall 'a 'b. ('a -> maybe 'b) -> list 'a -> list 'b*)
let rec mapMaybe f xs =  
((match xs with
  | [] -> []
  | x::xs ->
      (match f x with
      | None -> mapMaybe f xs
      | Some y -> y :: (mapMaybe f xs)
      )
  ))

(*val mapi : forall 'a 'b. (nat -> 'a -> 'b) -> list 'a -> list 'b*)
let rec mapiAux f (n : int) l = ((match l with
  | [] -> []
  | x :: xs -> (f n x) :: mapiAux f (n + 1) xs
))
let mapi f l = (mapiAux f( 0) l)

(* ========================================================================== *)
(* Comments (not clean yet, please ignore the rest of the file)               *)
(* ========================================================================== *)

(* ----------------------- *)
(* skipped from Haskell Lib*)
(* ----------------------- 

intersperse :: a -> [a] -> [a]
intercalate :: [a] -> [[a]] -> [a]
transpose :: [[a]] -> [[a]]
subsequences :: [a] -> [[a]]
permutations :: [a] -> [[a]]
foldl` :: (a -> b -> a) -> a -> [b] -> aSource
foldl1` :: (a -> a -> a) -> [a] -> aSource

and
or
sum
product
maximum
minimum
scanl
scanr
scanl1
scanr1
Accumulating maps

mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])Source
mapAccumR :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])Source

iterate :: (a -> a) -> a -> [a]
repeat :: a -> [a]
cycle :: [a] -> [a]
unfoldr


takeWhile :: (a -> Bool) -> [a] -> [a]Source
dropWhile :: (a -> Bool) -> [a] -> [a]Source
dropWhileEnd :: (a -> Bool) -> [a] -> [a]Source
span :: (a -> Bool) -> [a] -> ([a], [a])Source
break :: (a -> Bool) -> [a] -> ([a], [a])Source
break p is equivalent to span (not . p).
stripPrefix :: Eq a => [a] -> [a] -> Maybe [a]Source
group :: Eq a => [a] -> [[a]]Source
inits :: [a] -> [[a]]Source
tails :: [a] -> [[a]]Source


isPrefixOf :: Eq a => [a] -> [a] -> BoolSource
isSuffixOf :: Eq a => [a] -> [a] -> BoolSource
isInfixOf :: Eq a => [a] -> [a] -> BoolSource



notElem :: Eq a => a -> [a] -> BoolSource

zip3 :: [a] -> [b] -> [c] -> [(a, b, c)]Source
zip4 :: [a] -> [b] -> [c] -> [d] -> [(a, b, c, d)]Source
zip5 :: [a] -> [b] -> [c] -> [d] -> [e] -> [(a, b, c, d, e)]Source
zip6 :: [a] -> [b] -> [c] -> [d] -> [e] -> [f] -> [(a, b, c, d, e, f)]Source
zip7 :: [a] -> [b] -> [c] -> [d] -> [e] -> [f] -> [g] -> [(a, b, c, d, e, f, g)]Source

zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]Source
zipWith3 :: (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]Source
zipWith4 :: (a -> b -> c -> d -> e) -> [a] -> [b] -> [c] -> [d] -> [e]Source
zipWith5 :: (a -> b -> c -> d -> e -> f) -> [a] -> [b] -> [c] -> [d] -> [e] -> [f]Source
zipWith6 :: (a -> b -> c -> d -> e -> f -> g) -> [a] -> [b] -> [c] -> [d] -> [e] -> [f] -> [g]Source
zipWith7 :: (a -> b -> c -> d -> e -> f -> g -> h) -> [a] -> [b] -> [c] -> [d] -> [e] -> [f] -> [g] -> [h]Source


unzip3 :: [(a, b, c)] -> ([a], [b], [c])Source
unzip4 :: [(a, b, c, d)] -> ([a], [b], [c], [d])Source
unzip5 :: [(a, b, c, d, e)] -> ([a], [b], [c], [d], [e])Source
unzip6 :: [(a, b, c, d, e, f)] -> ([a], [b], [c], [d], [e], [f])Source
unzip7 :: [(a, b, c, d, e, f, g)] -> ([a], [b], [c], [d], [e], [f], [g])Source


lines :: String -> [String]Source
words :: String -> [String]Source
unlines :: [String] -> StringSource
unwords :: [String] -> StringSource
nub :: Eq a => [a] -> [a]Source
delete :: Eq a => a -> [a] -> [a]Source

(\\) :: Eq a => [a] -> [a] -> [a]Source
union :: Eq a => [a] -> [a] -> [a]Source
intersect :: Eq a => [a] -> [a] -> [a]Source
sort :: Ord a => [a] -> [a]Source
insert :: Ord a => a -> [a] -> [a]Source


nubBy :: (a -> a -> Bool) -> [a] -> [a]Source
deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]Source
deleteFirstsBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]Source
unionBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]Source
intersectBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]Source
groupBy :: (a -> a -> Bool) -> [a] -> [[a]]Source
sortBy :: (a -> a -> Ordering) -> [a] -> [a]Source
insertBy :: (a -> a -> Ordering) -> a -> [a] -> [a]Source
maximumBy :: (a -> a -> Ordering) -> [a] -> aSource
minimumBy :: (a -> a -> Ordering) -> [a] -> aSource
genericLength :: Num i => [b] -> iSource
genericTake :: Integral i => i -> [a] -> [a]Source
genericDrop :: Integral i => i -> [a] -> [a]Source
genericSplitAt :: Integral i => i -> [b] -> ([b], [b])Source
genericIndex :: Integral a => [b] -> a -> bSource
genericReplicate :: Integral i => i -> a -> [a]Source


*)


(* ----------------------- *)
(* skipped from Lem Lib    *)
(* ----------------------- 


val for_all2 : forall 'a 'b. ('a -> 'b -> bool) -> list 'a -> list 'b -> bool
val exists2 : forall 'a 'b. ('a -> 'b -> bool) -> list 'a -> list 'b -> bool
val map2 : forall 'a 'b 'c. ('a -> 'b -> 'c) -> list 'a -> list 'b -> list 'c 
val rev_map2 : forall 'a 'b 'c. ('a -> 'b -> 'c) -> list 'a -> list 'b -> list 'c
val fold_left2 : forall 'a 'b 'c. ('a -> 'b -> 'c -> 'a) -> 'a -> list 'b -> list 'c -> 'a
val fold_right2 : forall 'a 'b 'c. ('a -> 'b -> 'c -> 'c) -> list 'a -> list 'b -> 'c -> 'c


(* now maybe result and called lookup *)
val assoc : forall 'a 'b. 'a -> list ('a * 'b) -> 'b
let inline {ocaml} assoc = Ocaml.List.assoc


val mem_assoc : forall 'a 'b. 'a -> list ('a * 'b) -> bool
val remove_assoc : forall 'a 'b. 'a -> list ('a * 'b) -> list ('a * 'b)



val stable_sort : forall 'a. ('a -> 'a -> num) -> list 'a -> list 'a
val fast_sort : forall 'a. ('a -> 'a -> num) -> list 'a -> list 'a

val merge : forall 'a. ('a -> 'a -> num) -> list 'a -> list 'a -> list 'a
val intersect : forall 'a. list 'a -> list 'a -> list 'a


*)
