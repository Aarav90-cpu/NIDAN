# ADR 008: Core Independent from UI

## Status
Accepted

## Context
We chose SwiftCrossUI for our frontend (ADR-003). However, it is explicitly a work in progress and may undergo significant breaking changes or be abandoned by its maintainers.

## Decision
`NidanCore` (and all business logic modules) must have absolutely zero dependencies on `SwiftCrossUI` or any other presentation framework. The UI must remain a thin adapter layer on top of `NidanCore`.

## Consequences
- **Positive:** We insulate the most valuable part of the system (the learning logic, data models, and sync engine) from the most volatile part (the UI framework). If SwiftCrossUI fails, we only replace the presentation layer.
- **Negative:** Requires strict discipline. Developers cannot take shortcuts by putting database queries or learning algorithms directly inside view declarations. It may require writing boilerplate adapters/view-models.
