# Scriptorium Alchimico — Game Pillars (v1)

Last updated: 2026-01-22

This document distills the core principles driving the design of Scriptorium Alchimico, to be used as a fast filter for every feature and balance change.

## Pillars
- Historical fidelity (tasteful, readable): materials (pigments/binders), illumination process, and terminology are accurate but never at the expense of clarity.
- Push‑your‑luck core loop: 4d6 → select → reroll → interpret. Risk (Macchia) vs progress (slots) is the tension engine.
- Illumination chain: sequential checklist (TEXT → DROPCAPS → BORDERS → CORNERS → MINIATURE) with strong, readable completion bonuses that shape the next decisions.
- Binary danger, big payoff: Stain threshold creates sharp fail states; Golden Touch (6) and chain effects create exciting spikes.
- Minimal surface, rich decisions: few actions per turn, no bookkeeping; depth emerges from dice stats, chain effects, and materials.
- Flow first: one clear objective at a time, fast turns, instant feedback, zero dead UI.

## Objectives (player‑facing)
- Per Folio: Complete TEXT and MINIATURE (mandatory). Optional elements amplify bonuses and score.
- Per Run: Complete all Folii in the chosen fascicolo without losing Reputation (run HP).
- Long‑term: Learn the material system, master risk windows, and optimize completion order.

## Constraints (ruleset)
- Dice mapping: 1=Macchia; 2–5 fill 1 slot; 6=Golden Touch (2 slots or −1 Macchia). All values may be modified by active pigment/binder.
- Unlock chain: Elements unlock strictly in order; TEXT always first.
- Stain: Bust at threshold (per fascicolo). Shield from CORNERS absorbs one Stain.
- Turn economy: Only available (unscored) dice can be rerolled. "Hot dice" returns all dice if all were scored in a selection.
- No prototype GATHER/MIX/APPLY UI: core loop stays focused on dice → interpret (materials remain systemic, not UI-heavy).

## Success Criteria
- Folio success: TEXT and MINIATURE completed → next Folio. Pardon if low Stain and no Sins.
- Run success: All Folii completed in fascicolo. Loss if Reputation ≤ 0.
- UX success: Player always knows what to do next, why a result happened, and what improved.

## Rewards & Feedback
- Coins per Folio (by fascicolo), Reputation bonuses (BORDERS, pigment effects), chain effects on completion.
- Immediate, legible feedback on: Stain changes, slots filled, chain effect activations, hot dice, folio completion/bust.

## Play (loop)
1) Roll available dice
2) Select subset to score
3) Interpret results into the active element
4) Check chain effects / thresholds
5) Continue or move to next Folio

## Competition
- Single‑player run quality: score and stats (rolls, stains, pardons, busts). Future: local high scores or seed sharing.

## Design Filters (Always/Never)
- Always prefer a single clear decision over multiple marginal ones.
- Always show cause→effect (why a slot filled, why Stain changed).
- Never require multi‑screen management for a single turn.
- Never hide the active objective.

## Open Questions (track for iterations)
- Material depth vs UI simplicity: how to surface binder/pigment synergies without clutter.
- End‑run scoring visibility: lightweight summary vs detailed codex page.
- Optional difficulty levers: weighted dice, sin system, boss variants.
