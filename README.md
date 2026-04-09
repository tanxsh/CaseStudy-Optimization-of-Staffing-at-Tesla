# Optimization of Support Staffing at Tesla

**Minimizing Weekly Operating Costs for Tesla's Post-Sales Support Center Using Linear Programming**

Course: ISBA 2400 — Mathematics for Business and Analytics with R | Santa Clara University  

---

## Overview

Tesla's Palo Alto headquarters faces rising call volumes and increasing wait times in its post-sales software support center. This project builds a **linear programming (LP) optimization model in R** to determine the minimum-cost staffing plan that meets all incoming call demand across a full operating day, subject to language, shift, and agent-type constraints.

---

## Problem Setup

**Objective:** Minimize total weekly operating costs while ensuring all incoming calls are answered

**Key Parameters:**
- Service rate: 6 calls per agent per hour
- Call mix: 80% English, 20% Spanish
- Standard wage: $30/hour (pre-5 PM), Evening wage: $45/hour (post-5 PM)
- Agent types: Full-Time (FT, 8-hour shifts, 4 hours on calls) and Part-Time (PT, 4-hour shifts, calls only)
- PT agents handle English calls only; Spanish calls require FT agents

**Demand** for each 2-hour slot is calculated as:

```
D(t) = ⌈ Call Volume(t) × Language % / 6 ⌉
```

---

## Three Optimization Scenarios

### Part I — Separate Language Pools
English and Spanish queues staffed independently.

| Shift | FT English | FT Spanish | PT |
|---|---|---|---|
| 7AM–9AM | 18 | 5 | 0 |
| 9AM–11AM | 5 | 2 | 0 |
| 11AM–1PM | 1 | 2 | 0 |
| 1PM–3PM | 2 | 1 | 0 |
| 3PM–5PM | 0 | 0 | 4 |
| 5PM–7PM | 0 | 0 | 0 |

**Minimum Cost: $5,100**

---

### Part II — Restricted Availability
One FT English agent willing to start at 1PM, one at 3PM — model finds an alternative optimal plan.

**Minimum Cost: $5,100** *(unchanged — model found an equivalent solution by swapping shift assignments)*

---

### Part III — Bilingual Staffing
Merges English and Spanish demand into a single pool; all agents handle any call.

| Scenario | Total Agents | Minimum Cost |
|---|---|---|
| Separate Pools | 40 (30 Eng + 10 Span) | $5,100 |
| Bilingual Pool | 37 | $4,680 |

**Net savings: $420 per week**

**Breakeven wage premium:** Tesla can offer bilingual agents up to a **9% hourly wage increase** without exceeding the separate-pool budget — making bilingual recruitment financially viable.

---

## Methodology

- Constraint matrix `A` built to represent agent availability across 2-hour slots and shift patterns
- FT agents follow two alternating patterns (Pattern A: calls first; Pattern B: tasks first) to maximize coverage flexibility
- LP model solved using the `lpSolve` package in R
- Three scenarios modeled with progressively relaxed/modified constraints

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| R | Linear programming model implementation |
| lpSolve | LP solver package |
| Constraint matrix formulation | Shift coverage modeling |

---

## Repository Structure

```
├── Tesla_Staffing_Optimization.r   # Full LP model: all three scenarios
├── Final_Report.pdf                # Group project report with results and recommendations
└── README.md
```

---

## Recommendations

**Short Term:** Implement the restricted availability staffing plan (Part II) — it costs the same as the unrestricted optimum ($5,100) while respecting current employee constraints.

**Long Term:** Aggressively recruit bilingual agents. The model proves Tesla can increase hourly wages by up to 9% to attract bilingual talent while keeping total costs at or below the current budget — eliminating the Spanish-language bottleneck entirely.
