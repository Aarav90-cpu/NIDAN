# Architecture

The NIDAN architecture strictly separates domain logic from presentation and enforces an offline-first execution model.

## Core Rule
**SwiftCrossUI may own the UI. It must never own NIDAN's business logic.**

Business logic (`NidanCore`) must remain completely independent of the UI framework. If SwiftCrossUI changes or is replaced, only the UI adapter is updated, not the entire application.

## High-Level Flow
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
