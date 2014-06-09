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

val pp_num : Format.formatter -> num_type -> unit
(** A pretty-printer for elements in vectors and matrices. *)

val pp_vec : Format.formatter -> ('n, cnt) vec -> unit
(** A pretty-printer for column vectors. *)

val pp_mat : Format.formatter -> ('m, 'n, cnt) mat -> unit
(** A pretty-printer for matrices. *)

(** {2 BLAS interface} *)

(** {3 Level 1} *)

val swap : x:('n, 'x_cd) vec -> ('n, 'y_cd) vec -> unit

val scal : num_type -> ('n, 'cd) vec -> unit

val copy : ?y:('n, 'y_cd) vec -> ('n, 'x_cd) vec -> ('n, 'y_cd) vec

val nrm2 : ('n, 'cd) vec -> float

val axpy : ?alpha:num_type -> x:('n, 'x_cd) vec -> ('n, 'y_cd) vec -> unit

val iamax : ('n, 'cd) vec -> int

val amax : ('n, 'cd) vec -> num_type

(** {3 Level 2} *)

val gemv : ?beta:num_type ->
           ?y:('m, 'y_cd) vec ->
           trans:(('a_m, 'a_n, 'a_cd) mat -> ('m, 'n, 'a_cd) mat) trans3 ->
           ?alpha:num_type ->
           ('a_m, 'a_n, 'a_cd) mat ->
           ('n, 'x_cd) vec -> ('m, 'y_cd) vec

val symv : ?beta:num_type ->
           ?y:('n, 'y_cd) vec ->
           ?up:bool ->
           ?alpha:num_type ->
           ('n, 'n, 'a_cd) mat ->
           ('n, 'x_cd) vec -> ('n, 'y_cd) vec

val trmv : trans:(('n, 'n, 'a_cd) mat -> ('n, 'n, 'a_cd) mat) trans3 ->
           ?diag:Common.diag ->
           ?up:bool ->
           ('n, 'n, 'a_cd) mat ->
           ('n, 'x_cd) vec -> unit

val trsv : trans:(('n, 'n, 'a_cd) mat -> ('n, 'n, 'a_cd) mat) trans3 ->
           ?diag:Common.diag ->
           ?up:bool ->
           ('n, 'n, 'a_cd) mat ->
           ('n, 'x_cd) vec -> unit

(** {3 Level 3} *)

val gemm : ?beta:num_type ->
           ?c:('m, 'n, 'c_cd) mat ->
           transa:(('a_m, 'a_k, 'a_cd) mat -> ('m, 'k, 'a_cd) mat) trans3 ->
           ?alpha:num_type ->
           ('a_m, 'a_k, 'a_cd) mat ->
           transb:(('b_k, 'b_n, 'b_cd) mat -> ('k, 'n, 'b_cd) mat) trans3 ->
           ('b_k, 'b_n, 'b_cd) mat -> ('m, 'n, 'c_cd) mat

val symm : side:('k, 'm, 'n) Common.side ->
           ?up:bool ->
           ?beta:num_type ->
           ?c:('m, 'n, 'c_cd) mat ->
           ?alpha:num_type ->
           ('k, 'k, 'a_cd) mat ->
           ('m, 'n, 'b_cd) mat -> ('m, 'n, 'c_cd) mat

val trmm : side:('k, 'm, 'n) Common.side ->
           ?up:bool ->
           transa:(('k, 'k, 'a_cd) mat -> ('k, 'k, 'a_cd) mat) trans3 ->
           ?diag:Common.diag ->
           ?alpha:num_type ->
           a:('k, 'k, 'a_cd) mat ->
           ('m, 'n, 'b_cd) mat -> unit

val trsm : side:('k, 'm, 'n) Common.side ->
           ?up:bool ->
           transa:(('k, 'k, 'a_cd) mat -> ('k, 'k, 'a_cd) mat) trans3 ->
           ?diag:Common.diag ->
           ?alpha:num_type ->
           a:('k, 'k, 'a_cd) mat ->
           ('m, 'n, 'b_cd) mat -> unit

val syrk : ?up:bool ->
           ?beta:num_type ->
           ?c:('n, 'n, 'c_cd) mat ->
           trans:(('a_n, 'a_k, 'a_cd) mat ->
                  ('n, 'k, 'a_cd) mat) Common.trans2 ->
           ?alpha:num_type ->
           ('a_n, 'a_k, 'a_cd) mat -> ('n, 'n, 'c_cd) mat

val syr2k : ?up:bool ->
            ?beta:num_type ->
            ?c:('n, 'n, 'c_cd) mat ->
            trans:(('n, 'k, _) mat ->
                   ('p, 'q, _) mat) Common.trans2 ->
            ?alpha:num_type ->
            ('p, 'q, 'a_cd) mat ->
            ('p, 'q, 'b_cd) mat ->
            ('n, 'n, 'c_cd) mat
(** [syr2k ?up ?beta ?c ~trans ?alpha a b] computes

    - [c := alpha * a * b^T + alpha * b * a^T + beta * c] if [trans] is
      {!Slap.Common.normal}, or
    - [c := alpha * a^T * b + alpha * b^T * a + beta * c] if [trans] is
      {!Slap.Common.trans}

    with symmetric matrix [c], general matrices [a] and [b].
 *)

(** {2 LAPACK interface} *)

(** {3 Auxiliary routines} *)

val lacpy : ?uplo:[ `L | `U ] ->
            ?b:('m, 'n, 'b_cd) mat ->
            ('m, 'n, 'a_cd) mat -> ('m, 'n, 'b_cd) mat
(** [lacpy ?uplo ?b a] copies the matrix [a] into the matrix [b].
    - If [uplo] is omitted, all elements in [a] is copied.
    - If [uplo] is [`U], the upper trapezoidal part of [a] is copied.
    - If [uplo] is [`L], the lower trapezoidal part of [a] is copied.
    @return [b], which is overwritten.
    @param uplo default = all elements in [a] is copied.
    @param b    default = a fresh matrix.
 *)

val lassq : ?scale:float ->
            ?sumsq:float ->
            ('n, 'cd) vec ->
            float * float
(** [lassq ?scale ?sumsq x] see LAPACK documentation.
    @return [(scl, ssq)]
    @param scale default = 0.
    @param sumsq default = 1.
 *)

type larnv_liseed = Size.z Size.s Size.s Size.s Size.s

val larnv : ?idist:[ `Normal | `Uniform0 | `Uniform1 ] ->
            ?iseed:(larnv_liseed, cnt) Common.int32_vec ->
            x:('n, cnt) vec ->
            unit ->
            ('n, 'cnt) vec

type ('m, 'a) lange_min_lwork

val lange_min_lwork : 'm Size.t ->
                      'a Common.norm4 ->
                      ('m, 'a) lange_min_lwork Size.t

val lange : ?norm:'a Common.norm4 ->
            ?work:('lwork, cnt) rvec ->
            ('m, 'n, 'cd) mat -> float
(** [lange ?norm ?work a]
    @return the norm of matrix [a].
    @param norm default = {!Slap.Common.norm_1}.
    @param work default = allocated work space for norm {!Slap.Common.norm_inf}.
 *)

val lauum : ?up:bool -> ('n, 'n, 'cd) mat -> unit
(** [lauum ?up a] computes

    - [U * U^T] where [U] is the upper triangular part of matrix [a]
      if [up] is [true].
    - [L^T * L] where [L] is the lower triangular part of matrix [a]
      if [up] is [false].

    The upper or lower triangular part is overwritten.
    @param up default = [true].
 *)

(** {3 Linear equations (computational routines)} *)

val getrf : ?ipiv:(('m, 'n) Size.min, cnt) Common.int32_vec ->
            ('m, 'n, 'cd) mat ->
            (('m, 'n) Size.min, 'cnt) Common.int32_vec

val getrs : ?ipiv:(('n, 'n) Size.min, cnt) Common.int32_vec ->
            trans:(('n, 'n, 'a_cd) mat -> ('n, 'n, 'a_cd) mat) trans3 ->
            ('n, 'n, 'a_cd) mat ->
            ('n, 'n, 'b_cd) mat -> unit

type 'n getri_min_lwork

val getri_min_lwork : 'n Size.t -> 'ngetri_min_lwork Size.t

val getri_opt_lwork : ('n, 'n, 'cd) mat -> (module Size.SIZE)

val getri : ?ipiv:(('n, 'n) Size.min, cnt) Common.int32_vec ->
            ?work:('lwork, cnt) vec ->
            ('n, 'n, 'cd) mat -> unit
(** [getri ?ipiv ?work a] computes the inverse of general matrix [a] by
    LU-factorization of [getrf].
    @raise Failure if the matrix is singular.
 *)

type sytrf_min_lwork

val sytrf_min_lwork : unit -> sytrf_min_lwork Size.t

val sytrf_opt_lwork : ?up:bool ->
                      ('n, 'n, 'cd) mat -> (module Size.SIZE)

val sytrf : ?up:bool ->
            ?ipiv:('n, cnt) Common.int32_vec ->
            ?work:('lwork, cnt) vec ->
            ('n, 'n, 'cd) mat -> ('n, 'cnt) Common.int32_vec

val sytrs : ?up:bool ->
            ?ipiv:('n, cnt) Common.int32_vec ->
            ('n, 'n, 'a_cd) mat ->
            ('n, 'nrhs, 'b_cd) mat -> unit

type 'n sytri_min_lwork

val sytri_min_lwork : 'n Size.t -> 'n sytri_min_lwork Size.t

val sytri : ?up:bool ->
            ?ipiv:('n, cnt) Common.int32_vec ->
            ?work:('lwork, cnt) vec ->
            ('n, 'n, 'cd) mat -> unit

val potrf : ?up:bool ->
            ?jitter:num_type ->
            ('n, 'n, 'cd) mat -> unit

val potrs : ?up:bool ->
            ('n, 'n, 'a_cd) mat ->
            ?factorize:bool ->
            ?jitter:num_type ->
            ('n, 'nrhs, 'b_cd) mat -> unit

val potri : ?up:bool ->
            ?factorize:bool ->
            ?jitter:num_type ->
            ('n, 'n, 'cd) mat -> unit

val trtrs : ?up:bool ->
            trans:(('n, 'n, 'a_cd) mat -> ('n, 'n, 'a_cd) mat) trans3
            ->
            ?diag:Common.diag ->
            ('n, 'n, 'a_cd) mat ->
            ('n, 'nrhs, 'b_cd) mat -> unit

val trtri : ?up:bool ->
            ?diag:Common.diag ->
            ('n, 'n, 'cd) mat -> unit

type 'n geqrf_min_lwork

val geqrf_min_lwork : n:'n Size.t -> 'n geqrf_min_lwork Size.t

val geqrf_opt_lwork : ('m, 'n, 'cd) mat -> (module Size.SIZE)

val geqrf : ?work:('lwork, cnt) vec ->
            ?tau:(('m, 'n) Size.min, cnt) vec ->
            ('m, 'n, 'cd) mat -> (('m, 'n) Size.min, 'cnt) vec

(** {3 Linear equations (simple drivers)} *)

val gesv : ?ipiv:('n, cnt) Common.int32_vec ->
           ('n, 'n, 'a_cd) mat ->
           ('n, 'nrhs, 'b_cd) mat -> unit

val posv : ?up:bool ->
           ('n, 'n, 'a_cd) mat ->
           ('n, 'nrhs, 'b_cd) mat -> unit

val sysv_opt_lwork : ?up:bool ->
                     ('n, 'n, 'a_cd) mat ->
                     ('n, 'nrhs, 'b_cd) mat -> (module Size.SIZE)

val sysv : ?up:bool ->
           ?ipiv:('n, cnt) Common.int32_vec ->
           ?work:('lwork, cnt) vec ->
           ('n, 'n, 'a_cd) mat ->
           ('n, 'nrhs, 'b_cd) mat -> unit

(** {3 Least squares (simple drivers)} *)

type ('m, 'n, 'nrhs) gels_min_lwork

val gels_min_lwork : m:'m Size.t ->
                     n:'n Size.t ->
                     nrhs:'nrhs Size.t -> ('m, 'n, 'nrhs) gels_min_lwork Size.t

val gels_opt_lwork : trans:(('am, 'an, 'a_cd) mat ->
                            ('m, 'n, 'a_cd) mat) Common.trans2 ->
                     ('m, 'n, 'a_cd) mat ->
                     ('m, 'nrhs, 'b_cd) mat -> (module Size.SIZE)

val gels : ?work:('work, cnt) vec ->
           trans:(('am, 'an, 'a_cd) mat ->
                  ('m, 'n, 'a_cd) mat) Common.trans2 ->
           ('m, 'n, 'a_cd) mat ->
           ('m, 'nrhs, 'b_cd) mat -> unit
(** [gels ?work ~trans a b] see LAPACK documentation.
    @param work default = an optimum-length vector.
 *)
