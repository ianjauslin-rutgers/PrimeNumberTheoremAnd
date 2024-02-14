/-
Copyright (c) 2024 Lawrence Wu. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Lawrence Wu
-/
import Mathlib.MeasureTheory.Group.Measure
import Mathlib.MeasureTheory.Integral.Asymptotics
import Mathlib.MeasureTheory.Integral.IntegrableOn
import Mathlib.MeasureTheory.Integral.SetIntegral
import Mathlib.MeasureTheory.Function.LocallyIntegrable
import PrimeNumberTheoremAnd.Mathlib.Analysis.Asymptotics.Uniformly
import PrimeNumberTheoremAnd.Mathlib.MeasureTheory.Integral.IntegrableOn
import PrimeNumberTheoremAnd.Mathlib.MeasureTheory.Function.LocallyIntegrable
import PrimeNumberTheoremAnd.Mathlib.MeasureTheory.Group.Arithmetic

/-!
# Bounding of integrals by asymptotics

We establish integrability of `f` from `f = O(g)`.

## Main results

* `Asymptotics.IsBigO.integrableAtFilter`: If `f = O[l] g` on measurably generated `l`,
  `f` is strongly measurable at `l`, and `g` is integrable at `l`, then `f` is integrable at `l`.
* `MeasureTheory.LocallyIntegrable.integrable_of_isBigO_cocompact`: If `f` is locally integrable,
  and `f =O[cocompact] g` for some `g` integrable at `cocompact`, then `f` is integrable.
* `MeasureTheory.LocallyIntegrable.integrable_of_isBigO_atBot_atTop`: If `f` is locally integrable,
  and `f =O[atBot] g`, `f =O[atTop] g'` for some `g`, `g'` integrable `atBot` and `atTop`
  respectively, then `f` is integrable.
* `MeasureTheory.LocallyIntegrable.integrable_of_isBigO_atTop_of_norm_eq_norm_neg`:
  If `f` is locally integrable, `‖f(-x)‖ = ‖f(x)‖`, and `f =O[atTop] g` for some
  `g` integrable `atTop`, then `f` is integrable.
-/

open Asymptotics MeasureTheory Set Filter

variable {α E F : Type*} [MeasurableSpace α] [NormedAddCommGroup E] [NormedAddCommGroup F]
  {f : α → E} {g : α → F} {a b : α} {μ : Measure α} {l : Filter α}

variable [TopologicalSpace α] [SecondCountableTopology α]

namespace MeasureTheory

/-- If `f` is locally integrable, and `f =O[cocompact] g` for some `g` integrable at `cocompact`,
then `f` is integrable. -/
theorem LocallyIntegrable.integrable_of_isBigO_cocompact [IsMeasurablyGenerated (cocompact α)]
    (hf : LocallyIntegrable f μ) (ho : f =O[cocompact α] g)
    (hg : IntegrableAtFilter g (cocompact α) μ) : Integrable f μ := by
  refine integrable_iff_integrableAtFilter_cocompact.mpr ⟨ho.integrableAtFilter ?_ hg, hf⟩
  exact hf.aestronglyMeasurable.stronglyMeasurableAtFilter

section LinearOrder

variable [LinearOrder α] [CompactIccSpace α] {g' : α → F}

/-- If `f` is locally integrable, and `f =O[atBot] g`, `f =O[atTop] g'` for some
`g`, `g'` integrable at `atBot` and `atTop` respectively, then `f` is integrable. -/
theorem LocallyIntegrable.integrable_of_isBigO_atBot_atTop
    [IsMeasurablyGenerated (atBot (α := α))] [IsMeasurablyGenerated (atTop (α := α))]
    (hf : LocallyIntegrable f μ)
    (ho : f =O[atBot] g) (hg : IntegrableAtFilter g atBot μ)
    (ho' : f =O[atTop] g') (hg' : IntegrableAtFilter g' atTop μ) : Integrable f μ := by
  refine integrable_iff_integrableAtFilter_atBot_atTop.mpr
    ⟨⟨ho.integrableAtFilter ?_ hg, ho'.integrableAtFilter ?_ hg'⟩, hf⟩
  all_goals exact hf.aestronglyMeasurable.stronglyMeasurableAtFilter

/-- If `f` is locally integrable on `(∞, a]`, and `f =O[atBot] g`, for some
`g` integrable at `atBot`, then `f` is integrable on `(∞, a]`. -/
theorem LocallyIntegrableOn.integrableOn_of_isBigO_atBot [IsMeasurablyGenerated (atBot (α := α))]
    (hf : LocallyIntegrableOn f (Iic a) μ) (ho : f =O[atBot] g)
    (hg : IntegrableAtFilter g atBot μ) : IntegrableOn f (Iic a) μ := by
  refine integrableOn_Iic_iff_integrableAtFilter_atBot.mpr ⟨ho.integrableAtFilter ?_ hg, hf⟩
  exact ⟨Iic a, Iic_mem_atBot a, hf.aestronglyMeasurable⟩

/-- If `f` is locally integrable on `[a, ∞)`, and `f =O[atTop] g`, for some
`g` integrable at `atTop`, then `f` is integrable on `[a, ∞)`. -/
theorem LocallyIntegrableOn.integrableOn_of_isBigO_atTop [IsMeasurablyGenerated (atTop (α := α))]
    (hf : LocallyIntegrableOn f (Ici a) μ) (ho : f =O[atTop] g)
    (hg : IntegrableAtFilter g atTop μ) : IntegrableOn f (Ici a) μ := by
  refine integrableOn_Ici_iff_integrableAtFilter_atTop.mpr ⟨ho.integrableAtFilter ?_ hg, hf⟩
  exact ⟨Ici a, Ici_mem_atTop a, hf.aestronglyMeasurable⟩

/-- If `f` is locally integrable, `f` has a top element, and `f =O[atBot] g`, for some
`g` integrable at `atBot`, then `f` is integrable. -/
theorem LocallyIntegrable.integrable_of_isBigO_atBot [IsMeasurablyGenerated (atBot (α := α))]
    [OrderTop α] (hf : LocallyIntegrable f μ) (ho : f =O[atBot] g)
    (hg : IntegrableAtFilter g atBot μ) : Integrable f μ := by
  refine integrable_iff_integrableAtFilter_atBot.mpr ⟨ho.integrableAtFilter ?_ hg, hf⟩
  exact hf.aestronglyMeasurable.stronglyMeasurableAtFilter

/-- If `f` is locally integrable, `f` has a bottom element, and `f =O[atTop] g`, for some
`g` integrable at `atTop`, then `f` is integrable. -/
theorem LocallyIntegrable.integrable_of_isBigO_atTop [IsMeasurablyGenerated (atTop (α := α))]
    [OrderBot α] (hf : LocallyIntegrable f μ) (ho : f =O[atTop] g)
    (hg : IntegrableAtFilter g atTop μ) : Integrable f μ := by
  refine integrable_iff_integrableAtFilter_atTop.mpr ⟨ho.integrableAtFilter ?_ hg, hf⟩
  exact hf.aestronglyMeasurable.stronglyMeasurableAtFilter

end LinearOrder

section LinearOrderedAddCommGroup

/-- If `f` is locally integrable, `‖f(-x)‖ = ‖f(x)‖`, and `f =O[atTop] g`, for some
`g` integrable at `atTop`, then `f` is integrable. -/
theorem LocallyIntegrable.integrable_of_isBigO_atTop_of_norm_eq_norm_neg
    [LinearOrderedAddCommGroup α] [CompactIccSpace α] [IsMeasurablyGenerated (atTop (α := α))]
    [MeasurableNeg α] [μ.IsNegInvariant] (hf : LocallyIntegrable f μ)
    (hsymm : norm ∘ f =ᵐ[μ] norm ∘ f ∘ Neg.neg) (ho : f =O[atTop] g)
    (hg : IntegrableAtFilter g atTop μ) : Integrable f μ := by
  refine (isEmpty_or_nonempty α).casesOn (fun _ ↦ ?_) (fun _ ↦ ?_)
  · exact integrableOn_univ.mp (by convert integrableOn_empty)
  let a := -|Classical.arbitrary α|
  have h_int : IntegrableOn f (Ici a) μ :=
    LocallyIntegrableOn.integrableOn_of_isBigO_atTop (hf.locallyIntegrableOn _) ho hg
  have h_map_neg : (μ.restrict (Ici a)).map Neg.neg = μ.restrict (Iic (-a)) := by
    rw [show Ici a = Neg.neg ⁻¹' Iic (-a) by simp, ← measurableEmbedding_neg.restrict_map,
      Measure.map_neg_eq_self]
  have h_int_neg : IntegrableOn (f ∘ Neg.neg) (Ici a) μ := by
    refine h_int.congr' ?_ hsymm.restrict
    refine AEStronglyMeasurable.comp_aemeasurable ?_ measurable_neg.aemeasurable
    convert hf.aestronglyMeasurable.restrict
  replace h_int_neg := measurableEmbedding_neg.integrable_map_iff.mpr h_int_neg
  rewrite [h_map_neg] at h_int_neg
  refine integrableOn_univ.mp ?_
  convert integrableOn_union.mpr ⟨h_int_neg, h_int⟩
  exact (Set.Iic_union_Ici_of_le (by simp)).symm

end LinearOrderedAddCommGroup

namespace Asymptotics

section Uniformly

variable {ι : Type*} [MeasurableSpace ι] {f : ι × α → E} {s : Set ι} {μ : Measure ι}

/-- Let `f : X x Y → Z`. If as y → l, f(x, y) = O(g(y)) uniformly on `s : Set X` of finite measure,
then f is eventually (as y → l) integrable along `s`. -/
theorem IsBigO.eventually_integrableOn [Norm F]
    (hf : f =O[𝓟 s ×ˢ l] fun (_i, x) ↦ g x)
    (hfm : ∀ᶠ x in l, AEStronglyMeasurable (fun i ↦ f (i, x)) (μ.restrict s))
    (hs : MeasurableSet s) (hμ : μ s < ⊤) :
    ∀ᶠ x in l, IntegrableOn (fun i ↦ f (i, x)) s μ := by
  obtain ⟨C, hC⟩ := hf.bound
  obtain ⟨t, htl, ht⟩ := hC.exists_mem
  obtain ⟨u, hu, v, hv, huv⟩ := Filter.mem_prod_iff.mp htl
  obtain ⟨w, hwl, hw⟩ := hfm.exists_mem
  refine eventually_iff_exists_mem.mpr ⟨w ∩ v, inter_mem hwl hv, fun x hx ↦ ?_⟩
  haveI : IsFiniteMeasure (μ.restrict s) :=
    ⟨by convert hμ using 1; exact Measure.restrict_apply_univ s⟩
  refine Integrable.mono' (integrable_const (C * ‖g x‖)) (hw x hx.1) ?_
  filter_upwards [MeasureTheory.self_mem_ae_restrict hs]
  intro y hy
  exact ht (y, x) <| huv ⟨hu hy, hx.2⟩

variable [NormedSpace ℝ E] [NormedAddCommGroup F] [NormedSpace ℝ F]

/-- Let `f : X x Y → Z`. If as y → l, f(x, y) = O(g(y)) uniformly on `s : Set X` of finite measure,
then the integral of f along s is O(g(y)). -/
theorem IsBigO.set_integral_isBigO
    (hf : f =O[𝓟 s ×ˢ l] fun (_i, x) ↦ g x) (hs : MeasurableSet s) (hμ : μ s < ⊤)  :
    (fun x ↦ ∫ i in s, f (i, x) ∂μ) =O[l] g := by
  obtain ⟨C, hC⟩ := hf.bound
  obtain ⟨t, htl, ht⟩ := hC.exists_mem
  obtain ⟨u, hu, v, hv, huv⟩ := Filter.mem_prod_iff.mp htl
  refine isBigO_iff.mpr ⟨C * (μ s).toReal, eventually_iff_exists_mem.mpr ⟨v, hv, fun x hx ↦ ?_⟩⟩
  rewrite [mul_assoc, ← smul_eq_mul (a' := ‖g x‖), ← MeasureTheory.Measure.restrict_apply_univ,
    ← integral_const, mul_comm, ← smul_eq_mul, ← integral_smul_const]
  refine (norm_integral_le_integral_norm _).trans <|
    integral_mono_of_nonneg (univ_mem' fun _ ↦ norm_nonneg _) ?_ ?_
  · haveI : IsFiniteMeasure (μ.restrict s) :=
      ⟨by convert hμ using 1; exact Measure.restrict_apply_univ s⟩
    exact integrable_const _
  · filter_upwards [MeasureTheory.self_mem_ae_restrict hs]
    intro y hy
    rewrite [smul_eq_mul, mul_comm]
    exact ht (y, x) <| huv ⟨hu hy, hx⟩

end Uniformly

end Asymptotics
