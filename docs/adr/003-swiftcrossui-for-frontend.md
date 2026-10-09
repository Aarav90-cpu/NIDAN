# ADR 003: SwiftCrossUI for Frontend

## Status
Accepted

## Context
Since we are using Swift as our primary language, we need a way to build a graphical user interface on Linux (and potentially other desktop platforms). We want a declarative, SwiftUI-like syntax to accelerate UI development.

## Decision
We will use **SwiftCrossUI** for the frontend presentation layer. On Linux, this will utilize the GTK backend.

## Consequences
- **Positive:** We get a modern, declarative UI framework entirely in Swift, avoiding the need to bridge to C++ or use web technologies (Electron) for the local student app.
- **Negative:** SwiftCrossUI is explicitly described as a work-in-progress. It may undergo breaking changes, have missing features, or ultimately be abandoned. This risk mandates ADR-008 (Core independent from UI).
