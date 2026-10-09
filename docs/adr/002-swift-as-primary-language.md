# ADR 002: Swift as Primary Language

## Status
Accepted

## Context
We need a modern, safe, and performant programming language for NIDAN's core logic, backend, and potentially frontend. Using multiple languages creates a fragmented codebase and increases the cognitive load for developers contributing to the open-source project.

## Decision
We will use **Swift** as the primary application language across the entire stack. Swift is officially supported on Debian Linux.

## Consequences
- **Positive:** We can share domain models, validation logic, and networking code between the client application and the backend server. Strong typing and safety features reduce runtime crashes.
- **Negative:** The Swift ecosystem on Linux is mature but still slightly smaller than ecosystems like Python or Node.js. It requires developers to understand Swift's strict concurrency model.
