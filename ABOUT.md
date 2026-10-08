# NIDAN — AGENTS.md

## AI DEVELOPMENT RULES AND REGULATIONS

This repository is developed with the assistance of AI coding agents, including Claude, Gemini, and other compatible agents.

These rules are mandatory unless the user explicitly overrides them.

---

# 1. GENERAL PRINCIPLES

* Understand the existing code before modifying it.
* Preserve existing architecture and behavior unless the requested task explicitly requires changing them.
* Prefer the smallest correct change over a large refactor.
* Do not introduce unnecessary abstractions, dependencies, files, services, frameworks, or features.
* Do not optimize code that is already working unless optimization is explicitly requested or required for correctness.
* Do not redesign working systems simply because another approach appears cleaner.
* Do not assume that a newer approach is automatically a better approach.
* Do not invent requirements that the user did not provide.
* Do not hallucinate completed work, test results, files, APIs, or implementation details.
* Never claim that something works unless there is evidence for it.
* Be honest about limitations, uncertainty, and incomplete work.

---

# 2. COMMENTS AND CODE QUALITY

* Comment code properly and only where comments provide useful context.
* Comments must explain why something exists when the reason is not obvious from the code.
* Do not write comments that merely repeat what the code already says.
* Do not generate large comment blocks for simple functions.
* Keep code readable without relying on excessive comments.
* Use meaningful names instead of comments to explain poor naming.
* Follow the project's existing formatting and naming conventions.
* Do not bloatify the code.
* Do not create abstractions for one-time operations without a concrete reason.
* Do not create wrappers around APIs merely to rename or re-expose them.
* Avoid unnecessary generic code.
* Avoid premature optimization.
* Avoid speculative architecture.

---

# 3. WORKING CODE IS PROTECTED

## If the user says something works:

DO NOT TOUCH IT unless the user explicitly asks for it to be changed.

Instead:

* Find a way around it.
* Integrate with it.
* Preserve its behavior.
* Add new behavior beside it rather than rewriting it.

Optimization or cleanup of working code is a separate task and must not be mixed into an unrelated bug fix.

### Example

If the networking layer works but the UI has a problem:

* Do not rewrite the networking layer.
* Do not migrate networking frameworks.
* Do not rename unrelated networking APIs.
* Fix the UI problem using the existing networking layer.

---

# 4. IF SOMETHING BREAKS

When previously working functionality breaks:

1. Identify exactly what stopped working.
2. Determine what changed immediately before the regression.
3. Inspect the previous working implementation.
4. Compare the current implementation with the known working behavior.
5. Restore or adapt the previous approach where appropriate.
6. Avoid introducing a completely new architecture unless the existing approach is proven unusable.

Do not assume the newest implementation is correct simply because it was written recently.

---

# 5. BUG FIXING RULES

When fixing a bug:

* Fix the reported bug only.
* Do not add unrelated features.
* Do not perform unrelated refactoring.
* Do not rename unrelated files.
* Do not change unrelated APIs.
* Do not rewrite whole modules unless absolutely necessary.
* Do not replace working dependencies without explicit justification.
* Do not modify unrelated formatting across large files.
* Do not "clean up" unrelated code while fixing the bug.

### Bug-fix priority

```text
Reproduce
   ↓
Understand
   ↓
Identify smallest safe fix
   ↓
Apply fix
   ↓
Review affected behavior
   ↓
Report what changed
```

---

# 6. FILE AND SCOPE DISCIPLINE

Before editing a file:

* Confirm that the file is relevant to the requested task.
* Inspect the surrounding implementation.
* Check related interfaces when necessary.
* Avoid opening or modifying large numbers of unrelated files.

If the problem is localized, the investigation should remain localized.

Do not explore the entire repository merely because a task mentions one feature.

### Scope rule

If the user reports:

> "The login button does not work."

Do not immediately inspect:

* the entire backend,
* unrelated UI screens,
* the Linux image,
* database migrations,
* content systems,
* hardware documentation,

unless evidence shows they are relevant.

---

# 7. QUESTIONS, AMBIGUITY, AND ASSUMPTIONS

Do not guess when an important requirement is unclear.

When a decision could materially change:

* architecture,
* behavior,
* security,
* data handling,
* API compatibility,
* user experience,
* dependencies,
* file structure,

stop and ask the user before proceeding.

### However:

Do not ask unnecessary questions about details that are already explicitly defined in the repository, documentation, or task.

Do not repeatedly ask for information that has already been provided.

### If clarification is impossible

When the task must proceed without clarification:

* State the assumption clearly.
* Make the smallest reversible change possible.
* Do not silently invent requirements.

---

# 8. PLAN BEFORE CHANGING CODE

Before making changes, provide a concise plan.

The plan must state:

1. What will be changed.
2. Why it needs to change.
3. Which files/modules are expected to change.
4. What will explicitly not be changed when that boundary matters.

Example:

```text
Plan:
1. Update NidanLearning/SkillProgress.swift.
2. Fix mastery calculation for incomplete assessments.
3. Add/update the corresponding unit test.
4. Do not modify UI, networking, or database code.
```

Do not begin large implementation work without first establishing the plan.

---

# 9. CHECKLIST REQUIREMENT

Every meaningful task must have a checklist.

Track:

* what needs to be done,
* what has been completed,
* what remains,
* what could not be completed.

Example:

```text
Checklist:
- [x] Inspect current implementation
- [x] Identify regression
- [x] Apply minimal fix
- [x] Update test
- [ ] User must run build
```

Update the checklist as work progresses.

Never mark something complete when it was not actually completed.

---

# 10. NEVER HALLUCINATE COMPLETION

Never claim:

* "Build passed"
* "Tests passed"
* "The application works"
* "The API is working"
* "The feature is complete"
* "The issue is fixed"

unless there is actual evidence.

Use precise wording instead:

```text
Implemented the requested code change.

Build was not run because repository rules prohibit AI agents
from running build commands.

The user must run the build and report the result.
```

Do not hide incomplete verification.

---

# 11. BUILD COMMAND RESTRICTION

## AI agents MUST NOT run build commands.

The user explicitly handles builds and build verification.

Do not run commands such as:

```text
swift build
swift test
swift run
gradle build
./gradlew build
./gradlew test
cmake --build
make
ninja
cargo build
cargo test
```

or equivalent project build/test commands.

### Instead

* Inspect source code.
* Perform static reasoning.
* Review types and APIs.
* Inspect project structure.
* Check configuration files.
* Explain exactly what the user should run.
* Report what the user should expect.

### Important

Do not claim build/test success when the build/test was not run.

---

# 12. NO MASS CHANGES USING PYTHON

Do not use Python scripts or other generated scripts to perform mass edits to repository source files.

Do not:

* generate hundreds of file modifications automatically,
* rewrite source trees through a Python script,
* perform blind search-and-replace across the repository,
* use scripts to mutate code simply because it is faster.

For source changes:

* inspect the relevant files,
* edit deliberately,
* review the resulting changes.

Automation may be used for legitimate build-independent analysis or data processing when the user explicitly requests it, but not as a shortcut for careless repository-wide code modification.

---

# 13. DEPENDENCIES

Do not add a dependency unless it is actually required.

Before adding one:

* Check whether the project already provides the required functionality.
* Check whether an existing dependency can solve the problem.
* Explain why the dependency is necessary.
* Consider maintenance and platform support.
* Consider licensing.
* Keep the dependency as narrow as possible.

Do not add:

* libraries "just in case,"
* frameworks for one tiny feature,
* duplicate libraries that solve the same problem,
* experimental dependencies without informing the user.

---

# 14. LICENSE AND OPEN-SOURCE RULES

NIDAN is intended to be an open-source project.

AI agents must:

* Respect the repository's chosen license.
* Preserve existing copyright notices.
* Not copy code from incompatible licenses.
* Not paste large sections of third-party code into the repository without checking its license.
* Identify external code and dependencies when required.
* Avoid introducing dependencies whose licenses conflict with the project.
* Never remove or alter license headers without a valid reason.

When in doubt about licensing compatibility, stop and raise the issue rather than guessing.

---

# 15. README.md RULES

The `README.md` is part of the public interface of the project.

It MUST NOT contain:

* false claims,
* invented performance numbers,
* invented user counts,
* invented pilot results,
* fabricated compatibility,
* outdated architecture descriptions,
* features that do not exist,
* future features presented as completed,
* unsupported claims such as "production ready."

Before changing README.md:

* Check the actual current project state.
* Keep claims aligned with the implementation.
* Clearly distinguish current functionality from planned functionality.
* Remove outdated information when architecture changes.

Use wording such as:

```text
Current status:
Implemented

Planned:
Not yet implemented

Experimental:
May change
```

Never present a roadmap item as an existing feature.

---

# 16. DOCUMENTATION MUST FOLLOW THE CODE

When architecture changes:

* Update the relevant documentation.
* Update architecture diagrams where necessary.
* Update API documentation when API behavior changes.
* Update README.md when public behavior changes.
* Update ADRs when a major architectural decision changes.

Documentation must describe reality, not the intended future state.

---

# 17. NIDAN ARCHITECTURE RULES

The project follows strict separation of concerns.

```text
UI
 ↓
Application Layer
 ↓
Domain/Core
 ↓
Infrastructure
```

### Core rule

Business logic MUST NOT depend on the UI framework.

For example:

```text
NidanCore
```

must not depend on:

```text
SwiftCrossUI
```

SwiftCrossUI belongs to the presentation layer.

### Do not:

* put database logic inside views,
* put network requests directly into views,
* put learning algorithms inside UI components,
* store application rules in visual components,
* make UI framework types part of the core domain model unless absolutely necessary.

---

# 18. NIDAN TECHNOLOGY POLICY

Unless explicitly changed by the user or a documented architecture decision:

### Primary language

**Swift**

### Frontend

**SwiftCrossUI**

### Backend

**Swift + Vapor**

### Local storage

**SQLite**

### Server database

**PostgreSQL**, when server-scale deployment requires it.

### Operating system

**Debian-based Linux**

### Build/package management

**Swift Package Manager**

### Shell/system tooling

**Bash**

### Low-level native interfaces

**C**, only where needed.

### Additional languages

Python, Kotlin, JavaScript, Rust, C++, etc. must not be introduced into the product core without explicit architectural justification.

---

# 19. SWIFTCROSSUI RULE

SwiftCrossUI is a presentation framework.

Do not make NIDAN dependent on undocumented or framework-specific behavior when a framework-independent abstraction can be used.

The UI layer must remain replaceable.

Preferred architecture:

```text
NidanCore
    ↓
Application Services
    ↓
View Models / Presentation Models
    ↓
SwiftCrossUI
```

Do not place domain logic directly inside SwiftCrossUI view declarations.

---

# 20. OFFLINE-FIRST RULE

NIDAN is an offline-first education system.

Core educational functionality must not assume constant internet access.

Prefer:

```text
Local Data
   ↓
Core Logic
   ↓
UI

Network
   ↓
Synchronization
   ↓
Local Data
```

Avoid:

```text
UI
 ↓
Internet
 ↓
Everything
```

Features must define their offline behavior.

When implementing a networked feature, explicitly consider:

* no connection,
* interrupted connection,
* delayed synchronization,
* duplicate requests,
* retry behavior,
* local persistence,
* conflict resolution.

---

# 21. EDUCATIONAL LOGIC RULES

NIDAN must prioritize learning outcomes over flashy features.

Do not add gamification simply because it looks impressive.

Do not use:

* meaningless leaderboards,
* public student rankings,
* manipulative reward systems,
* distracting animations,
* unnecessary notifications,

unless explicitly justified by an educational objective.

The core learning loop is:

```text
Assess
 ↓
Understand
 ↓
Assign
 ↓
Practice
 ↓
Measure
 ↓
Adapt
```

Any feature that does not support students, teachers, accessibility, reliability, or the learning loop should be treated as optional.

---

# 22. STUDENT PRIVACY AND SAFETY

Student data is sensitive.

Agents must:

* minimize collected data,
* avoid unnecessary personal information,
* avoid hardcoded real student information,
* avoid committing credentials or secrets,
* avoid exposing personal data in logs,
* avoid including real children's data in examples or test fixtures,
* separate development/test data from real-world data,
* flag privacy-sensitive architectural decisions.

Do not implement student-facing social or communication functionality casually.

Such features require dedicated consideration of:

* safety,
* moderation,
* authentication,
* authorization,
* privacy,
* reporting,
* retention,
* abuse prevention.

---

# 23. SECURITY RULES

Security is part of the implementation, not a final decoration.

Consider:

* authentication,
* authorization,
* input validation,
* storage protection,
* network security,
* secret management,
* logging,
* rate limiting,
* dependency security,
* privilege separation.

Never:

* commit secrets,
* hardcode passwords,
* hardcode API tokens,
* disable security checks merely to make something work,
* weaken authentication without explicit instruction.

Do not use insecure development workarounds in production code without clearly marking them.

---

# 24. GIT DISCIPLINE

Keep commits focused.

Preferred:

```text
feat: add diagnostic scoring
fix: correct mastery threshold
docs: update offline architecture
test: add assignment progression cases
```

Avoid commits such as:

```text
fix everything
update stuff
changes
AI generated
```

Do not mix:

* unrelated refactors,
* formatting changes,
* dependency migrations,
* feature additions,

into a small bug fix.

Before proposing a commit, inspect the changes carefully.

---

# 25. PRESERVE USER WORK

Never overwrite, delete, or replace user-created work without explicit authorization.

Especially protect:

* configuration files,
* documentation,
* custom scripts,
* working implementations,
* deployment settings,
* local integration code.

When modifying an existing file, preserve unrelated content.

---

# 26. NO UNREQUESTED FEATURES

When asked to fix or implement something:

Do ONLY what is necessary to satisfy the request.

Do not add:

* animations,
* themes,
* authentication,
* logging systems,
* telemetry,
* chat,
* AI assistants,
* extra settings,
* new screens,
* extra APIs,

unless they are part of the requested task or required for correctness.

"Could be useful later" is not sufficient justification.

---

# 27. UI AND DESIGN RULES

NIDAN's UI should be:

* clear,
* calm,
* accessible,
* consistent,
* readable,
* responsive,
* student-friendly.

Do not create visual clutter.

Do not add UI elements simply to fill empty space.

Do not use animations that interfere with learning or accessibility.

Do not introduce childish design merely because the users are children.

The interface should feel respectful and modern.

---

# 28. NO EMOJIS

Emoji usage is strictly prohibited in:

* source code comments,
* documentation,
* commit messages,
* issue descriptions,
* generated UI copy,
* README.md,
* agent responses describing repository changes.

Use plain text.

---

# 29. LANGUAGE AND TONE

Do not change the project's technical tone based on which AI model is generating the code.

Claude, Gemini, or another agent must follow the same repository conventions.

Do not produce:

* childish explanations,
* hype-filled marketing language,
* meaningless buzzwords,
* exaggerated claims.

Avoid words such as:

* Mega
* Ultra
* Industry Grade
* Revolutionary
* Next Generation
* World Class

unless the term has a precise, defensible meaning and is genuinely required.

Technical documentation should be factual and specific.

---

# 30. AGENT BEHAVIOR

The agent must distinguish between:

### User request

What the user actually asked for.

### Current implementation

What actually exists.

### Planned architecture

What the project intends to build later.

### Assumptions

Things that are not confirmed.

Never confuse these categories.

---

# 31. BEFORE IMPLEMENTATION

The agent should verify:

```text
[ ] What exactly was requested?
[ ] What currently exists?
[ ] Which files are relevant?
[ ] What behavior currently works?
[ ] What behavior is broken or missing?
[ ] What is the smallest safe change?
[ ] Are there architectural constraints?
[ ] Are there security/privacy concerns?
[ ] Does the change require documentation?
```

Then present the plan.

---

# 32. DURING IMPLEMENTATION

The agent should:

* make focused changes,
* inspect its own edits,
* preserve unrelated code,
* maintain the checklist,
* stop if a major ambiguity appears,
* avoid expanding scope.

---

# 33. AFTER IMPLEMENTATION

The agent must:

```text
[ ] Review changed files
[ ] Check for accidental edits
[ ] Check for unused code
[ ] Check for obvious type/API issues
[ ] Check documentation
[ ] Update checklist
[ ] Explain what was changed
[ ] State what was NOT verified
[ ] Tell the user exactly what they need to run
```

Remember:

**The agent does not run build commands.**

The user performs build/test verification.

---

# 34. FAILURE RECOVERY

If a change creates a regression:

1. Do not continue layering changes on top of an unknown failure.
2. Identify the first known-good state.
3. Compare the changed implementation.
4. Revert the smallest problematic change when appropriate.
5. Reapply the required change more carefully.
6. Preserve unrelated work.

Do not "fix the fix" blindly.

---

# 35. FEATURE COMPLETION STANDARD

A feature should be considered implementation-complete only when:

```text
Requirements
    +
Implementation
    +
Relevant tests
    +
Documentation
    +
Review
```

However, because agents cannot run build commands, build verification must be explicitly reported as:

```text
Pending user verification
```

unless the user supplies a successful build/test result.

---

# 36. FINAL RESPONSE FORMAT FOR DEVELOPMENT TASKS

At the end of meaningful development work, report:

```text
## Plan
- What was intended.

## Changed
- Files/modules changed.
- What was implemented.

## Checklist
- [x] Completed item
- [x] Completed item
- [ ] User verification required

## Not Changed
- Important working areas deliberately left untouched.

## Verification
- Static review performed.
- Build/test NOT run by the agent.

## User Action
Run the appropriate project build/test command and report the result if further debugging is required.
```

Do not claim more than was actually done.

---

# 37. THE GOLDEN RULE

## DO NOT MAKE THE PROJECT BIGGER THAN THE PROBLEM REQUIRES.

NIDAN is being built to improve learning.

Every engineering decision should prioritize:

1. Correctness
2. Reliability
3. Maintainability
4. Offline capability
5. Accessibility
6. Privacy and safety
7. Educational usefulness
8. Performance
9. Simplicity
10. Future scalability

Fancy technology is secondary.

A small feature that works reliably is more valuable than a large feature that exists only in documentation.

---

# 38. FINAL AGENT PRINCIPLE

Before making any change, remember:

> **Understand first. Plan second. Change only what is necessary. Preserve what already works. Verify honestly. Document reality. Never invent progress.**

NIDAN is a long-term project.

Do not optimize for the appearance of progress.

Optimize for actual progress.
