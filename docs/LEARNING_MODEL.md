# The Learning Model

This document defines the core pedagogical taxonomy and state machine that drives NIDAN's adaptive learning engine.

## Taxonomy

### Concept
A **Concept** is a foundational idea, theory, or factual understanding. It is the "why" or "what." 
*Example: Understanding that a fraction represents a part of a whole, where the denominator is the total number of equal parts.*

### Skill
A **Skill** is the practical, measurable application of a Concept. It is the "how." A skill can be directly assessed through questions or interactive exercises.
*Example: Adding two fractions with the same denominator.*

### Prerequisite Relationships
Skills and Concepts do not exist in isolation. They form a **Directed Acyclic Graph (DAG)** of prerequisite relationships. A student cannot effectively learn a target skill if they have not mastered its prerequisites.

```
Fractions (Concept)
   │
   ├── Numerator (Concept)
   ├── Denominator (Concept)
   ├── Equivalent fractions (Skill)
   │
   └── Operations (Skill)
          │
          └── Algebra prerequisites (Concept)
```

---

## Student States

### Student Levels
A **Student Level** is a fluid, continuous measurement of a student's capability within a specific subject domain. It is intentionally decoupled from traditional age-based "grades" or "standards." A student may be Level 5 in Geometry but Level 2 in Algebra.

### Mastery
**Mastery** indicates that a student can consistently and correctly apply a skill with high confidence (e.g., >90% success rate over a series of varied assessments). Mastered skills serve as stable foundations for new prerequisites.

### Partial Mastery
**Partial Mastery** indicates inconsistent application. The student understands parts of the concept but frequently makes procedural or conceptual errors (e.g., 40% - 89% success rate). They require guided practice, not necessarily a full reteaching of the concept.

### Struggling State
The **Struggling State** indicates that the student consistently fails to apply the skill (e.g., <40% success rate). This usually points to a fundamental misunderstanding or a missing prerequisite, rather than just needing "more practice" on the current skill.

### Assessment Confidence
**Assessment Confidence** is the system's statistical certainty regarding a student's mastery state. A single lucky guess does not prove Mastery, and a single careless mistake does not mean the student is Struggling. Confidence increases as the system gathers more data points over time.

---

## The Adaptive Engine (Rules)

NIDAN's adaptive engine uses the states defined above to determine what the student should see next.

### Progression Rules
If a student achieves **Mastery** with high **Assessment Confidence** in a skill, the system automatically unlocks the next skills in the prerequisite graph and recommends them as the next learning pathway.

### Remediation Rules
If a student enters a **Struggling State**, the system halts progression on that branch. Instead of assigning more of the same failing exercises, the engine traverses backward down the prerequisite graph to reassess foundational concepts until it finds the root gap in understanding.

### Advancement Rules
Advancement occurs when a student masters a predefined cluster of related skills (a "Unit" or "Module"). The system acknowledges this milestone and transitions the student's overall **Student Level**, altering the global pool of available content.

### Reassessment Rules (Spaced Repetition)
Mastery degrades over time (the forgetting curve). The system periodically injects lightweight assessment questions for previously **Mastered** skills into current assignments. If a student fails a reassessment, the skill degrades to **Partial Mastery**, triggering a brief review cycle.
