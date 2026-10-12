# Euler's theorem and Petersen's 2-factor theorem in Lean 4

Author and maintainer: **Juan Pablo Traverso Gianini**. Licence: Apache-2.0 (see `LICENSE`).

This repository formalizes, for finite simple graphs in Lean 4 with Mathlib:

1. **Euler–Hierholzer theorem.** A finite connected graph has an Eulerian circuit (a closed walk
   using every edge exactly once) if and only if every vertex has even degree; the circuit can
   start at any prescribed vertex.
2. **Eulerian trails.** A finite connected graph has an Eulerian trail if and only if it has
   0 or 2 vertices of odd degree; if the odd vertices are exactly `a ≠ b`, the trail can be taken
   from `a` to `b`.
3. **Eulerian orientations.** If every degree is even, the edges can be oriented so that every
   vertex has as many outgoing as incoming edges.
4. **Petersen's 2-factor theorem (1891).** Every finite `2k`-regular graph is the edge-disjoint
   union of `k` 2-factors (spanning subgraphs in which every vertex has degree 2).

The audited statements are in [`Challenge.lean`](Challenge.lean) (Mathlib imports only); the
proofs are in [`Solution.lean`](Solution.lean), which re-states them and applies the library in
[`Euler/`](Euler). [`comparator.json`](comparator.json) lists the compared theorems and
[`MATHLIB_DEFINITIONS.md`](MATHLIB_DEFINITIONS.md) reproduces verbatim the Mathlib definitions
used by the statements (at the pinned Mathlib revision), and
[`formalization.yaml`](formalization.yaml) records provenance, sources and process.

## How the proofs go

* **Circuits** (`Euler/Basic.lean`). Take a trail of maximal length. If it is open, its last
  vertex meets an odd number of its edges but has even degree, so the trail extends. If it is
  closed but misses an edge, connectivity gives a vertex of the trail with an unused edge;
  rotating the trail to start there, it extends. Trail lengths are bounded by the number of
  edges, so a longest trail is an Eulerian circuit. Necessity is Mathlib's
  `IsEulerian.even_degree_iff`.
* **Trails** (`Euler/Trail.lean`). Key lemma: if a list of edges `S` has, at every vertex, the
  parity of the degree, then any vertex with an edge outside `S` lies on a closed trail of
  positive length avoiding `S`. A longest trail from `a` to `b` that is not Eulerian is extended
  by splicing such a closed trail into it (Hierholzer). Necessity is Mathlib's
  `IsEulerian.card_odd_degree`.
* **Orientations** (`Euler/Orientation.lean`). Repeatedly applying the key lemma decomposes an
  even graph into edge-disjoint closed trails; orienting each along its direction balances
  in- and out-degrees.
* **Petersen** (`Euler/Petersen.lean`). For a `2k`-regular graph the Eulerian orientation is
  `k`-in/`k`-out regular. Hall's marriage theorem (Mathlib) gives a permutation `σ` with every
  `v → σ v` an arc; removing it leaves a `(k-1)`-regular digraph, so the arcs split into `k`
  permutations. Each permutation `σ` defines a 2-factor in which the neighbours of `v` are `σ v`
  and `σ⁻¹ v`; these differ because the orientation never contains both `v → w` and `w → v`.

`Euler/Konigsberg.lean` additionally shows, for the Königsberg bridges modelled as a simple graph
by subdividing every bridge, that no walk crosses every bridge exactly once (4 vertices of odd
degree). It is illustrative and not part of the compared statements.

## Scope and limitations

* Graphs are finite and simple; the historical statements are for multigraphs.
* `G.Connected` is Mathlib's notion (it includes a nonempty vertex type).
* No `sorry`, no custom axioms; the compared theorems depend only on `propext`,
  `Classical.choice` and `Quot.sound`.

## Sources

* L. Euler, *Solutio problematis ad geometriam situs pertinentis*, Comment. Acad. Sci. Petrop. 8
  (1741) 128–140 (E53).
* C. Hierholzer, *Ueber die Möglichkeit, einen Linienzug ohne Wiederholung und ohne
  Unterbrechung zu umfahren*, Math. Ann. 6 (1873) 30–32.
* J. Petersen, *Die Theorie der regulären graphs*, Acta Math. 15 (1891) 193–220.
* P. Hall, *On representatives of subsets*, J. London Math. Soc. 10 (1935) 26–30 (via Mathlib).
* T. Räz, *Mathematical Explanations in Euler's Königsberg*, PhilSci-Archive 11094 (2014)
  (historical background).

Prior formal work: Mathlib's `Mathlib/Combinatorics/SimpleGraph/Trails.lean` (definition of
Eulerian walks and the necessity directions, with sufficiency listed as TODO); an independent
Isabelle/HOL formalization of Euler's theorem for multigraphs (AFP entry
`Koenigsberg_Friendship`). We are not aware of a prior Lean formalization of Petersen's
2-factor theorem; this was checked against Mathlib, the Lean Pool collection and the Palomar
registry, not by an exhaustive literature search.

## Authorship and use of AI

The mathematical choices, the statements and the direction of the work are by the author. The
Lean code was written with the assistance of an AI agent (Claude Opus 5.5 in Claude Code), and
every result was checked mechanically with Lean (`lake build`, `#print axioms`, and identical
elaborated types for each Challenge/Solution pair). See `formalization.yaml` for details.

## Building

Lean `v4.35.0-rc3`, Mathlib `c55e6e786f49471c72fbddbec5415808896aec1e`:

```bash
lake exe cache get
lake build
```

Submissions to the Palomar registry go through https://submit.palomar-registry.org/.
