# The Adaptive Agent

This document defines the behavior of NIDAN's core adaptive learning engine. 

## V1 Philosophy: Deterministic Before Generative
Do **not** start with a giant language model. The initial adaptive engine will be fully deterministic, based on statistical thresholds and the predefined Prerequisite Graph (DAG). This ensures predictable, testable, and offline-capable progression. More sophisticated machine learning models can be introduced in later phases to augment these deterministic rules.

## The Adaptive Pipeline

Every interaction a student has with the system flows through this pipeline:

1. **Assessment:** The student completes an exercise, quiz, or diagnostic.
2. **Skill Inference:** The system evaluates the result against the specific skill(s) tagged to that assessment.
3. **Student Level Calculation:** The student's overall level and specific skill mastery states are recalculated based on the new data point.
4. **Recommended Activity:** The system uses the updated state and the Prerequisite Graph to determine the next best learning node.
5. **Result:** The student attempts the recommended activity.
6. **Updated Skill State:** The loop repeats, feeding the result back into Step 1.

## Deterministic Thresholds (V1)

The initial version of the engine will use simple score-based thresholds to route students to the appropriate activity type for a given skill.

| Recent Score Average | Inferred State | Recommended Activity Type |
|----------------------|----------------|---------------------------|
| **< 40%** | Struggling | **Foundational Activity** (Remediation on prerequisite concepts, visual breakdowns, step-by-step tutorials) |
| **40% - 70%** | Partial Mastery (Low) | **Guided Practice** (Exercises with heavy hinting, scaffolding, and immediate error correction) |
| **70% - 90%** | Partial Mastery (High)| **Standard Practice** (Standard assessment questions to build fluency and confidence) |
| **90%+** | Mastery | **Challenge / Next Skill** (Complex word problems, synthesis tasks, or unlocking the next node in the prerequisite graph) |

## Future Enhancements
Once the deterministic engine is stable and measurable, we can introduce more sophisticated intelligence, such as:
- **Bayesian Knowledge Tracing (BKT)** to more accurately model the probability that a student has learned a skill.
- **Item Response Theory (IRT)** to weight questions based on historical difficulty rather than a flat percentage.
