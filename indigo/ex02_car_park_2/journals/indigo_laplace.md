# Journal � Exercise 2 � Car Park 2

> **You:** `indigo_laplace` � **Group:** `indigo` � **Opened:** 2026-11-11
> The code in this folder is shared with your group. **This journal is yours alone.**
> Write entries as you work, not after the fact.

---

## Decision log

### Entry � 2026-11-11
**Commit reference:** eb3cdab

**What I implemented or decided:**
- Added the required libraries and redifined some things (like the declaration of some missed signals, reordered the function and the concurrent assignments inside the architecture but outside the process and completed the synchronous updates and asynchronous resets for all gates)
- Added a concurrent or assignment “payment_request”  and added the respective signals for payment_request_Gout1 and Gout2→ (payment_request <= payment_request_Gout1 or payment_request_Gout2;)that permits to differentiate from one barrier and another (like the one of the accepted payment)
- Implemented the Gout1 and Gout2 state transitions processes

**Why I structured it this way:**
- Some signals missed a declaration so the design would not compile. 
All the states and signals hadn’t a state transition when the reset was on and that would cause a problem since their states would be left undefined upon reset and clock edges.
- I inserted the payment_request combinatorial assignment in order to not cause a conflict as it could have been if 1 pays for the exit but the system can’t decide which one of the two exits is.
- I followed the map on the lab handout, with one deliberate addition:  asserting barrier_Gout1<= '1'; (and the respective one for gout2) in the PAYMENT_OK states in order to open the barrier and let the car pass (that will mean that the sensor B can go from 0 to 1)… I wasn’t sure about that since in the pdf this change is omitted, but in the tb provided the sensor B goes to 1 only if the car pass (and so only if the barrier opens) so that is the only way.

**What I am not sure about:**
- Whether is correct to use an elsif statement to update the count of the cars on the parking since if, ipothetically, two cars enter or exit at the same exact time the system would count only 1 of them. (I didn’t change anything about this structure yet since I want to ask about it).

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
