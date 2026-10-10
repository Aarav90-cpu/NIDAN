# Project Scope

## V1 Scope (Software Foundation)
The primary objective of V1 is to build a convincing, measurable education prototype that establishes a working offline-first learning loop.
- **Platform:** x86_64 Debian-based Linux environment.
- **Core Loop:** Assess → Identify Level → Assign → Practice → Measure → Adapt.
- **Stack:** Swift (Core & Backend), SwiftCrossUI (Frontend), SQLite (Local Storage).
- **Features:**
  - Diagnostic assessments.
  - Level-based learning paths.
  - Basic offline synchronization logic.
  - Teacher dashboard for classroom progress.
  - Student dashboard for individual progress.

## Current Implementation Status

The repository contains a local SQLite/Vapor prototype with role-bound enrollment codes, sessions, a Grade 9 Number Systems diagnostic, student/teacher/vice-principal/principal views, class-scoped assignments and paper hand-ins, school marks, chapter coverage, notices, and a teacher doubt queue. A separate static content-serving executable is present.

This does not mean Phase 5 is complete. Device-side offline storage and sync retry/conflict handling, roster-verified identity, PostgreSQL deployment, production operations, and real school authorization/privacy review remain incomplete. The current demo records are synthetic and opt-in.

## V2 Scope (Expansion & Stabilization)
- **Platforms:** Expansion to Android (Kotlin) for broader accessibility.
- **Networking:** Introduction of WebSocket for real-time communication in connected environments.
- **Features:** 
  - Advanced adaptive AI agent for learning paths.
  - Deeper teacher workflows and assignment generation.
  - Stabilization and testing across varied network conditions.

## Long-Term Scope (Hardware & Deployment)
- **Hardware Integration:** Migration to the custom NIDAN OS image.
- **T1 Student Device:** Mass-produced, low-cost, durable Linux device designed for students (target: ~₹1,000 lifetime cost).
- **T2 Classroom Hub:** Local classroom server providing content, synchronization, and teacher workflows (target: ~₹2,000).
- **Deployment:** National rollout and measured learning improvements in active classrooms.
