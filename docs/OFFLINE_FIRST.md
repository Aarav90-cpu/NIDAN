# Offline-First Architecture

NIDAN is an offline-first education system designed for environments where internet connectivity is intermittent, unreliable, or completely absent.

## Core Philosophy
Core educational functionality must not assume constant internet access. The system must remain fully functional offline, and sync gracefully when connectivity is restored.

## The Sync Loop

The primary source of truth for the active NIDAN session is **always** the local database. 

```
Student Device → Local Database (SQLite) → NIDAN Core → Student Interface
                                               ↓
                                           Network/Sync (Background)
                                               ↓
                                   Classroom Hub (T2) / Cloud
```

## Architectural Anti-Patterns to Avoid
**Do NOT implement this flow:**
```
UI → Internet → Everything
```

## Design Considerations for Features
When implementing any new feature (e.g., submitting an assignment, tracking progress, loading a lesson), explicitly design for:
1. **No connection:** How does the student complete the task locally?
2. **Interrupted connection:** What happens if the network drops during sync?
3. **Delayed synchronization:** How do we queue payloads to be delivered hours or days later?
4. **Duplicate requests:** How does the server handle receiving the same assignment submission twice?
5. **Conflict resolution:** What happens if a teacher updates an assignment while the student is completing it offline?
