# NIDAN — Project Context

## What is NIDAN?

NIDAN is adaptive, offline-first learning infrastructure built to address this: **How do we identify what a student understands and help determine what they should learn next?**

The system continuously assesses, adapts, and personalizes learning based on each student's current level of understanding.

---

## Why Offline-First?

Many school environments lack reliable internet. NIDAN's core learning functionality must work without it.

```
Local Data → Core Logic → UI

Sync (when available) ↔ Server
```

---

## Architecture Overview

```
NidanCore
  ├─ Learning
  ├─ Assessment
  ├─ Assignments
  ├─ Progress
  ├─ Content
  └─ Student Models
       ↓
Application Layer
       ↓
SwiftCrossUI (Presentation)
       ↓
SQLite (Local) + PostgreSQL (Server)
```

**Critical rule:** Core logic never depends on the UI framework.

---

## Technology Choices

- **Language:** Swift (primary)
- **Frontend:** SwiftCrossUI (cross-platform UI)
- **Backend:** Swift + Vapor
- **Local Storage:** SQLite
- **Server Database:** PostgreSQL
- **OS:** Debian-based Linux
- **Build:** Swift Package Manager
- **System Scripts:** Bash

These are locked unless explicitly changed.

---

## T1 and T2

**T1 — Student Device:** Low-cost, durable, Linux-capable device. Target: ₹1,000 lifetime cost (engineering goal, not current claim).

**T2 — Classroom Hub:** Connects T1 devices, provides local content, manages sync. Target: ₹2,000 (long-term goal).

---

## Repository Structure

```
NIDAN/
├── docs/              (Architecture, product, education, security)
├── OS/                (Linux base, Debian customization)
├── Packages/          (Swift packages for core)
├── Apps/              (Student and teacher applications)
├── Server/            (Backend services)
├── Content/           (Curriculum, assessments, lessons)
├── Tests/
└── Scripts/
```

---

## Key Principles

1. Preserve working code
2. Make smallest safe changes
3. Keep architecture boundaries clear
4. Prioritize learning outcomes
5. Respect student privacy and safety
6. Be honest about what exists vs. what's planned
7. No unnecessary dependencies or complexity

---

## For AI Agents

All AI agents working on this repository must read and follow `AGENTS.md`.

Key rules:
- Understand existing code before changing it
- Preserve architecture boundaries
- Do not optimize working code unnecessarily
- Never claim something works without evidence
- Keep changes focused and minimal
- Do not hallucinate completed work
- Be honest about limitations

---

## Current Development Focus

Phase 1 (Documentation) and Phase 2 (Linux Base) are active priorities.

The goal is a working, measurable education prototype before focusing on hardware engineering.

See `PLAN.md` for detailed roadmap.
