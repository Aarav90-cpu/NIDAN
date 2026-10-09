# Test Strategy

Given NIDAN's focus on offline-first reliability and correct adaptive progression, testing must be rigorous before any feature is merged.

## 1. Unit Testing (Core Logic)
`NidanCore`, `NidanLearning`, and `NidanAssessment` must have exhaustive unit tests. 
- **Deterministic Testing:** The adaptive engine rules must be tested using fixed inputs and expected deterministic outputs.
- **Test Clocks:** Any logic involving time (e.g., spaced repetition reassessment) must use injected Test Clocks to avoid flaky, time-dependent tests.
- **Dependency Injection:** Repositories (like database adapters) must be injected so that the business logic can be tested entirely in memory without SQLite.

## 2. Integration Testing (Storage & Sync)
- SQLite queries and schema migrations must be tested against a real, in-memory SQLite database.
- The Sync Engine must be tested against a mocked Vapor backend to simulate network drops, 500 errors, and conflict resolution scenarios.

## 3. UI Testing (SwiftCrossUI)
- `NidanUI` is tested independently of the core.
- Because `SwiftCrossUI` is experimental, we prioritize Snapshot testing and view-model validation over deep, framework-specific UI automation.

## CI/CD
- SwiftPM `swift test` must run and pass on all Pull Requests.
- The `OS/build` script must successfully generate the Debian ISO on a nightly basis to ensure OS dependencies haven't broken the build.
