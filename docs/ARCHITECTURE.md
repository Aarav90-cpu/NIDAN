# Architecture

The NIDAN architecture strictly separates domain logic from presentation and enforces an offline-first execution model.

## Core Rule
**SwiftCrossUI may own the UI. It must never own NIDAN's business logic.**

Business logic (`NidanCore`) must remain completely independent of the UI framework. If SwiftCrossUI changes or is replaced, only the UI adapter is updated, not the entire application.

## High-Level Flow
```
Student / Teacher / Leadership Web UI
      │ authenticated REST
      ▼
NidanApp (Vapor school API)
      │
      ├── NidanCore / NidanModels
      ├── NidanStorage (SQLite)
      └── Role and class/subject authorization

NidanContentServer (separate Vapor process)
      │
      └── Approved static files only
```

The school API is authoritative for identity, class membership, assignments, marks, notices, chapter coverage, and doubts. The content process does not open the school database and does not grant access to school records. Both processes bind to loopback unless an operator explicitly configures a classroom-network bind address.

## Module Dependencies
The Swift Packages are organized with strict dependency boundaries:

```
NidanCore
   ↑
NidanStorage
NidanNetworking
NidanSync
   ↑
NidanUI
   ↑
Student App / Teacher App
```

## Offline Data Flow
The application must work without a network connection, prioritizing the Local Database (SQLite).

```
UI
 ↓
Core
 ↓
Local DB
```

The network acts as an asynchronous synchronization layer, not the primary data source:

```
Network
   ↓
Sync Engine
   ↓
Local DB
```

The current Vapor prototype persists learning workflows on the server. Offline device write queues, retry, conflict handling, device provisioning, and complete sync semantics remain planned work; the current server is not yet the finished offline-first architecture.
