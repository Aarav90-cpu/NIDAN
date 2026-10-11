# ADR 010: Switch from SwiftCrossUI to Web Frontend (HTML, TypeScript, Material Web)

## Status
Accepted (Supersedes ADR 003)

## Context
In ADR 003, NIDAN selected SwiftCrossUI as its frontend framework to maintain an all-Swift codebase. However, ADR 003 explicitly acknowledged the experimental status of SwiftCrossUI, and ADR 008 mandated strict decoupling between `NidanCore` and the presentation layer to prepare for framework volatility.

During implementation, several major challenges with SwiftCrossUI became apparent:
1. **Maturity and Component Ecosystem:** SwiftCrossUI lacks a mature set of accessible, production-ready educational UI components (rich forms, responsive tables, interactive lists, accessible dialogs).
2. **Heavy Native GUI Dependencies:** On Linux, SwiftCrossUI requires GTK and desktop display libraries, adding significant overhead and compilation complexity to the system image and embedded targets.
3. **Cross-Device and Multi-Role Access:** NIDAN requires flexible presentation across different devices—students on local kiosk interfaces, teachers and administrators accessing dashboards over the local classroom network. A native GTK application cannot easily serve remote browsers on existing school hardware.

Because ADR 008 established complete business logic independence from UI frameworks, replacing the presentation layer required no changes to `NidanCore`, `NidanModels`, or `NidanStorage`.

## Decision
We will abandon **SwiftCrossUI** and switch to a modern, browser-based web frontend:
- **Markup and Logic:** HTML5, TypeScript, and standard JavaScript.
- **Styling and Components:** Material Design 3 Web components (`@material/web`) and curated vanilla CSS.
- **Build Tooling:** Vite and TypeScript compiler (`tsc`).
- **Delivery:** Compiled static assets (`Frontend/dist/`) are served directly by the local Swift/Vapor application server (`NidanApp`) via `FileMiddleware`.

## Consequences
- **Positive:**
  - Universal client compatibility: The interface runs in any modern browser on student devices, teacher laptops, or tablets over the local classroom network.
  - Mature, accessible component ecosystem: Material Design 3 Web provides high-quality form fields, buttons, progress indicators, dialogs, and themes.
  - Lighter native build footprint: The Swift server builds as a headless binary without GTK, X11, or native desktop GUI compilation overhead.
  - Rapid UI development: Hot-module reloading with Vite significantly accelerates frontend iteration.
  - Validates ADR 008: Proves that the core educational domain logic remained completely insulated from the presentation framework change.
- **Negative:**
  - Introduces Node.js and npm into the development and build pipeline for frontend asset compilation. (Runtime requires only the Swift binary and browser; Node.js is not needed at runtime).
