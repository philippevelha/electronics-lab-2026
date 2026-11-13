# Journal — Exercise 1 — Car Park 1

> **You:** `henna_cauchy` · **Group:** `henna` · **Opened:** 2026-11-11
> The code in this folder is shared with your group. **This journal is yours alone.**
> Write entries as you work, not after the fact.

---

## Decision log

### Entry — 2026-11-11
**Commit reference:** `e83d9cd36196aa90f397e1e1a311a20091d53aa8`

**What I implemented or decided:**
<!-- 2–4 sentences. Be specific about architecture choices. -->
I made the first basic structure of the FSM and of the datapath. I also decided how to start with the structure of the `.vhd` file, with the clock process and counter wrapping all other processes.

**Why I structured it this way:**
<!-- What alternatives did you consider? Why did you reject them? -->
I took inspiration from the clock in the traffic light exercise. I considered also making separate processes: `state_register`, `clock`, `FSM` but ultimately decided to merge them in order to update the clock cycle counter in an easier way. 

**What I am not sure about:**
<!-- Honest uncertainty. Never graded for correctness — only for presence. -->
I still have to decide how long should a clock cycle take and figure out how to connect the system with the contributes from the other members.

**What the simulation or hardware told me I was wrong about:**
<!-- No simulation was done yet>
<!-- Leave blank now. Fill in when you find out. Most important field. -->

---
<!-- Copy the block above for each significant commit. -->

## Post-submission reflection

**What worked and why:**
We managed to find out a good FSM and datapath that could describe the architecture well enough to make it easily implementable.<br>
**What I would change and why:**
I would fix the clock duration and add the other states in the code. <br>
**What assumption did I carry in from the previous exercise that I had to revise here:**
<!-- Required from Exercise 2 onward. -->

**What part of this was my own contribution, and what did I learn from a teammate:**
I helped my teammates with the VHDL syntax and with the reasoning to make a general system, from my teammates I learned some basics of git.
