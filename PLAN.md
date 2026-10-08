# NIDAN Development Roadmap

## Technology Stack (Locked)

| Area | Choice |
|------|--------|
| Language | Swift |
| UI | SwiftCrossUI |
| Backend | Swift + Vapor |
| Local DB | SQLite |
| Server DB | PostgreSQL |
| OS | Debian 13 (Linux) |
| Build | Swift Package Manager |
| Scripts | Bash |

**Why Debian?** Stable, long-term support, broad hardware support, Linux LTS kernel.

**SwiftCrossUI Rule:** Must never own NIDAN's business logic. UI is replaceable; core is not.

---

## Phase 1 — Documentation & Planning

Goal: Define the system before building it.

Create architecture documents covering:
- Vision, problem, requirements, scope
- Learning model, assessment model, data model
- Offline-first and sync architecture
- API design, security, privacy
- Agent development rules

Create Architecture Decision Records (ADRs) for every major choice.

**Exit Gate:** Architecture frozen, V1 scope locked, tech stack finalized, agent rules established.

---

## Phase 2 — Linux Base

Goal: Reliable Debian-based NIDAN environment.

Build:
- Bootable Debian 13 system
- Hardware support (network, audio, graphics, input)
- System services (device, sync, content, update)
- Repeatable image creation
- NIDAN boot experience (not traditional desktop)

**Exit Gate:** Boots reliably, network/storage work, image is repeatable.

---

## Phase 3 — NIDAN Core & Application

Build domain layer:
- Student, Teacher, Class, Subject, Course models
- Skill and concept hierarchies
- Assessment system
- Assignment system
- Progress tracking
- Local persistence (SQLite)
- Offline sync

Swift packages:
```
NidanCore (never imports UI)
├── NidanModels
├── NidanLearning
├── NidanAssessment
├── NidanAssignments
├── NidanStorage
└── NidanSync
```

**Exit Gate:** App launches, local DB works, basic offline flow complete.

---

## Phase 4 — Full Frontend

### Student UI
- Dashboard (today's learning, progress, pending work)
- Diagnostic assessments
- Learning activities with explanations
- Assignments and submissions
- Progress tracking (personal, not ranking)
- Learning roadmap
- Offline content library
- Settings

### Teacher UI
- Class dashboard with skill overview
- Create assignments and learning groups
- View student submissions
- Identify learning gaps
- Doubt queue (students flag misconceptions)

**Exit Gate:** Complete flow works: diagnostic → level → activity → feedback → progress → next activity.

---

## Phase 5 — Backend Services

Build Swift + Vapor backend:

```
/api/v1/
├── auth/
├── students/
├── teachers/
├── classes/
├── skills/
├── assessments/
├── assignments/
├── submissions/
├── progress/
└── sync/
```

Implement:
- Authentication and authorization
- Device identity
- User/session management
- API versioning
- Synchronization protocol
- Security controls

Development: SQLite. Production: PostgreSQL.

---

## Phase 6 — NIDAN V2

After V1 is stable:
- Richer adaptive learning
- Improved skill graphs
- Advanced recommendations
- Interactive simulations
- Classroom collaboration

---

## Phase 7 — Communication (Later)

School-focused communication system requires dedicated safety, moderation, privacy work. Not V1.

---

## Phase 8 — New Features

Potential additions:
- Multilingual learning
- Accessibility improvements
- Coding education
- Project-based learning
- Offline classroom infrastructure

---

## Phase 9 — Stabilization

Feature freeze. Focus on:
- Reliability and performance
- UI consistency
- Documentation
- Error handling
- Deployment

---

## Phase 10 — Testing & Validation

Test everything:
- Core logic, frontend, backend
- Offline operation and sync
- Network failure scenarios
- Data integrity
- Security and performance
- Low-end hardware

**Goal:** Prove it reliably solves the intended problem.

---

## Phase 11 — RYIC Preparation

Prepare:
- Project presentation and architecture
- Demonstration script
- Measured results
- Deployment roadmap

Clearly distinguish: Built | Tested | Planned | Long-term

---

## Deployment Model (Later)

Eventually: Docker containers, Kubernetes orchestration, CDN for content distribution.

Early phases: Simple single-server deployment.

---

## Definition of Done

A feature is complete when:
```
Requirements + Implementation + Tests + Documentation + Review
```

Build and tests must pass. AI agents cannot verify this; users must.
