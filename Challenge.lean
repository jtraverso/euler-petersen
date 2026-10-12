/-
Copyright (c) 2026 Juan Pablo Traverso Gianini. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Juan Pablo Traverso Gianini
-/
module

public import Mathlib.Combinatorics.SimpleGraph.Trails
public import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected
public import Mathlib.Combinatorics.SimpleGraph.Finite
public import Mathlib.Combinatorics.SimpleGraph.Dart
public import Mathlib.Data.Set.Card

public section

/-!
# Euler's theorem on Eulerian circuits and trails, and Petersen's 2-factor theorem

All graphs are finite simple graphs `G : SimpleGraph V` with `[Fintype V]`. We use Mathlib's
notions throughout:

* `SimpleGraph.Walk.IsEulerian p`: the walk `p` uses every edge of `G` exactly once. A closed
  Eulerian walk (`p : G.Walk u u`) is an *Eulerian circuit*; an arbitrary one is an *Eulerian
  trail*.
* `G.degree v`, `G.Connected`, `G.edgeSet`, `G.Dart` (an ordered pair of adjacent vertices,
  i.e. an oriented edge) with `Dart.edge` its underlying edge.
* `SimpleGraph` forms a complete lattice: `F ≤ G` means `F` is a spanning subgraph of `G`,
  `Disjoint F₁ F₂` means that `F₁` and `F₂` share no edge, and `⨆ i, F i` is the union.

The results:

1. **Euler (circuits).** A finite connected graph has an Eulerian circuit iff every vertex has
   even degree. Moreover the circuit may start at any prescribed vertex.
2. **Euler (trails).** A finite connected graph has an Eulerian trail iff it has `0` or `2`
   vertices of odd degree; if the odd vertices are exactly `a ≠ b`, there is an Eulerian trail
   from `a` to `b`.
3. **Eulerian orientation.** If every degree is even, the edges can be oriented (one dart per
   edge) so that every vertex has equal in- and out-degree.
4. **Petersen's 2-factor theorem (1891).** Every finite `2k`-regular graph is the edge-disjoint
   union of `k` spanning 2-regular subgraphs (2-factors).

The necessity directions of 1–2 were already in Mathlib (`IsEulerian.even_degree_iff`,
`IsEulerian.card_odd_degree`); the sufficiency directions were listed there as a TODO.

The Mathlib definitions used in these statements are reproduced verbatim, with file and line at
the pinned Mathlib revision, in `MATHLIB_DEFINITIONS.md` at the root of this repository.
-/

namespace EulerPetersen

variable {V : Type*} [Fintype V] [DecidableEq V] {G : SimpleGraph V} [DecidableRel G.Adj]

/-- **Euler–Hierholzer theorem.** A finite connected graph has an Eulerian circuit if and only if
every vertex has even degree. -/
theorem eulerian_circuit_iff (hconn : G.Connected) :
    (∃ u, ∃ p : G.Walk u u, p.IsEulerian) ↔ ∀ v, Even (G.degree v) := by
  sorry

/-- In a finite connected graph with all degrees even, there is an Eulerian circuit through any
prescribed vertex `a`. -/
theorem eulerian_circuit_at (hconn : G.Connected) (heven : ∀ v, Even (G.degree v)) (a : V) :
    ∃ p : G.Walk a a, p.IsEulerian := by
  sorry

/-- **Euler's theorem for trails.** A finite connected graph has an Eulerian trail if and only if
the number of vertices of odd degree is `0` or `2`. -/
theorem eulerian_trail_iff (hconn : G.Connected) :
    (∃ u v, ∃ p : G.Walk u v, p.IsEulerian) ↔
      Fintype.card {v | Odd (G.degree v)} = 0 ∨ Fintype.card {v | Odd (G.degree v)} = 2 := by
  sorry

/-- If the vertices of odd degree of a finite connected graph are exactly `a ≠ b`, there is an
Eulerian trail from `a` to `b`. -/
theorem eulerian_trail_of_odd (hconn : G.Connected) {a b : V} (hab : a ≠ b)
    (hodd : ∀ x, Odd (G.degree x) ↔ x = a ∨ x = b) : ∃ p : G.Walk a b, p.IsEulerian := by
  sorry

/-- **Eulerian orientation.** If every vertex has even degree, there is a set of darts containing
exactly one dart for each edge, such that at every vertex `v` the number of darts leaving `v`
equals the number of darts entering `v`. -/
theorem eulerian_orientation (heven : ∀ v, Even (G.degree v)) :
    ∃ Ds : Finset G.Dart, (∀ d ∈ Ds, ∀ d' ∈ Ds, d.edge = d'.edge → d = d') ∧
      (∀ v, (Ds.filter fun d => d.fst = v).card = (Ds.filter fun d => d.snd = v).card) ∧
      ∀ e ∈ G.edgeSet, ∃ d ∈ Ds, d.edge = e := by
  sorry

/-- **Petersen's 2-factor theorem.** Every finite `2k`-regular graph decomposes into `k`
edge-disjoint 2-factors: spanning subgraphs `F 0, …, F (k-1)` of `G` in which every vertex has
exactly two neighbours, pairwise without common edges, whose union is `G`. -/
theorem petersen_two_factor (k : ℕ) (h : ∀ v, G.degree v = 2 * k) :
    ∃ F : Fin k → SimpleGraph V, (∀ i, F i ≤ G) ∧
      (∀ i v, ((F i).neighborSet v).ncard = 2) ∧
      (∀ i j, i ≠ j → Disjoint (F i) (F j)) ∧ ⨆ i, F i = G := by
  sorry

end EulerPetersen
