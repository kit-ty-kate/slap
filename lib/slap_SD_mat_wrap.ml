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

module F (I    : Slap_module_info.SD)
         (SDCZ : Slap_lacaml.SDCZ_SD with type prec = I.prec)
         (SD   : Slap_lacaml.SD      with type prec = I.prec) =
struct
  (* interface: slap_SD_mat.ml *)

  include Slap_SDCZ_mat_wrap.F(I)(SDCZ)

  (** {2 Creation of matrices} *)

  let random ?rnd_state ?from ?range m n =
    let a = SD.Mat.random ?rnd_state ?from ?range m n in
    (m, n, 1, 1, a)
end
