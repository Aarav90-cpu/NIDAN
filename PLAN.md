NIDAN --- MASTER DEVELOPMENT ROADMAP
==================================

### Adaptive, Offline-First Education Infrastructure

**Primary RYIC objective:** build a convincing, measurable education prototype first, then establish the engineering path toward T1/T2 hardware.

* * * * *

0\. THE STACK IS LOCKED
=======================

Before Phase 1, this is the technology policy we work under.

| Area | Technology | Decision |
| --- | --- | --- |
| Core application language | **Swift** | Primary |
| UI | **SwiftCrossUI** | Primary |
| Linux base | **Debian 13 "trixie"** | Primary |
| OS customization | Debian-derived custom image | Later |
| Backend | **Swift + Vapor** | Primary |
| Local database | **SQLite** | Primary |
| Production database | **PostgreSQL** | Later |
| API | HTTP/REST + JSON | V1 |
| Real-time communication | WebSocket | V2 |
| Local sync | Swift | Primary |
| Build system | Swift Package Manager | Primary |
| OS/build scripts | Bash | Primary |
| Low-level native code | C | Only when genuinely necessary |
| Benchmark/data tooling | Python | Optional tooling, not product core |
| Database language | SQL | Required |
| Config/data | JSON/YAML | Required |
| Documentation | Markdown | Required |
| Android | Kotlin | **V2/later only** |

### Why Debian?

**Debian 13 is the current stable Debian release**, and Debian lists security/LTS support through the lifecycle of the release. It also ships a Linux 6.12 LTS-series kernel and supports a broad range of architectures. ([Debian](https://www.debian.org/releases/index.en.html?utm_source=chatgpt.com "Debian -- Debian Releases"))

We are **not** building a Linux distribution from scratch.

The eventual architecture is:

```
Debian
   ↓
NIDAN system packages
   ↓
NIDAN services
   ↓
NIDAN session
   ↓
NIDAN student environment
```

So:

> **Debian-based first. Custom NIDAN OS image later.**

* * * * *

IMPORTANT: SWIFTCROSSUI RULE
============================

SwiftCrossUI is a very interesting fit because it provides a SwiftUI-like cross-platform declarative API and currently supports Linux through its GTK backend. However, the project explicitly describes itself as a work in progress. ([GitHub](https://github.com/moreSwift/swift-cross-ui "GitHub - moreSwift/swift-cross-ui: A cross-platform declarative UI framework, inspired by SwiftUI. - GitHub"))

Therefore:

> **SwiftCrossUI may own the UI. It must never own NIDAN's business logic.**

Architecture:

```
NIDAN CORE
    │
    ├── Learning
    ├── Assessments
    ├── Assignments
    ├── Progress
    ├── Sync
    ├── Content
    └── User models
          │
          ▼
     NIDAN UI API
          │
          ▼
     SwiftCrossUI
          │
     ┌────┼─────┐
     ▼    ▼     ▼
   Linux Windows other
```

If SwiftCrossUI changes underneath us, we replace the UI adapter, **not the entire application**.

Swift itself is officially supported on Debian, so the underlying language choice is viable for the platform. ([Swift.org](https://www.swift.org/platform-support/?utm_source=chatgpt.com "Platform Support | Swift.org"))

* * * * *

PHASE 1 --- DOCUMENT EVERYTHING
=============================

Goal
----

**No serious coding until the system has a written architecture.**

The repository starts as a specification repository with almost no application code.

### 1.1 Project identity

-   Project name: NIDAN

-   One-line description

-   Vision statement

-   Mission statement

-   Problem statement

-   Target beneficiaries

-   Target deployment environment

-   RYIC positioning

-   V1 scope

-   V2 scope

-   Long-term scope

### 1.2 Core documentation

Create:

```
docs/
├── VISION.md
├── PROBLEM.md
├── REQUIREMENTS.md
├── SCOPE.md
├── ARCHITECTURE.md
├── PRODUCT.md
├── STUDENT_EXPERIENCE.md
├── TEACHER_EXPERIENCE.md
├── LEARNING_MODEL.md
├── ASSESSMENT_MODEL.md
├── ASSIGNMENT_MODEL.md
├── CONTENT_MODEL.md
├── OFFLINE_FIRST.md
├── SYNC_PROTOCOL.md
├── NETWORK_ARCHITECTURE.md
├── SECURITY.md
├── PRIVACY.md
├── DATA_MODEL.md
├── API.md
├── DEVICE_REFERENCE.md
├── T1.md
├── T2.md
├── DEPLOYMENT.md
├── TESTING.md
├── PERFORMANCE.md
├── ACCESSIBILITY.md
├── LOCALIZATION.md
├── CONTRIBUTING.md
├── GLOSSARY.md
└── adr/
```

### 1.3 Architecture Decision Records

Every major decision gets an ADR.

Examples:

```
ADR-001 Debian over Arch
ADR-002 Swift as primary language
ADR-003 SwiftCrossUI for frontend
ADR-004 SQLite for local storage
ADR-005 Vapor for backend
ADR-006 Offline-first architecture
ADR-007 REST before WebSockets
ADR-008 Core independent from UI
```

This prevents:

> "Why did we choose this?"

six months later followed by seventeen developers staring at the ceiling.

* * * * *

1.4 DEFINE THE LEARNING MODEL
=============================

Before implementing adaptive learning:

-   Define what a **skill** is

-   Define what a **concept** is

-   Define prerequisite relationships

-   Define student levels

-   Define mastery

-   Define partial mastery

-   Define struggling state

-   Define assessment confidence

-   Define progression rules

-   Define remediation rules

-   Define advancement rules

-   Define reassessment rules

Example:

```
Fractions
   │
   ├── Numerator
   ├── Denominator
   ├── Equivalent fractions
   │
   └── Operations
          │
          └── Algebra prerequisites
```

* * * * *

1.5 PLAN THE AI/ADAPTIVE AGENT
==============================

Do **not** start with a giant language model.

First define:

```
Assessment
    ↓
Skill inference
    ↓
Student level
    ↓
Recommended activity
    ↓
Result
    ↓
Updated skill state
```

The first adaptive engine can be deterministic.

Example:

```
score < 40%
    → foundational activity

40--70%
    → guided practice

70--90%
    → standard practice

90%+
    → challenge
```

Later we can make the intelligence more sophisticated.

* * * * *

1.6 CREATE `AGENTS.md`
======================

This is critical.

The coding agent gets rules.

### Agent must:

-   Read `AGENTS.md`

-   Read relevant architecture docs

-   Inspect existing code before changing it

-   Follow module boundaries

-   Keep Core independent from UI

-   Write tests for behavioral changes

-   Run tests after changes

-   Run build checks

-   Avoid unnecessary dependencies

-   Prefer existing project abstractions

-   Update documentation when architecture changes

-   Make small commits

-   Explain breaking changes

-   Preserve public APIs unless explicitly instructed

### Agent must never:

-   Rewrite the whole project because one function is ugly

-   Add dependencies without justification

-   Invent APIs that do not exist

-   Put business logic inside Views

-   Put database logic inside Views

-   hardcode student data

-   commit secrets

-   silently change architecture

-   delete tests to make builds pass

-   blindly trust generated code

-   mix unrelated refactors into feature work

### Definition of done

A task is not done until:

```
Code
 +
Tests
 +
Build
 +
Documentation
 +
Review
```

* * * * *

PHASE 1 EXIT GATE
=================

Phase 1 is complete when:

-   Architecture is written

-   V1 scope is frozen

-   Tech stack is frozen

-   Learning model exists

-   Data model exists

-   Agent rules exist

-   Repository structure exists

-   Test strategy exists

-   Security/privacy principles exist

-   T1/T2 future architecture exists

Only then:

CODE.
=====

* * * * *

PHASE 2 --- BUILD THE BASE: NIDAN LINUX
=====================================

Objective
---------

Create a **minimal Debian-based NIDAN environment**.

### 2.1 Base Linux

-   Debian 13 base

-   x86_64 target initially

-   UEFI boot

-   Kernel configuration

-   Firmware packages

-   networking

-   audio

-   graphics

-   input devices

-   power management

-   suspend/resume

-   storage mounting

-   user management

### 2.2 Desktop/session

Prototype:

```
Debian
 ↓
Wayland
 ↓
minimal session
 ↓
NIDAN
```

Do not build a custom compositor yet.

### 2.3 System services

Create:

```
nidan-device-service
nidan-sync-service
nidan-content-service
nidan-update-service
```

Initially these can be very small.

### 2.4 NIDAN boot experience

Eventually:

```
Power
 ↓
Bootloader
 ↓
Linux
 ↓
System services
 ↓
NIDAN
```

The student shouldn't be dumped into a traditional desktop and told:

> "Good luck, tiny human."

* * * * *

PHASE 2 EXIT GATE
=================

-   Boots reliably

-   Network works

-   Storage works

-   UI launches

-   NIDAN can run without a conventional desktop

-   System can be reset/recovered

-   Build process is repeatable

-   Image can be installed on another machine

* * * * *

PHASE 3 --- NIDAN APP BASE
========================

Now we build the application architecture.

Language: Swift
===============

UI: SwiftCrossUI
================

Package Manager: SwiftPM
========================

### Core packages

```
Packages/
├── NidanCore
├── NidanModels
├── NidanLearning
├── NidanAssessment
├── NidanAssignments
├── NidanStorage
├── NidanSync
├── NidanNetworking
└── NidanUI
```

### Core rule

`NidanCore` cannot import `SwiftCrossUI`.

Ever.

Architecture:

```
NidanCore
   ↑
NidanStorage
NidanNetworking
NidanSync
   ↑
NidanUI
   ↑
Student App
Teacher App
```

### 3.1 Build the domain layer

-   Student

-   Teacher

-   Class

-   Subject

-   Course

-   Skill

-   Concept

-   Assessment

-   Question

-   [Answer]

-   [Assignment]

-   [Submission]

-   [Progress

-   Mastery

-   Lesson

-   Content item

-   Download

-   Device

-   Sync state

### 3.2 Swift engineering

-   Swift 6.x toolchain policy

-   Strict concurrency

-   `Sendable` boundaries

-   Actor isolation strategy

-   Error model

-   Logging model

-   dependency injection

-   test clocks

-   deterministic tests

### 3.3 Local storage

SQLite:

```
students
subjects
skills
assessments
questions
assignments
submissions
progress
content
sync_state
settings
```

### 3.4 Offline architecture

The app must work without network.

```
UI
 ↓
Core
 ↓
Local DB
```

Network is an additional source:

```
Network
   ↓
Sync Engine
   ↓
Local DB
```

Not:

```
UI → Internet → Everything
```

* * * * *

PHASE 3 EXIT GATE
=================

-   App starts

-   Local DB works

-   Sample student exists

-   Sample course exists

-   Sample skill graph exists

-   Assessment can be stored

-   Assignment can be stored

-   Progress can be calculated

-   Entire basic flow works offline

* * * * *

PHASE 4 --- FULL FRONTEND
=======================

This is where NIDAN starts feeling alive.

STUDENT UI
==========

### Dashboard

-   Greeting

-   today's learning

-   progress

-   pending assignments

-   continue learning

-   recommendations

-   offline indicator

### Diagnostic

-   Start assessment

-   Questions

-   Answer selection/input

-   Progress indicator

-   Results

-   Skill classification

### Learning

-   Lessons

-   activities

-   interactive exercises

-   explanations

-   hints

-   retry

-   challenge mode

### Assignments

-   Assigned work

-   due status

-   submission

-   result

-   retry

### Progress

Never:

> "You are rank 31."

Instead:

```
Your progress

Last week → This week

Fractions
54% → 71%

Algebra
62% → 78%
```

### Roadmap

```
What you know
      ↓
What you're learning
      ↓
What's next
      ↓
Skills
      ↓
Projects
      ↓
Possible pathways
```

### Library

-   textbooks

-   notes

-   PDFs

-   local lessons

-   downloaded media

-   search

-   bookmarks

### Settings

-   language

-   accessibility

-   account

-   storage

-   downloads

-   device information

-   network status

* * * * *

TEACHER FRONTEND
================

This is equally important.

### Teacher dashboard

```
Class
 ↓
Skill overview
 ↓
Learning groups
 ↓
Assignments
 ↓
Student progress
```

### Teacher capabilities

-   View class

-   View skill gaps

-   Create assignment

-   assign activity

-   view submissions

-   create learning groups

-   monitor progress

-   access lesson material

-   verify answers

-   see struggling concepts

### Doubt queue

Student:

> "I don't understand this."

Teacher:

```
12 students struggling
    ↓
Linear equations
    ↓
Common misconception
```

This becomes one of the flagship features.

* * * * *

PHASE 4 EXIT GATE
=================

A student must be able to:

```
Open NIDAN
 ↓
Take diagnostic
 ↓
Get level
 ↓
Receive activity
 ↓
Complete activity
 ↓
Receive feedback
 ↓
Update progress
 ↓
Receive next activity
```

Teacher must be able to:

```
Open dashboard
 ↓
See class
 ↓
Identify groups
 ↓
Assign activity
 ↓
See responses
 ↓
Understand weak areas
```

* * * * *

PHASE 5 --- BACKEND
=================

Now we connect the system.

Backend
=======

**Swift + Vapor**

### Development

```
NIDAN
 ↓
Vapor
 ↓
SQLite
```

### Deployment

```
NIDAN
 ↓
Vapor
 ↓
PostgreSQL
```

### API structure

```
/api/v1/

auth/
students/
teachers/
classes/
subjects/
skills/
assessments/
questions/
assignments/
submissions/
progress/
content/
sync/
devices/
```

### Authentication

-   authentication model

-   device identity

-   user/session identity

-   authorization

-   teacher roles

-   student roles

-   school roles

-   token expiration

-   revocation

-   recovery

### API rules

-   version API

-   validate inputs

-   structured errors

-   request IDs

-   logging

-   rate limits

-   pagination

-   consistent JSON schema

-   backwards compatibility policy

* * * * *

SYNC ENGINE
===========

This is one of the most important technical pieces.

```
LOCAL DEVICE
     │
     │ changes
     ▼
SYNC QUEUE
     │
     ▼
NETWORK AVAILABLE?
   /\
 no         yes
 │           │
save       upload
locally      │
             ▼
          SERVER
             │
             ▼
       synchronize
```

Need to define:

-   sync IDs

-   timestamps

-   version numbers

-   conflict resolution

-   retry

-   partial sync

-   interrupted sync

-   offline recovery

* * * * *

PHASE 5 EXIT GATE
=================

-   Student can authenticate

-   Teacher can authenticate

-   Student data synchronizes

-   Assignments synchronize

-   Results synchronize

-   Progress synchronizes

-   Offline changes survive restart

-   Failed network operations retry

-   server tests pass

* * * * *

PHASE 6 --- NIDAN V2
==================

**Only after V1 is stable.**

V2 could include:

-   richer adaptive learning

-   better skill graphs

-   recommendation engine

-   multimedia lessons

-   interactive simulations

-   classroom mode

-   group activities

-   local classroom server

-   teacher activity builder

-   improved analytics

### Rule

If V1 isn't stable:

**SKIP PHASE 6.**

No shame.

Shipping one reliable thing beats having a repo containing 84 half-finished miracles.

* * * * *

PHASE 7 --- CUSTOM CHAT
=====================

This is intentionally late.

### V1 Chat Scope

Only:

```
Student
 ↓
School-approved group
 ↓
Student ↔ Student
```

Potential future:

```
Class
Study group
Project group
Teacher announcement
```

### Required safety systems

-   authentication

-   school membership

-   private groups

-   reporting

-   blocking

-   moderation

-   rate limiting

-   abuse detection

-   message retention rules

-   audit system

-   administrator controls

### Protocol

V1:

**REST**

V2:

**WebSocket**

Do not build a distributed messaging system before the education engine works.

* * * * *

PHASE 8 --- NEW FEATURES
======================

Only features that strengthen the central mission.

Priority A
----------

-   doubt queue

-   classroom activities

-   collaborative assignments

-   offline classroom sync

-   better teacher tooling

-   content downloads

-   multilingual support

-   accessibility

Priority B
----------

-   coding lessons

-   simulations

-   project learning

-   career roadmap

-   device health

-   school content server

-   teacher-created content

Priority C
----------

-   controlled network gateway

-   local caching

-   classroom-wide media distribution

-   advanced analytics

-   hardware management

* * * * *

PHASE 8.5 --- T1/T2 REFERENCE WORK
================================

This is where the original hardware dream comes back.

T1
--

Document:

-   CPU target

-   RAM target

-   storage target

-   display target

-   battery target

-   keyboard

-   touchpad

-   wireless

-   ports

-   charging

-   serviceability

-   thermal design

-   enclosure

-   repairability

-   estimated BOM

-   lifecycle economics

But remember:

> **₹1,000 is an engineering target, not a claim until validated.**

T2
--

Document:

-   classroom networking

-   local storage

-   synchronization

-   teacher interface

-   display output

-   projector/TV integration

-   classroom activities

-   device discovery

-   device management

-   power requirements

-   estimated BOM

The first physical T2 can simply drive an existing projector/TV.

* * * * *

PHASE 9 --- FINISH IT
===================

This phase is **feature freeze**.

No:

> "BRO WE JUST NEED ONE MORE FEATURE."

No.

Feature freeze.

### Code

-   remove dead code

-   remove debug code

-   remove unused dependencies

-   clean warnings

-   stabilize APIs

-   improve error handling

-   audit logging

-   performance cleanup

-   memory cleanup

### UI

-   visual consistency

-   typography

-   spacing

-   navigation

-   loading states

-   error states

-   empty states

-   offline states

-   accessibility

-   localization

### Documentation

-   README

-   installation

-   architecture

-   API

-   development guide

-   deployment

-   troubleshooting

-   testing

-   limitations

-   roadmap

* * * * *

PHASE 10 --- TEST EVERYTHING
==========================

This phase is not:

> "I clicked it and it worked."

This phase is where we try to murder the software politely.

Unit tests
----------

-   learning engine

-   assessment scoring

-   progression

-   recommendation

-   assignment generation

-   persistence

-   sync

-   validation

-   authentication

Integration tests
-----------------

```
UI
 ↓
Core
 ↓
Database
 ↓
Network
 ↓
Server
```

Test the complete loop.

Offline tests
-------------

-   no internet

-   internet disappears during sync

-   internet returns

-   duplicate sync

-   corrupted local data

-   restart during sync

-   power loss during operation

Performance
-----------

Define actual numbers in Phase 1 and test against them:

-   startup time

-   memory use

-   CPU usage

-   battery consumption

-   database performance

-   assignment generation time

-   sync time

-   server throughput

-   classroom concurrency

Hardware/low-end testing
------------------------

Run the application on:

-   modern laptop

-   old laptop

-   low-RAM machine

-   slow storage

-   slow network

-   intermittent network

NIDAN should not quietly require a ₹1 lakh machine to teach multiplication.

* * * * *

SECURITY TESTING
================

-   authentication testing

-   authorization testing

-   input validation

-   database access control

-   secret scanning

-   dependency audit

-   network security

-   local data protection

-   session handling

-   abuse cases

-   device theft/recovery scenarios

And before real-world child data is used:

-   privacy review

-   data minimization review

-   applicable child-data/legal requirements

-   consent/authorization process

-   retention policy

-   deletion process

* * * * *

PHASE 10 EXIT GATE
==================

The project is ready only when:

```
Build
  ✓

Tests
  ✓

Offline
  ✓

Network failure
  ✓

Fresh installation
  ✓

Realistic data
  ✓

Performance
  ✓

Security review
  ✓

Demo workflow
  ✓
```

* * * * *

PHASE 11 --- RYIC WAR ROOM
========================

Now we turn the engineering project into a competition project.

Prepare the presentation
------------------------

### Slide 1

**The problem**

One classroom.

Many learning levels.

One teaching path.

### Slide 2

**The consequence**

Students fall behind silently.

Teachers cannot individually track everyone.

Digital content alone doesn't solve the problem.

### Slide 3

**NIDAN**

The learning loop:

```
Assess
 ↓
Understand
 ↓
Group
 ↓
Teach
 ↓
Practice
 ↓
Measure
 ↓
Adapt
```

### Slide 4

**Student experience**

Show the actual interface.

### Slide 5

**Teacher experience**

Show the class dashboard.

### Slide 6

**Offline-first**

Demonstrate the app with networking disabled.

### Slide 7

**What we built**

This is extremely important.

Only claim what actually exists.

### Slide 8

**Measured results**

Before vs after.

### Slide 9

**Technology**

```
Linux
Swift
SwiftCrossUI
SQLite
Vapor
PostgreSQL
```

### Slide 10

**Future**

```
Nidan
 ↓
Classroom
 ↓
T2
 ↓
T1
 ↓
School network
 ↓
Scalable deployment
```

* * * * *

DEMO SCRIPT
===========

We need a **controlled 5-minute demo**.

### 0:00--0:30

Open NIDAN.

> "This is a student who has different learning strengths across subjects."

### 0:30--1:30

Run diagnostic.

Show:

```
Fractions → developing
Multiplication → strong
Algebra → foundational
```

### 1:30--2:30

NIDAN generates the next activity.

Student completes it.

Progress changes.

### 2:30--3:30

Open teacher dashboard.

Teacher sees:

```
Group A → ready for challenge
Group B → standard practice
Group C → foundational support
```

### 3:30--4:00

Disconnect internet.

Continue using NIDAN.

### 4:00--4:30

Reconnect.

Show synchronization.

### 4:30--5:00

Show measured result.

Then:

> **"This is the software we built today. T1 and T2 are the infrastructure we plan to engineer around it."**

That sentence protects us from overclaiming.

* * * * *

COMMONLY ASKED QUESTIONS
========================

We should have prepared answers for at least these:

### "How is NIDAN different from DIKSHA?"

Answer around:

**content delivery vs adaptive learning loop and teacher actionability.**

### "Why not just use tablets?"

Because NIDAN is hardware-agnostic today. T1 is a future reference platform designed around lifecycle cost, repairability and offline operation.

### "Why Linux?"

-   low licensing cost

-   open ecosystem

-   control over the platform

-   long-term customization

-   hardware flexibility

### "Why Swift?"

Because we want one primary language across core application logic, frontend and backend while keeping system interfaces separate.

### "Why SwiftCrossUI?"

Cross-platform Swift UI with Linux support, while keeping the actual NIDAN domain layer framework-independent. Its current WIP status is explicitly why that separation matters. ([GitHub](https://github.com/moreSwift/swift-cross-ui "GitHub - moreSwift/swift-cross-ui: A cross-platform declarative UI framework, inspired by SwiftUI. - GitHub"))

### "What happens without internet?"

NIDAN continues functioning from local storage.

### "What happens if a student changes schools?"

The learning record can eventually synchronize to another authorized NIDAN installation.

### "What about privacy?"

Collect the minimum necessary information, isolate permissions, protect stored data, and establish a formal privacy/data governance policy before real-world deployment.

### "Why not rank students?"

Because NIDAN measures **individual progress** and gives teachers instructional groups rather than publicly ranking children.

### "Will AI replace teachers?"

No.

NIDAN should reduce repetitive work and provide evidence that helps teachers decide what to do.

### "How will government pay for it?"

Long-term possibilities:

```
Government procurement
Scholarships
CSR
NGOs
Schools
Institutional deployment
```

But this is a deployment model, not something we pretend has already been contracted.

### "What does T1 cost?"

Prototype cost:

**TBD and honestly reported.**

Long-term target:

**sub-₹1,000-class device economics at scale.**

### "How does it make money?"

For the RYIC prototype, this is secondary.

The immediate objective is:

> **demonstrate impact, feasibility and scalability.**

* * * * *

GITHUB STRUCTURE
================

I would use a monorepo.

```
NIDAN/
│
├── AGENTS.md
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
│
├── Scripts/
│
└── .github/
    ├── workflows/
    ├── ISSUE_TEMPLATE/
    └── pull_request_template.md
```

* * * * *

GIT WORKFLOW
============

Keep it simple.

```
main
 │
 ├── feature/diagnostic
 ├── feature/student-dashboard
 ├── feature/teacher-dashboard
 ├── feature/sync-engine
 └── feature/backend-api
```

Every meaningful feature:

```
Issue
 ↓
Branch
 ↓
Implementation
 ↓
Tests
 ↓
Review
 ↓
Merge
```

### Labels

```
phase-1
phase-2
phase-3
phase-4
phase-5
phase-6
phase-7
phase-8
bug
architecture
security
documentation
testing
performance
blocked
ryic
```

* * * * *

THE 30-DAY RYIC SPRINT
======================

Since the current plan is competition-oriented, this is the aggressive version.

| Days | Work |
| --- | --- |
| 1--3 | Phase 1 documentation + architecture |
| 4--6 | Debian/NIDAN OS base |
| 7--9 | NIDAN Core + data model |
| 10--12 | Local storage + assessment |
| 13--16 | Student frontend |
| 17--19 | Teacher frontend |
| 20--22 | Vapor backend |
| 23--24 | Sync + offline integration |
| 25 | End-to-end integration |
| 26 | Bug fixing |
| 27 | Testing |
| 28 | Pilot/evidence preparation |
| 29 | Presentation + demo |
| 30 | Final testing + submission |

### Phase 6--8 rule during the 30-day sprint

```
V1 complete?
     │
   ┌─┴─┐
  NO   YES
  │      │
Finish  V2/features
V1      if time
```

**Do not sacrifice V1 for V2.**

* * * * *

THE ABSOLUTE V1 FEATURE LIST
============================

This is our **red line**.

### Student

-   Profile

-   Diagnostic

-   Skill level

-   Lessons

-   Exercises

-   Assignment

-   Feedback

-   Progress

-   Roadmap

-   Offline content

-   Notes/library

### Teacher

-   Class dashboard

-   Student progress

-   Learning groups

-   Assignment creation

-   Submission view

-   Skill-gap view

-   Doubt queue

### Platform

-   Linux

-   Offline storage

-   Sync

-   Authentication

-   Backend

-   Testing

-   Documentation

That's the project.

Not chat.

Not projector.

Not custom laptop.

Not nationwide deployment.

**Not yet.**

* * * * *

THE FULL LONG-TERM ROADMAP
==========================

```
                NIDAN
                  │
          ┌───────▼────────┐
          │   PHASE 1      │
          │ Documentation  │
          └───────┬────────┘
                  ▼
          ┌────────────────┐
          │    PHASE 2     │
          │  Linux / OS    │
          └───────┬────────┘
                  ▼
          ┌────────────────┐
          │    PHASE 3     │
          │  Core + App    │
          └───────┬────────┘
                  ▼
          ┌────────────────┐
          │    PHASE 4     │
          │ Full Frontend  │
          └───────┬────────┘
                  ▼
          ┌────────────────┐
          │    PHASE 5     │
          │    Backend     │
          └───────┬────────┘
                  ▼
          ┌────────────────┐
          │    PHASE 6     │
          │      V2        │
          └───────┬────────┘
                  ▼
          ┌────────────────┐
          │    PHASE 7     │
          │     Chat       │
          └───────┬────────┘
                  ▼
          ┌────────────────┐
          │    PHASE 8     │
          │ New Features   │
          └───────┬────────┘
                  ▼
          ┌────────────────┐
          │    PHASE 9     │
          │ Feature Freeze │
          └───────┬────────┘
                  ▼
          ┌────────────────┐
          │   PHASE 10     │
          │ Test + Validate│
          └───────┬────────┘
                  ▼
          ┌────────────────┐
          │   PHASE 11     │
          │ RYIC Submission│
          └───────┬────────┘
                  ▼
        ┌────────────────────┐
        │     T1 / T2        │
        │ Hardware Research  │
        └─────────┬──────────┘
                  ▼
        ┌────────────────────┐
        │     PILOT SCHOOL   │
        └─────────┬──────────┘
                  ▼
        ┌────────────────────┐
        │   MEASURE IMPACT   │
        └─────────┬──────────┘
                  ▼
        ┌────────────────────┐
        │      SCALE         │
        └────────────────────┘
```

THE ONE RULE THAT OVERRIDES EVERYTHING
======================================

**PROVE → MEASURE → THEN SCALE**
--------------------------------

We do **not** say:

> "This will change Indian education."

We build something that lets us stand in front of a judge and say:

> **"Here is the problem. Here is the system. Here is what we built. Here is how it works offline. Here is what the teacher sees. Here is what the student experiences. Here is the measured result. And here is the engineering roadmap from this prototype to national-scale infrastructure."**

That is far more powerful.
