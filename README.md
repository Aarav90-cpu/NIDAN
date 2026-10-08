# NIDAN

## Adaptive, Offline-First Learning Infrastructure

> **Learning should adapt to the child.**

NIDAN is an open-source education platform designed to help students learn according to their current level of understanding while giving teachers practical insight into what their classroom needs next.

It is being developed with a software-first approach, with a long-term vision for affordable Linux-based student and classroom hardware.

---

# The Problem

A classroom rarely contains students with exactly the same level of understanding.

One student may already understand a concept.

Another may understand only the basics.

Another may have missed a prerequisite several chapters earlier.

Yet all three may receive the same worksheet, the same lesson and the same pace of instruction.

Teachers have limited time and cannot manually analyze every student's learning state every day.

The problem is therefore not simply access to educational material.

The problem is:

> **How do we identify what a student actually understands and help determine what they should learn next?**

---

# Our Approach

NIDAN is built around a continuous learning loop:

```text
Assess
   ↓
Identify Level
   ↓
Assign
   ↓
Practice
   ↓
Measure
   ↓
Adapt
   ↓
Repeat
```

Instead of treating every learner identically, NIDAN aims to identify differences in understanding and provide appropriate next steps.

---

# For Students

NIDAN is designed to provide:

* diagnostic assessments,
* level-based learning,
* assignments,
* interactive activities,
* feedback,
* personal progress tracking,
* learning roadmaps,
* downloadable notes and educational resources,
* offline access to core learning material.

Students are not publicly ranked against one another.

The emphasis is on **individual progress**.

Example:

```text
Mathematics

Last week: 54%
This week: 71%

Improvement: +17%
```

---

# For Teachers

NIDAN is designed to help teachers understand their classroom at a useful level of detail.

Instead of simply showing marks, the teacher interface can organize students around learning needs.

Example:

```text
Fractions

Group A
Ready for challenge

Group B
Developing

Group C
Needs foundational practice
```

Teachers can eventually use NIDAN to:

* identify common weak concepts,
* create assignments,
* organize learning groups,
* review student submissions,
* monitor progress,
* identify common misconceptions,
* queue and manage student doubts,
* plan follow-up activities.

NIDAN is intended to **assist teachers, not replace them**.

---

# Offline First

NIDAN is designed for environments where internet access may be unreliable or unavailable.

Core learning functionality should remain available locally.

```text
Student Device
      │
      ▼
 Local Database
      │
      ▼
 NIDAN Core
      │
      ▼
 Student Interface

       Network
          │
          ▼
     Synchronization
```

The goal is for the system to continue working offline and synchronize changes when connectivity becomes available.

This also makes local content distribution possible without requiring every student to repeatedly download the same material from the internet.

---

# Technology

NIDAN is intentionally built around a relatively small technology stack.

| Layer                      | Technology            |
| -------------------------- | --------------------- |
| Core language              | Swift                 |
| Student/Teacher UI         | SwiftCrossUI          |
| Backend                    | Swift + Vapor         |
| Local database             | SQLite                |
| Server database            | PostgreSQL            |
| Operating system direction | Debian-based Linux    |
| Package management         | Swift Package Manager |
| System scripting           | Bash                  |

NIDAN's domain and learning logic are kept independent from the UI framework.

That means:

```text
Nidan Core
      ↓
Application Layer
      ↓
Presentation Layer
      ↓
SwiftCrossUI
```

SwiftCrossUI is currently a work-in-progress project, so NIDAN isolates it to the presentation layer rather than making the entire system dependent on it.

---

# Architecture

The current conceptual architecture is:

```text
┌─────────────────────────────┐
│        NIDAN UI             │
│       SwiftCrossUI          │
└──────────────┬──────────────┘
               │
┌──────────────▼──────────────┐
│     Application Layer       │
└──────────────┬──────────────┘
               │
┌──────────────▼──────────────┐
│        NIDAN CORE           │
│                             │
│ Learning                    │
│ Assessment                  │
│ Assignments                 │
│ Progress                    │
│ Content                     │
│ Student Models              │
└───────┬──────────────┬──────┘
        │              │
        ▼              ▼
     SQLite         Sync Layer
                       │
                       ▼
                    Network
                       │
                       ▼
                    NIDAN API
                       │
                       ▼
                   PostgreSQL
```

The exact implementation may evolve as development progresses.

---

# Project Structure

The intended repository structure is:

```text
NIDAN/
├── AGENTS.md
├── ABOUT.md
├── README.md
├── LICENSE
├── CONTRIBUTING.md
│
├── docs/
│   ├── architecture/
│   ├── product/
│   ├── education/
│   ├── security/
│   ├── deployment/
│   ├── hardware/
│   ├── testing/
│   └── adr/
│
├── os/
│   ├── base/
│   ├── packages/
│   ├── config/
│   ├── services/
│   └── image/
│
├── Packages/
│   ├── NidanModels/
│   ├── NidanCore/
│   ├── NidanLearning/
│   ├── NidanAssessment/
│   ├── NidanAssignments/
│   ├── NidanStorage/
│   ├── NidanSync/
│   ├── NidanNetworking/
│   └── NidanUI/
│
├── Apps/
│   ├── NidanStudent/
│   └── NidanTeacher/
│
├── Server/
│   └── NidanServer/
│
├── Content/
│   ├── curriculum/
│   ├── subjects/
│   ├── lessons/
│   ├── assessments/
│   └── assets/
│
├── Tests/
└── Scripts/
```

Some directories may not exist yet during early development.

The structure represents the intended architecture, not a claim that every component is already implemented.

---

# Development Roadmap

## Phase 1 — Documentation and Planning

Define the project before building it.

* Architecture
* Requirements
* Learning model
* Assessment model
* Data model
* Security and privacy
* Offline architecture
* Synchronization
* API design
* T1/T2 reference specifications
* AI-agent rules
* Testing strategy

---

## Phase 2 — Linux Base

Build the initial NIDAN environment on a Debian-based Linux foundation.

Goals include:

* reliable boot,
* basic hardware support,
* networking,
* storage,
* graphics,
* input,
* minimal user environment,
* repeatable system image creation.

---

## Phase 3 — NIDAN Core and Application Base

Build the actual application foundation.

This includes:

* domain models,
* learning engine,
* assessment system,
* assignment system,
* progress model,
* local persistence,
* synchronization foundation.

Swift is the primary language.

SwiftCrossUI is used for the presentation layer.

---

## Phase 4 — Full Frontend

### Student

* Dashboard
* Diagnostic
* Learning activities
* Assignments
* Feedback
* Progress
* Roadmap
* Library
* Offline content

### Teacher

* Dashboard
* Student overview
* Learning groups
* Assignment creation
* Submission review
* Skill-gap view
* Doubt queue

---

## Phase 5 — Backend

Build the networked infrastructure.

Expected components include:

* authentication,
* authorization,
* API,
* student synchronization,
* assignments,
* submissions,
* progress,
* content,
* device coordination.

The backend is intended to use Swift and Vapor.

---

## Phase 6 — NIDAN V2

Only after V1 is reliable.

Potential improvements include:

* richer adaptive learning,
* improved skill graphs,
* more advanced recommendations,
* interactive simulations,
* classroom activities,
* stronger content tooling.

---

## Phase 7 — Communication

A controlled school-focused communication system may eventually be added.

This is deliberately not a core V1 priority because child safety, moderation and privacy requirements make communication a substantially larger system than ordinary messaging.

---

## Phase 8 — New Features

Potential future areas:

* multilingual learning,
* accessibility improvements,
* coding education,
* simulations,
* project-based learning,
* classroom collaboration,
* offline classroom infrastructure,
* device management,
* local content caching.

---

## Phase 9 — Stabilization

Feature freeze.

Focus on:

* reliability,
* performance,
* UI consistency,
* documentation,
* cleanup,
* error handling,
* deployment.

---

## Phase 10 — Testing and Validation

Test:

* core logic,
* frontend,
* backend,
* offline operation,
* synchronization,
* network failure,
* data integrity,
* security,
* performance,
* low-end hardware.

The final goal is not merely to demonstrate that the application can run.

The goal is to demonstrate that it can **reliably solve the intended problem**.

---

## Phase 11 — RYIC Preparation

Prepare:

* project presentation,
* technical architecture,
* demonstration script,
* FAQs,
* limitations,
* measured results,
* implementation evidence,
* deployment roadmap.

The project should clearly distinguish between:

**Built**

**Tested**

**Planned**

**Long-term**

---

# T1 — Future Student Device

T1 is the working name for a future low-cost Linux-capable student device designed specifically around NIDAN.

The long-term design goals are:

* low cost,
* low power consumption,
* durability,
* repairability,
* long lifecycle,
* offline-first operation,
* Linux support,
* educational deployment.

The original target of approximately ₹1,000 is a long-term engineering target.

It is not a claim about the current cost of a manufactured device.

The long-term objective is to optimize **lifetime cost per student**, potentially through repair, component replacement and device reassignment.

---

# T2 — Future Classroom Hub

T2 is the working name for a future classroom hub.

Its intended responsibilities include:

* connecting T1 devices,
* providing local content,
* synchronizing classroom data,
* supporting teacher workflows,
* running classroom activities,
* connecting to an existing display or projector.

The original ₹2,000 target is also a long-term engineering target that requires hardware validation.

---

# Open Source

NIDAN is intended to be developed as an open-source project.

The project aims to keep:

* software,
* architecture,
* documentation,
* interfaces,
* and appropriate hardware specifications

as open and reproducible as practical.

Third-party dependencies and hardware components must remain subject to their respective licenses and distribution restrictions.

See:

* `LICENSE`
* `CONTRIBUTING.md`
* `AGENTS.md`

for project policies.

---

# Project Status

NIDAN is currently an active development project.

The current priority is the software foundation and the first working learning loop.

The project does **not** currently claim that:

* a mass-produced T1 device exists,
* a mass-produced T2 classroom hub exists,
* a national deployment exists,
* measured nationwide learning improvements exist,
* the ₹1,000 or ₹2,000 targets have been achieved.

Those are future engineering and deployment goals.

---

# Design Principles

NIDAN follows several core principles:

### 1. Learning before features

A feature should contribute meaningfully to learning, teaching, accessibility, reliability or infrastructure.

### 2. Offline first

The system should remain useful without continuous internet access.

### 3. Student progress over public ranking

Students should primarily compete with their previous performance.

### 4. Teacher assistance over teacher replacement

The system should provide information and reduce repetitive work while leaving educational decisions with teachers.

### 5. Small, reliable systems

Prefer a feature that works correctly over ten impressive features that barely function.

### 6. Honest engineering

Documentation and demonstrations must match what the project actually does.

### 7. Long-term maintainability

NIDAN should be capable of running on modest hardware and remain understandable to future developers.

---

# Why NIDAN Exists

The ambition behind NIDAN is larger than an application.

The long-term vision is an education infrastructure where:

```text
Every student
      ↓
can access learning
      ↓
at an appropriate level
      ↓
with or without constant internet
      ↓
while teachers receive useful information
      ↓
and devices remain affordable and maintainable.
```

The immediate task is much smaller:

> Build the first working version, measure it honestly, learn from the results, and improve it.

That is where NIDAN begins.

---

# AI Development

NIDAN is developed with assistance from AI coding agents.

All AI agents working on the repository must read:

```text
AGENTS.md
```

Project context is documented in:

```text
ABOUT.md
```

AI agents must preserve working code, avoid unnecessary changes, avoid hallucinated claims, keep architecture boundaries intact, and report verification honestly.

---

# Contributing

Contributions are welcome when they improve the actual project.

Before contributing:

1. Read `AGENTS.md`.
2. Read relevant documentation.
3. Understand the existing architecture.
4. Keep changes focused.
5. Add relevant tests.
6. Update documentation when necessary.
7. Do not introduce unnecessary dependencies or unrelated features.

See `CONTRIBUTING.md` for the complete contribution process.

---

# License

See `LICENSE` for the project's licensing terms.
