(* Typing context *)

(* A de Bruijn index is bound to a type and an atom. *)
type entry = TT.atom * TT.ty

type definition = TT.atom * TT.expr

type context =
  {
    idents : entry list ;
    defs : definition list
  }

let initial = { idents = [] ; defs = [] }

(** The list of names which should not be used for printing bound variables. *)
let penv {idents} = List.map (fun ((x, _), _) -> x) idents

(** Extend the context with an identifier. *)
let extend_ident a t ctx = { ctx with idents = (a, t) :: ctx.idents }

(** Extend the context with a definitional equality. *)
let extend_def a e ctx = { ctx with defs = (a, e) :: ctx.defs }

(** Lookup the type and value of a de Bruijn index *)
let lookup k {idents; _} =
  let rec search m = function
    | [] -> None
    | et :: lst -> if m = 0 then Some et else search (m - 1) lst
  in
  search k idents

let lookup_atom_ty a {idents; _} =
  try
    Some (List.assoc a idents)
  with
    Not_found -> None

(** Lookup a definition. *)
let lookup_def x {defs; _} =
  try
    let e = List.assoc x defs in
    Some e
  with Not_found -> None
