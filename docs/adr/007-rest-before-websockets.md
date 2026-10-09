# ADR 007: REST before WebSockets

## Status
Accepted

## Context
We need a protocol for the Sync Engine to communicate with the Vapor backend. While real-time features (like live teacher dashboards or instant messaging) would be beneficial, they introduce significant implementation complexity.

## Decision
For V1, all network communication will use **HTTP/REST + JSON**. Real-time communication via WebSockets is deferred to V2.

## Consequences
- **Positive:** REST is simple, stateless, and easier to debug. It perfectly suits the batch-oriented nature of intermittent offline syncing.
- **Negative:** Polling may be required for near-real-time updates in a connected classroom, which is less efficient than a persistent WebSocket connection.
