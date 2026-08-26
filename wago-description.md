# [Kende] Proc Trackers

Three proc bars for Mists of Pandaria Classic, tracking the exact moment your buffs peak so you can time your snapshots.

## Bar 1 — Black Blood of Y'Shaarj

Tracks the trinket **Black Blood of Y'Shaarj** (works for every item version: LFR/Celestial, Flexible, Normal, Warforged, Heroic, Heroic Warforged — they all share the same proc and buff spell IDs).

- The bar fills over the 10 second duration of **Wrath of the Darkspear**, with one tick mark per second.
- The left-side number shows your current stacks of **Wrath**, the buff that actually grants Intellect (1 stack per second, up to 10).
- The bar turns **gold** once you hit 9+ stacks — that's your snapshot window, since the 10th stack lingers for about 2 extra seconds after the timer bar ends.
- Plays an Error Beep sound the moment the trinket procs.

## Bar 2 — Sinister Primal Diamond

Tracks the legendary meta gem **Sinister Primal Diamond**'s haste proc (**Tempus Repit**, +30% spell haste for 10 seconds, flat — no stacks).

- Sits just below Bar 1.
- Drains steadily for the full 10 seconds and disappears the instant the buff falls off.
- 9 tick marks, one per second.
- Plays an Electrical Spark sound, distinct from the other two bars.

## Bar 3 — Unerring Vision of Lei Shen

Tracks the trinket **Unerring Vision of Lei Shen**'s crit proc (**Perfect Aim**, +100% critical strike chance for 4 seconds, flat — no stacks). Works for every item version (LFR/Celestial, Normal, Thunderforged, Heroic, Heroic Thunderforged).

- Sits just above Bar 1.
- Very short window: drains fast for the full 4 seconds and disappears the instant it falls off.
- 3 tick marks, one per second.
- Plays a Boxing Arena Gong sound.

## Notes

- All three bars live in a shared **dynamic group**: only the procs that are currently active are shown, stacked with no gap between them. If you don't have one of the trinkets equipped, or its bar just isn't up, the others simply close the gap — nothing to configure. Move the group in-game to reposition all of them at once.
- Size, colors and sounds are fully editable from the normal WeakAuras options.

Author: **Kendeclise**
