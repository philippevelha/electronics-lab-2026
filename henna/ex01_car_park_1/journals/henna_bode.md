# Journal � Exercise 1 � Car Park 1

> **You:** `henna_bode` � **Group:** `henna` � **Opened:** 2026-11-11
> The code in this folder is shared with your group. **This journal is yours alone.**
> Write entries as you work, not after the fact.

---
### Entry � 2026-11-11
**Commit reference:** `e83d9cd (HEAD -> main, origin/main, origin/HEAD) [DEBUG] WIP clock process and IDLE transition, not compiling yet`

**What I implemented or decided:**
Together with my group we started writing the main process of the FSM: a clocked part with the reset and a counter, and the first transition from IDLE to WAIT_PASSWORD when front_sensor = '1'. The code is a work in progress and does not compile yet.

**Why I structured it this way:**
We wanted to start from the clock and reset, since every other part of the FSM depends on them, and then add the transitions state by state.

**What I am not sure about:**
Whether the state register and the next-state logic should be in the same process or in separate ones. How the reset should be written to be asynchronous and active low.

**What the simulation or hardware told me I was wrong about:**
Not compiled or simulated yet.

### Entry � 2026-11-11
**Commit reference:** `d34d509`

**What I implemented or decided:**
I wrote the entity exactly as given in the handout (clock, asynchronous active-low reset, the two sensors, the two 2-bit password inputs, the two LEDs and the two 7-segment outputs). I started the architecture by declaring the FSM states as an enumerated type (IDLE, WAIT_PASSWORD, WRONG_PASS, RIGHT_PASS, STOP) and two signals, current_state and next_state.

**Why I structured it this way:**
The entity had to match the specification exactly. I used an enumerated type instead of coding the states in binary myself, so the synthesis tool chooses the state encoding. I used two state signals to keep the present state (memory) separate from the future state (combinational logic), as in the FSM structure seen in class.

**What I am not sure about:**
-

**What the simulation or hardware told me I was wrong about:**
No simulation yet.

### Entry � 2026-11-11
**Commit reference:** `<!-- paste: git log --oneline -1 -->`

**What I implemented or decided:**
<!-- 2�4 sentences. Be specific about architecture choices. -->

**Why I structured it this way:**
<!-- What alternatives did you consider? Why did you reject them? -->

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
