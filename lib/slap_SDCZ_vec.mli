(* Sized Linear Algebra Package (SLAP)

   Copyright (C) 2013- Akinori ABE <abe@kb.ecei.tohoku.ac.jp>

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*)

module type CNTVEC =
  sig
    type n
    (** A generative phantom type. *)

    val value : (n, 'cnt) vec
    (** A dynamically-sized contiguous vector with type like
        [exists n. (n, 'cnt) vec]. *)
  end
(** The signature of modules containing dynamically-sized contiguous vectors. *)

module type DSCVEC =
  sig
    type n
    (** A generative phantom type. *)

    val value : (n, dsc) vec
    (** A dynamically-sized discrete vector with type like
        [exists n. (n, dsc) vec]. *)
  end
(** The signature of modules containing dynamically-sized discrete vectors. *)

(** {2 Creation of vectors} *)

val empty : (Size.z, 'cnt) vec
(** An empty vector. *)

val create : 'n Size.t -> ('n, 'cnt) vec
(** [create n]
    @return a fresh [n]-dimensional vector (not initialized).
 *)

val make : 'n Size.t -> num_type -> ('n, 'cnt) vec
(** [make n a]
    @return a fresh [n]-dimensional vector initialized with [a].
 *)

val make0 : 'n Size.t -> ('n, 'cnt) vec
(** [zeros n]
    @return a fresh [n]-dimensional vector initialized with [0].
 *)

val make1 : 'n Size.t -> ('n, 'cnt) vec
(** [make1 n]
    @return a fresh [n]-dimensional vector initialized with [1].
 *)

val init : 'n Size.t ->
           (int -> num_type) -> ('n, 'cnt) vec
(** [init n f]
    @return a fresh vector [(f 1, ..., f n)] with [n] elements.
 *)

(** {2 Accessors} *)

val dim : ('n, 'cd) vec -> 'n Size.t
(** [dim x]
    @return the dimension of the vector [x].
 *)

val get_dyn : ('n, 'cd) vec -> int -> num_type
(** [get_dyn x i]
    @return the [i]-th element of the vector [x].
 *)

val set_dyn : ('n, 'cd) vec -> int -> num_type -> unit
(** [set_dyn x i a] assigns [a] to the [i]-th element of the vector [x].
 *)

val unsafe_get : ('n, 'cd) vec -> int -> num_type
(** Like {!Slap.Vec.get_dyn}, but size checking is not always performed. *)

val unsafe_set : ('n, 'cd) vec -> int -> num_type -> unit
(** Like {!Slap.Vec.set_dyn}, but size checking is not always performed. *)

val replace_dyn : ('n, 'cd) vec ->
                  int ->
                  (num_type -> num_type) -> unit
(** [replace_dyn v i f] is [set_dyn v i (f (get_dyn v i))]. *)

(** {2 Basic operations} *)

val copy : ?y:('n, 'y_cd) vec -> ('n, 'x_cd) vec -> ('n, 'y_cd) vec
(** [copy ?y x] copies the vector [x] to the vector [y] with the BLAS-1
    function [[sdcz]copy].
    @return the vector [y], which is overwritten.
    @param y default = a fresh vector.
 *)

val fill : ('n, 'cd) vec -> num_type -> unit
(** Fill the given vector with the given value. *)

val append : ('m, 'x_cd) vec -> ('n, 'y_cd) vec ->
             (('m, 'n) Size.add, 'cnt) vec
(** Concatenate two vectors. *)

(** {2 Type conversion} *)

val to_array : ('n, 'cd) vec -> num_type array
(** [to_array x]
    @return the array of all the elements of the vector [x].
 *)

val of_array_dyn : 'n Size.t ->
                   num_type array -> ('n, 'cnt) vec
(** [of_array_dyn n [|a1; ...; an|]]
    @raise Invalid_argument the length of the given array is not equal to [n].
    @return a fresh vector [(a1, ..., an)].
 *)

val of_array : num_type array -> (module CNTVEC)
(** [module V = (val of_array [|a1; ...; an|] : CNTVEC)]
    @return module [V] containing the vector [V.value] (= [(a1, ..., an)]) that
    has the type [(V.n, 'cnt) vec] with a generative phantom type [V.n] as a
    package of an existential quantified sized type like
    [exists n. (n, 'cnt) vec].
 *)

module Of_array (X : sig val value : num_type array end) : CNTVEC
(** A functor version of [of_array]. *)

val to_list : ('n, 'cd) vec -> num_type list
(** [to_list x]
    @return the list of all the elements of the vector [x].
 *)

val of_list_dyn : 'n Size.t ->
                  num_type list -> ('n, 'cnt) vec
(** [of_list_dyn n [a1; ...; an]]
    @raise Invalid_argument the length of the given list is not equal to [n].
    @return a fresh vector [(a1, ..., an)].
 *)

val of_list : num_type list -> (module CNTVEC)
(** [module V = (val of_list [a1; ...; an] : CNTVEC)]
    @return module [V] containing the vector [V.value] (= [(a1, ..., an)]) that
    has the type [(V.n, 'cnt) vec] with a generative phantom type [V.n] as a
    package of an existential quantified sized type like
    [exists n. (n, 'cnt) vec].
 *)

module Of_list (X : sig val value : num_type list end) : CNTVEC
(** A functor version of [of_list]. *)

(** {2 Iterators} *)

val map : (num_type -> num_type) ->
          ?y:('n, 'y_cd) vec ->
          ('n, 'x_cd) vec -> ('n, 'y_cd) vec
(** [map f ?y (x1, ..., xn)] is [(f x1, ..., f xn)].
   @return the vector [y], which is overwritten.
   @param y default = a fresh vector.
 *)

val mapi : (int -> num_type -> num_type) ->
           ?y:('n, 'y_cd) vec ->
           ('n, 'x_cd) vec ->
           ('n, 'y_cd) vec
(** [mapi f ?y (x1, ..., xn)] is [(f 1 x1, ..., f n xn)] with
   the vector's dimension [n].
   @return the vector [y], which is overwritten.
   @param y default = a fresh vector.
 *)

val fold_left : ('accum -> num_type -> 'accum) ->
                'accum ->
                ('n, 'cd) vec -> 'accum
(** [fold_left f init (x1, x2, ..., xn)] is
   [f (... (f (f init x1) x2) ...) xn].
 *)

val fold_lefti : (int -> 'accum -> num_type -> 'accum) ->
                 'accum ->
                 ('n, 'cd) vec -> 'accum
(** [fold_lefti f init (x1, x2, ..., xn)] is
   [f n (... (f 2 (f 1 init x1) x2) ...) xn] with the vector's dimension [n].
 *)

val fold_right : (num_type -> 'accum -> 'accum) ->
                 ('n, 'cd) vec ->
                 'accum -> 'accum
(** [fold_right f (x1, x2, ..., xn) init] is
   [f x1 (f x2 (... (f xn init) ...))].
 *)

val fold_righti : (int -> num_type -> 'accum -> 'accum) ->
                  ('n, 'cd) vec ->
                  'accum -> 'accum
(** [fold_righti f (x1, x2, ..., xn) init] is
   [f 1 x1 (f 2 x2 (... (f n xn init) ...))] with the vector's dimension [n].
 *)

val replace_all : ('n, 'cd) vec ->
                  (num_type -> num_type) -> unit
(** [replace_all x f] modifies the vector [x] in place
   -- the [i]-th element [xi] of [x] will be set to [f xi].
 *)

val replace_alli : ('n, 'cd) vec ->
                   (int -> num_type -> num_type) -> unit
(** [replace_alli x f] modifies the vector [x] in place
   -- the [i]-th element [xi] of [x] will be set to [f i xi].
 *)

val iter : (num_type -> unit) ->
           ('n, 'cd) vec -> unit
(** [iter f (x1, x2, ..., xn)] is [f x1; f x2; ...; f xn].
 *)

val iteri : (int -> num_type -> unit) ->
            ('n, 'cd) vec -> unit
(** [iteri f (x1, x2, ..., xn)] is [f 1 x1; f 2 x2; ...; f n xn].
 *)

(** {2 Arithmetic operations} *)

val max : ('n, 'cd) vec -> num_type

val min : ('n, 'cd) vec -> num_type

val sum : ('n, 'cd) vec -> num_type

val prod : ('n, 'cd) vec -> num_type

val sqr_nrm2 : ?stable:bool -> ('n, 'cd) vec -> float

val ssqr : ?c:num_type -> ('n, 'cd) vec -> num_type

val sort : ?cmp:(num_type -> num_type -> int) ->
           ?decr:bool ->
           ?p:('n, 'p_cd) Common.int_vec ->
           ('n, 'x_cd) vec -> unit

val neg : ?y:('n, 'y_cd) vec -> ('n, 'x_cd) vec -> ('n, 'y_cd) vec

val add : ?z:('n, 'z_cd) vec -> ('n, 'x_cd) vec ->
          ('n, 'y_cd) vec -> ('n, 'z_cd) vec

val sub : ?z:('n, 'z_cd) vec -> ('n, 'x_cd) vec ->
          ('n, 'y_cd) vec -> ('n, 'z_cd) vec

val mul : ?z:('n, 'z_cd) vec -> ('n, 'x_cd) vec ->
          ('n, 'y_cd) vec -> ('n, 'z_cd) vec

val div : ?z:('n, 'z_cd) vec -> ('n, 'x_cd) vec ->
          ('n, 'y_cd) vec -> ('n, 'z_cd) vec

val ssqr_diff : ('n, 'x_cd) vec -> ('n, 'y_cd) vec -> num_type
