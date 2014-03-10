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

(** The signature of [Slap.[SD].Mat]. *)

module type S =
sig
  (* implementation: slap_SD_mat_wrap.ml *)

  include Slap_SDCZ_mat.S

  (** {2 Creation of matrices} *)

  val random : ?rnd_state:Random.State.t ->
               ?from:float -> ?range:float ->
               'm Common.size -> 'n Common.size -> ('m, 'n, 'cnt) mat
end
