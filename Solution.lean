/-
Copyright (c) 2026 Juan Pablo Traverso Gianini. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Juan Pablo Traverso Gianini
-/
module

public import Euler

public section

/-!
# Proofs of the statements in `Challenge.lean`

Each declaration restates its counterpart in `Challenge.lean` verbatim and is proved from the
`Euler` library:

* `Euler.Basic`: maximal-trail proof of the circuit theorem;
* `Euler.Trail`: closed trails avoiding a prescribed edge set, splicing, and the trail theorem;
* `Euler.Orientation`: decomposition into edge-disjoint closed trails and Eulerian orientation;
* `Euler.Petersen`: Hall's theorem on regular digraphs, decomposition into permutations, and the
  2-factor theorem.
-/

namespace EulerPetersen

variable {V : Type*} [Fintype V] [DecidableEq V] {G : SimpleGraph V} [DecidableRel G.Adj]

theorem eulerian_circuit_iff (hconn : G.Connected) :
    (∃ u, ∃ p : G.Walk u u, p.IsEulerian) ↔ ∀ v, Even (G.degree v) :=
  SimpleGraph.exists_isEulerian_iff_forall_even_degree hconn

theorem eulerian_circuit_at (hconn : G.Connected) (heven : ∀ v, Even (G.degree v)) (a : V) :
    ∃ p : G.Walk a a, p.IsEulerian :=
  SimpleGraph.exists_isEulerian_circuit_at hconn heven a

theorem eulerian_trail_iff (hconn : G.Connected) :
    (∃ u v, ∃ p : G.Walk u v, p.IsEulerian) ↔
      Fintype.card {v | Odd (G.degree v)} = 0 ∨ Fintype.card {v | Odd (G.degree v)} = 2 :=
  SimpleGraph.exists_isEulerian_walk_iff hconn

theorem eulerian_trail_of_odd (hconn : G.Connected) {a b : V} (hab : a ≠ b)
    (hodd : ∀ x, Odd (G.degree x) ↔ x = a ∨ x = b) : ∃ p : G.Walk a b, p.IsEulerian :=
  SimpleGraph.exists_isEulerian_of_odd_iff hconn hab hodd

theorem eulerian_orientation (heven : ∀ v, Even (G.degree v)) :
    ∃ Ds : Finset G.Dart, (∀ d ∈ Ds, ∀ d' ∈ Ds, d.edge = d'.edge → d = d') ∧
      (∀ v, (Ds.filter fun d => d.fst = v).card = (Ds.filter fun d => d.snd = v).card) ∧
      ∀ e ∈ G.edgeSet, ∃ d ∈ Ds, d.edge = e :=
  SimpleGraph.exists_balanced_orientation heven

theorem petersen_two_factor (k : ℕ) (h : ∀ v, G.degree v = 2 * k) :
    ∃ F : Fin k → SimpleGraph V, (∀ i, F i ≤ G) ∧
      (∀ i v, ((F i).neighborSet v).ncard = 2) ∧
      (∀ i j, i ≠ j → Disjoint (F i) (F j)) ∧ ⨆ i, F i = G :=
  SimpleGraph.petersen_two_factor k h

end EulerPetersen
