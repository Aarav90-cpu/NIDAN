# Contributing to NIDAN

Thank you for considering a contribution to NIDAN.

NIDAN is an open-source education project built around a simple idea:

> Learning should adapt to the child.

The project values useful, reliable contributions over large amounts of code. A small improvement that genuinely solves a problem is more valuable than a giant refactor that produces impressive-looking commit statistics.

Please read this document together with:

* `AGENTS.md`
* `ABOUT.md`
* `README.md`
* `SECURITY.md`
* `CODE_OF_CONDUCT.md`

---

# 1. Before You Contribute

Before making a contribution:

* Read the relevant project documentation.
* Understand the existing architecture.
* Check whether an issue or feature request already exists.
* Avoid duplicating existing work.
* Confirm that your proposed change fits NIDAN's purpose.
* Keep changes focused.

For larger changes, open or discuss an issue before implementation.

Do not begin major architectural work without first establishing why the change is needed.

---

# 2. What Contributions Are Welcome?

NIDAN welcomes contributions that improve:

* educational usefulness,
* accessibility,
* reliability,
* offline operation,
* performance,
* security,
* privacy,
* maintainability,
* documentation,
* testing,
* localization,
* teacher workflows,
* student workflows,
* learning assessment,
* adaptive learning,
* content infrastructure,
* Linux support,
* deployment.

Contributions do not need to be large.

Examples include:

* fixing a bug,
* improving an error message,
* adding a missing test,
* improving documentation,
* improving accessibility,
* improving offline behavior,
* fixing an incorrect learning rule,
* improving synchronization reliability.

---

# 3. Before Adding a Feature

Ask:

```text
Does this solve a real problem?
        ↓
Does it fit NIDAN?
        ↓
Is it actually needed?
        ↓
Can the existing system support it?
        ↓
Is the simplest implementation sufficient?
```

Do not add a feature simply because it sounds impressive.

Avoid speculative additions such as:

* unnecessary AI systems,
* unnecessary social features,
* excessive gamification,
* duplicate frameworks,
* large abstractions,
* unnecessary dependencies,
* unrelated redesigns.

---

# 4. Reporting Bugs

Before opening a bug report, verify that the problem is reproducible when reasonably possible.

Include:

* what you expected to happen,
* what actually happened,
* steps to reproduce,
* relevant logs or error messages,
* operating system,
* NIDAN version or commit,
* relevant device information,
* screenshots when useful.

Do not include:

* passwords,
* API keys,
* private tokens,
* personal student information,
* sensitive educational records,
* other confidential information.

For security vulnerabilities, do not use public issues. See `SECURITY.md`.

---

# 5. Feature Requests

A useful feature request should explain:

### Problem

What problem are you trying to solve?

### Users

Who is affected?

Examples:

* student,
* teacher,
* administrator,
* school,
* deployment operator.

### Proposed behavior

What should NIDAN do?

### Reason

Why is the feature valuable?

### Constraints

Does it need to work:

* offline,
* on low-end hardware,
* without continuous network access,
* with accessibility requirements,
* under restricted school environments?

Feature requests are proposals, not guaranteed implementation plans.

---

# 6. Development Workflow

Preferred workflow:

```text
Issue / Task
    ↓
Understand existing implementation
    ↓
Create focused branch
    ↓
Implement smallest suitable change
    ↓
Add or update tests
    ↓
Review changes
    ↓
Update documentation when needed
    ↓
Open pull request
```

Keep commits focused.

Examples:

```text
feat: add diagnostic scoring
fix: correct mastery calculation
docs: update offline architecture
test: add assignment progression cases
```

Avoid meaningless commit messages such as:

```text
changes
stuff
fix
update everything
final final final
```

The repository deserves better than that particular genre of human suffering.

---

# 7. Branches

Use descriptive branches.

Examples:

```text
feature/student-dashboard
feature/diagnostic-engine
feature/offline-sync
fix/assignment-scoring
docs/contribution-guide
test/sync-conflicts
```

Do not use branches that hide the purpose of the change.

---

# 8. Code Guidelines

NIDAN primarily uses:

* Swift
* SwiftCrossUI
* Vapor
* SQLite
* PostgreSQL
* Bash

Follow the conventions already established in the repository.

### Keep code:

* readable,
* focused,
* maintainable,
* unsurprising,
* testable.

Avoid unnecessary abstraction.

Do not create a framework around a function that could have been a function.

---

# 9. Architecture Rules

NIDAN separates:

```text
Presentation
     ↓
Application
     ↓
Domain/Core
     ↓
Infrastructure
```

The domain layer must remain independent of the UI framework.

For example:

```text
NidanCore
```

must not depend directly on:

```text
SwiftCrossUI
```

UI components should not contain:

* database logic,
* learning algorithms,
* network implementations,
* authentication rules,
* core business rules.

Keep infrastructure separate from educational logic.

---

# 10. Offline-First Requirements

When contributing functionality that uses network resources, consider:

* no network,
* slow network,
* intermittent network,
* network loss during an operation,
* interrupted synchronization,
* duplicate synchronization,
* retry behavior,
* locally stored changes,
* conflict resolution.

Core educational workflows should not become unusable simply because a connection disappears.

---

# 11. Student Safety and Privacy

NIDAN may eventually handle information associated with students and teachers.

Contributors must:

* minimize data collection,
* avoid unnecessary personal data,
* protect sensitive information,
* avoid logging private student information,
* use synthetic test data,
* avoid committing real student records,
* consider access control,
* consider data retention,
* consider deletion and recovery behavior.

Do not introduce communication or social functionality without considering moderation, authorization, reporting, abuse prevention and child safety.

---

# 12. Dependencies

Before adding a dependency:

* Check whether NIDAN already provides the required capability.
* Check whether an existing dependency solves the problem.
* Explain why the dependency is needed.
* Review its maintenance status.
* Review its platform compatibility.
* Review its license.

Do not add dependencies merely because they are convenient.

---

# 13. Licensing

NIDAN software is intended to use the **Apache License 2.0**, unless a specific component states otherwise.

Contributors should ensure that contributions can legally be distributed under the applicable project license.

Do not submit copied code from another project without confirming that its license permits the intended use.

Do not remove copyright or license notices belonging to third-party code.

Third-party dependencies retain their own licenses.

See `LICENSE` for the project's software license.

---

# 14. Documentation

Documentation should describe the actual state of the project.

When changing behavior or architecture:

* update relevant documentation,
* update examples,
* update API documentation when needed,
* update architecture documentation when needed.

Do not document planned functionality as though it already exists.

Avoid unsupported claims such as:

* "production ready,"
* "fully secure,"
* "works everywhere,"
* "zero bugs,"
* "guaranteed learning improvement."

Claims should be supported by evidence.

---

# 15. Pull Requests

A pull request should explain:

### What changed?

A concise summary.

### Why?

The problem being solved.

### Scope

Which files/modules are affected?

### Testing

What was tested?

### Limitations

Anything that remains unverified or incomplete.

A good pull request is easier to review when the change is small and focused.

Avoid combining unrelated work into the same pull request.

---

# 16. Review Standards

Reviewers should consider:

* correctness,
* architecture,
* readability,
* security,
* privacy,
* accessibility,
* offline behavior,
* performance,
* maintainability,
* documentation.

A change may be rejected even if it works when it introduces unnecessary complexity or creates a significant maintenance problem.

---

# 17. Testing

New behavior should have relevant tests where practical.

Important areas include:

* learning logic,
* assessment scoring,
* assignment generation,
* progression,
* local persistence,
* synchronization,
* API validation,
* authentication,
* authorization,
* offline behavior.

A test should verify behavior rather than simply increase coverage numbers.

---

# 18. Changes to Working Code

Existing working functionality should be preserved.

Do not rewrite working components merely because you prefer another implementation.

When a change requires modifying a working component:

* explain why,
* minimize the scope,
* preserve externally visible behavior unless intentionally changed,
* update tests where appropriate.

---

# 19. AI-Assisted Contributions

AI-assisted development is permitted.

AI-generated code is still subject to the same standards as human-written code.

Contributors remain responsible for:

* understanding submitted code,
* verifying its correctness,
* reviewing generated changes,
* checking licensing,
* checking dependencies,
* checking security implications.

Do not submit generated code merely because an AI model produced it.

AI agents working directly in the repository must follow `AGENTS.md`.

---

# 20. No False Claims

Contributors must not misrepresent:

* implementation status,
* benchmark results,
* testing results,
* pilot results,
* hardware costs,
* deployment status,
* compatibility,
* security properties,
* educational impact.

For example, a planned feature must be described as:

```text
Planned
```

not:

```text
Implemented
```

until it actually exists.

---

# 21. Contribution Checklist

Before submitting:

```text
- [ ] I understand the relevant project architecture.
- [ ] My change solves a specific problem.
- [ ] I kept the change focused.
- [ ] I did not modify unrelated working code.
- [ ] I added or updated relevant tests.
- [ ] I checked for security/privacy implications.
- [ ] I checked dependency licensing where relevant.
- [ ] I updated documentation where necessary.
- [ ] I did not include secrets or private data.
- [ ] My claims match the actual implementation.
- [ ] I reviewed my own changes.
```

---

# 22. Maintainer Review

Maintainers may request changes when a contribution:

* expands scope unnecessarily,
* conflicts with the architecture,
* introduces unnecessary dependencies,
* creates unacceptable security/privacy risks,
* lacks sufficient testing,
* duplicates existing functionality,
* does not provide meaningful project value.

Maintainers may also reject a technically correct contribution when its maintenance cost is disproportionate to its value.

---

# 23. Code of Conduct

All contributors are expected to follow `CODE_OF_CONDUCT.md`.

Technical disagreement is welcome.

Personal attacks are not.

---

# 24. Final Principle

NIDAN is being built to solve a real educational problem.

Contributions should therefore prioritize:

```text
Useful
   ↓
Correct
   ↓
Reliable
   ↓
Maintainable
   ↓
Accessible
   ↓
Scalable
```

before:

```text
Fancy
```

Thank you for helping build something that can be useful beyond the repository itself.
