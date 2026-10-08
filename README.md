# NIDAN

## Adaptive, Offline-First Learning Infrastructure

Learning should adapt to the child.

NIDAN is an open-source education platform that helps students learn at their level while providing teachers actionable insight into classroom needs. Built with a software-first approach, progressing toward affordable Linux-based hardware.

---

## The Problem

Classrooms contain students at different understanding levels. Teachers cannot manually assess every student daily. The problem is not just access to material, but: **How do we identify what a student understands and determine what they should learn next?**

---

## Our Approach

NIDAN uses a continuous loop:

```
Assess → Identify Level → Assign → Practice → Measure → Adapt → Repeat
```

---

## For Students

- Diagnostic assessments
- Level-based learning paths
- Interactive practice and feedback
- Personal progress tracking (not public ranking)
- Offline access to core material

**Emphasis:** Individual progress over comparison.

---

## For Teachers

- Understand classroom learning needs at useful detail
- Organize students by learning needs, not just marks
- Create assignments and learning groups
- Monitor progress and identify misconceptions
- Queue and manage student questions

**NIDAN assists teachers, it does not replace them.**

---

## Offline First

NIDAN functions without reliable internet. Core learning remains available locally. Synchronization occurs when connectivity returns.

```
Student Device → Local Database → NIDAN Core → Student Interface
                                        ↓
                                    Network/Sync
```

---

## Technology Stack

| Layer | Technology |
|-------|-----------|
| Language | Swift |
| UI | SwiftCrossUI |
| Backend | Swift + Vapor |
| Local Storage | SQLite |
| Server Database | PostgreSQL |
| OS | Debian-based Linux |
| Build System | Swift Package Manager |

Architecture separates domain logic from presentation:

```
NIDAN Core → Application Layer → SwiftCrossUI → Platform
```

---

## Design Principles

1. **Learning before features** - Features must meaningfully contribute to learning/accessibility
2. **Offline first** - System remains useful without continuous internet
3. **Student progress over ranking** - Students compete with themselves, not each other
4. **Teacher assistance, not replacement** - Provide information while leaving decisions to educators
5. **Small, reliable systems** - One feature that works beats ten that barely function
6. **Honest engineering** - Claims match implementation
7. **Maintainability** - Works on modest hardware, understandable to future developers

---

## Project Status

NIDAN is in active development. Current focus: software foundation and first working learning loop.

**NOT currently claimed:**
- Mass-produced T1 device
- Mass-produced T2 classroom hub
- National deployment
- Measured learning improvements
- Target cost achievement (₹1,000 for T1, ₹2,000 for T2)

These are future engineering goals.

---

## Development Phases

**Phase 1:** Documentation and architecture
**Phase 2:** Linux base (Debian)
**Phase 3:** NIDAN core and application
**Phase 4:** Full frontend (student and teacher)
**Phase 5:** Backend services
**Phase 6-10:** V2, communication, stabilization, testing
**Phase 11:** RYIC preparation and deployment

---

## T1 — Future Student Device

Low-cost, durable, repairable Linux device designed for NIDAN. Long-term target: approximately ₹1,000 lifetime cost per student through repair and reuse.

---

## T2 — Future Classroom Hub

Classroom hub connecting T1 devices, providing local content, managing synchronization, and supporting teacher workflows. Long-term target: approximately ₹2,000.

---

## Open Source

NIDAN is developed openly. Software, architecture, documentation, and interfaces remain as open and reproducible as practical, subject to respective licenses.

See: `LICENSE`, `CONTRIBUTING.md`, `AGENTS.md`

---

## Contributing

Before contributing:

1. Read `AGENTS.md` (AI development rules)
2. Read relevant documentation
3. Understand existing architecture
4. Keep changes focused
5. Add tests where appropriate
6. Update documentation when necessary

See `CONTRIBUTING.md` for details.

---

## License

Apache License 2.0 — see `LICENSE`
