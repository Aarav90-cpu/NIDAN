# ADR 004: SQLite for Local Storage

## Status
Accepted

## Context
NIDAN is an offline-first platform. Student devices (T1) need a local datastore to hold assignments, learning content, and progress while disconnected from the classroom hub or the internet.

## Decision
We will use **SQLite** as the local database on the devices.

## Consequences
- **Positive:** SQLite is proven, zero-configuration, extremely reliable, and lightweight—perfect for low-cost hardware. It handles the relational data requirements of the learning model effectively.
- **Negative:** Requires writing synchronization logic to reconcile the local SQLite state with the upstream PostgreSQL server when online.
