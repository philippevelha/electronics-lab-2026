# Journal � Exercise 1 � Car Park 1

> **You:** `weld_shannon` � **Group:** `weld` � **Opened:** 2026-11-11
> The code in this folder is shared with your group. **This journal is yours alone.**
> Write entries as you work, not after the fact.

---

## Decision log

### Entry � 2026-11-11
**Commit reference:** `<!-- paste: git log --oneline -1 -->`
1d5ed93 (HEAD -> master, origin/main, origin/HEAD) Material for the first exercise on the car park 1

**What I implemented or decided:**
<!-- 2�4 sentences. Be specific about architecture choices. -->
I copied from previous exercises (mainly bike and sliding door) to get the basics done. I've got the FSM down as well as the reset and light blinking processes. We decided that the FSM should wait 10 cycles on WAIT_PASSWORD and then check the password, then go to the next state. If that state is WRONG_PASS, it'll wait for 10 cycles before going back to WAIT_PASSWORD. If that state is RIGHT_PASS, it'll stay on RIGHT_PASS until back_sensor is 1 (when the car passes the gate) and then immediately switches to STOP.

**Why I structured it this way:**
<!-- What alternatives did you consider? Why did you reject them? -->
I changed the counter to an integer so I can just add one to it easily. The counter gets reset on every transition, which makes the code simpler.

**What I am not sure about:**
<!-- Honest uncertainty. Never graded for correctness � only for presence. -->
There's still one process that I don't know what it's supposed to do because it's unnamed but I don't really need it anyway.

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
