# ADR 005: Vapor for Backend

## Status
Accepted

## Context
NIDAN requires a backend server for the classroom hub (T2) and cloud deployments to aggregate student data, manage teacher workflows, and handle sync requests. Since Swift is our primary language (ADR-002), we need a Swift-based web framework.

## Decision
We will use **Vapor** for the backend framework.

## Consequences
- **Positive:** Vapor is the most mature, widely-used, and well-supported web framework in the Swift ecosystem. It has excellent support for async/await and integrates seamlessly with PostgreSQL.
- **Negative:** Vapor introduces a learning curve for developers unfamiliar with its specific ORM (Fluent) and routing paradigms.
