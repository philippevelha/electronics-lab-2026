# Journal � Exercise 1 � Car Park 1

> **You:** `russet_heaviside` � **Group:** `russet` � **Opened:** 2026-11-11
> The code in this folder is shared with your group. **This journal is yours alone.**
> Write entries as you work, not after the fact.

---

## Decision log

### Entry � 2026-11-11
**Commit reference:** `<!-- paste: git log --oneline -1 -->`

**What I implemented or decided:**
- read scenario and tasks 
- brainstormed with the group how we want to approach task
- write down important information to clarify
- entity is given in the task
- started with the architecture (inspiration from sliding door exercise)
 - signals -> important for different features of the system
 - constants -> all the different display states
 - variable for password check
 - case for each state sastifying the stages of system based on State table
 - display output
 - light output
 -> both dependent on state of fsm
- begin of testbench (also inspiration from sliding door exercise)
 - write down most important aspects for clarification (scenarios and conventions)
 - initialize entity
 - define signals and constants needed for all scenarios
 - dut initialization
 - procedures for each aspect we want to check ... & expected outputs
 - helpers
 - reset types
- test first scenario -> normal entry (not finished?)


<!-- 2�4 sentences. Be specific about architecture choices. -->

**Why I structured it this way:**
<!-- What alternatives did you consider? Why did you reject them? -->
- we had different ways of counting the waiting time but as we built the architecture this was the only that made sense for us
- the same is true for the blinking light -> we first tried to implement it in each state seperately but this is a lot easier and simpler
- we learned not to put everything in the states and decompose each
- this temporary result had the best overview

**What I am not sure about:**
<!-- Honest uncertainty. Never graded for correctness � only for presence. -->
- if anything will actually work because we could not really test it yet -> maybe we need to change everything again
- if we understood the details of the task correctly
- 

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
