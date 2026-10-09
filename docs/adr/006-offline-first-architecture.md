# ADR 006: Offline-First Architecture

## Status
Accepted

## Context
NIDAN's target beneficiaries often reside in areas with intermittent, slow, or entirely absent internet connectivity. A cloud-dependent web application would be completely unusable in these environments.

## Decision
We mandate a strict **Offline-First Architecture**. The application UI must exclusively read from and write to the local SQLite database. All network operations are relegated to a background Sync Engine that reconciles local data with the upstream server when a connection is available.

## Consequences
- **Positive:** Students can always access their lessons, take assessments, and track progress without interruption. The system is resilient to infrastructure failures.
- **Negative:** Synchronization logic is inherently complex. We must design for conflict resolution, duplicate requests, and delayed payloads from day one.
