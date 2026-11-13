# Journal � Exercise 1 � Car Park 1

> **You:** `weld_shannon` � **Group:** `weld` � **Opened:** 2026-11-11
> The code in this folder is shared with your group. **This journal is yours alone.**
> Write entries as you work, not after the fact.

---

## Decision log

### Entry � 2026-11-11
**Commit reference:** `<!-- paste: git log --oneline -1 -->`
6f0eb6e (HEAD -> main) [DOCS] plum_cauchy: final clean state diagram v2

**What I implemented or decided:**
<!-- 2�4 sentences. Be specific about architecture choices. -->
Implemented the FSM for the project. Blink is a separate process and everything is handled by a switch statement because that's how the other exercises did it and it's easier to work with. Also the counter is an integer so it can be incremented much easier.

**Why I structured it this way:**
<!-- What alternatives did you consider? Why did you reject them? -->
Blink is handled by a separate process because it just seemed cleaner. The system defaults to IDLE when the front sensor is not detecting anything (and it is not currently STOP).

**What I am not sure about:**
<!-- Honest uncertainty. Never graded for correctness � only for presence. -->

**What the simulation or hardware told me I was wrong about:**
<!-- Leave blank now. Fill in when you find out. Most important field. -->

---
<!-- Copy the block above for each significant commit. -->

## Post-submission reflection

**What worked and why:**

**What I would change and why:**
<!-- Be specific. Reference commit hashes. -->

**What assumption did I carry in from the previous exercise that I had to revise here:**
<!-- Required from Exercise 2 onward. -->

**What part of this was my own contribution, and what did I learn from a teammate:**
