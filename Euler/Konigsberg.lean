/-
Copyright (c) 2026 Juan Pablo Traverso Gianini. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Juan Pablo Traverso Gianini
-/
module

public import Euler.Basic
public import Mathlib.Tactic.FinCases

/-!
# Los puentes de Königsberg

Königsberg tiene 4 masas de tierra y 7 puentes:
* `0` = isla Kneiphof (A), `1` = orilla norte (B), `2` = orilla sur (C), `3` = isla Lomse (D);
* puentes: A–B (dos), A–C (dos), A–D, B–D, C–D.

Como hay puentes paralelos, el grafo es un *multigrafo*. Para usar `SimpleGraph` lo subdividimos:
cada puente es un vértice nuevo (`4, …, 10`) unido a las dos masas de tierra que conecta. Un
paseo que cruza cada puente exactamente una vez corresponde a un trail euleriano del grafo
subdividido (cada puente-vértice se atraviesa por sus dos aristas consecutivamente).

Grados: A = 5, B = C = D = 3, puentes = 2. Hay 4 vértices de grado impar, y un trail euleriano
admite 0 ó 2 (`SimpleGraph.Walk.IsEulerian.card_odd_degree`), luego no existe el paseo.
-/

@[expose] public section

namespace Konigsberg

/-- Aristas del grafo subdividido: `(puente, masa de tierra)`. -/
def edgeList : List (ℕ × ℕ) :=
  [(4, 0), (4, 1), (5, 0), (5, 1),   -- A–B (dos puentes)
   (6, 0), (6, 2), (7, 0), (7, 2),   -- A–C (dos puentes)
   (8, 0), (8, 3),                   -- A–D
   (9, 1), (9, 3),                   -- B–D
   (10, 2), (10, 3)]                 -- C–D

/-- El grafo de Königsberg con cada puente subdividido. -/
def graph : SimpleGraph (Fin 11) where
  Adj i j := (i.val, j.val) ∈ edgeList ∨ (j.val, i.val) ∈ edgeList
  symm := ⟨fun _ _ h => h.symm⟩
  loopless := ⟨fun i => by fin_cases i <;> decide⟩

instance : DecidableRel graph.Adj := fun i j =>
  inferInstanceAs (Decidable ((i.val, j.val) ∈ edgeList ∨ (j.val, i.val) ∈ edgeList))

lemma degrees :
    graph.degree 0 = 5 ∧ graph.degree 1 = 3 ∧ graph.degree 2 = 3 ∧ graph.degree 3 = 3 := by
  decide

lemma card_odd_degree : Fintype.card {v : Fin 11 | Odd (graph.degree v)} = 4 := by
  decide

/-- **Königsberg.** No existe un paseo que cruce cada puente exactamente una vez
(ni cerrado ni abierto). -/
theorem no_eulerian_walk : ¬ ∃ u v, ∃ p : graph.Walk u v, p.IsEulerian := by
  rintro ⟨u, v, p, hp⟩
  have := hp.card_odd_degree
  rw [card_odd_degree] at this
  omega

/-- En particular, no hay circuito euleriano; por el teorema de Euler esto equivale a que
algún vértice tiene grado impar. -/
theorem no_eulerian_circuit : ¬ ∃ u, ∃ p : graph.Walk u u, p.IsEulerian :=
  fun ⟨u, p, hp⟩ => no_eulerian_walk ⟨u, u, p, hp⟩

end Konigsberg
