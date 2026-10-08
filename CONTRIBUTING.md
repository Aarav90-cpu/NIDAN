# Contributing to NIDAN

Learning should adapt to the child. Contributions that improve NIDAN's ability to do this are welcome.

---

## Before You Contribute

1. Read `AGENTS.md` (AI development rules), `ABOUT.md`, and relevant documentation
2. Understand the existing architecture
3. Check whether an issue already exists
4. For large changes, discuss first via an issue
5. Keep changes focused

---

## What Contributions Are Welcome?

Improvements to:
- Educational usefulness
- Accessibility
- Reliability
- Offline operation
- Performance
- Security and privacy
- Maintainability
- Documentation
- Testing
- Localization

Examples: bug fixes, better error messages, missing tests, improved docs, accessibility improvements.

---

## Before Adding a Feature

Ask:
```
Does this solve a real problem?
    ↓
Does it fit NIDAN?
    ↓
Is it actually needed?
    ↓
Is the simplest implementation sufficient?
```

Do NOT add features that sound impressive but aren't needed.

---

## Reporting Bugs

Include:
- What you expected
- What actually happened
- Steps to reproduce
- Error messages or logs
- OS and NIDAN version/commit
- Screenshots when helpful

Do NOT include passwords, API keys, or personal student information.

For security vulnerabilities, see `SECURITY.md`.

---

## Development Workflow

1. Open or discuss an issue
2. Create a focused branch (e.g., `feature/student-dashboard`, `fix/assignment-scoring`)
3. Implement the smallest suitable change
4. Add or update tests
5. Review your own changes
6. Update documentation if needed
7. Open a pull request

Keep commits focused with meaningful messages:
```
feat: add diagnostic scoring
fix: correct mastery calculation
docs: update offline architecture
test: add assignment progression cases
```

Avoid meaningless commit messages.

---

## Code Guidelines

NIDAN uses Swift, SwiftCrossUI, Vapor, SQLite, PostgreSQL, and Bash.

Keep code:
- Readable
- Focused
- Maintainable
- Testable

Avoid unnecessary abstraction. A function should be a function, not a framework.

---

## Architecture Rules

```
Presentation
    ↓
Application
    ↓
Domain/Core
    ↓
Infrastructure
```

**Critical:** NidanCore must NOT depend on SwiftCrossUI or any UI framework.

Do NOT put:
- Database logic in views
- Network requests directly in views
- Learning algorithms in UI components

---

## Offline-First Requirements

When adding network functionality, consider:
- No network available
- Slow or intermittent network
- Connection loss during operations
- Duplicate or replayed requests
- Locally stored state conflicts
- Retry behavior

Core workflows must remain usable offline.

---

## Student Privacy & Safety

- Minimize data collection
- Use synthetic test data
- Do NOT commit real student records
- Consider access control and retention
- Flag privacy-sensitive changes

Communication features require dedicated safety, moderation, and authorization work.

---

## Dependencies

Before adding a dependency:
- Check if NIDAN already provides it
- Check if an existing dependency solves it
- Explain why it's needed
- Review maintenance status, platform support, license

Do NOT add dependencies "just in case."

---

## Licensing

NIDAN uses Apache License 2.0. Ensure contributions are legally compatible.

Do NOT copy code from incompatible licenses without explicit justification.

Do NOT remove license headers or copyright notices.

---

## Documentation

Documentation must describe actual project state, not future plans.

When changing behavior or architecture:
- Update relevant docs
- Update examples and API docs
- Clearly distinguish current vs. planned

Do NOT claim "production ready," "fully secure," or "guaranteed improvements" without evidence.

---

## Pull Requests

Explain:
1. **What changed** - Concise summary
2. **Why** - Problem being solved
3. **Scope** - Files/modules affected
4. **Testing** - What was tested
5. **Limitations** - Anything unverified

Keep changes small and focused. Avoid combining unrelated work.

---

## Review Standards

Reviewers consider:
- Correctness and architecture
- Readability and maintainability
- Security and privacy
- Accessibility and offline behavior
- Performance
- Documentation

A technically correct change may be rejected if it introduces unnecessary complexity or maintenance burden.

---

## Testing

New behavior should have tests.

Important areas: learning logic, assessment scoring, progression, persistence, sync, API validation, auth, authorization, offline behavior.

Tests should verify behavior, not just increase coverage numbers.

---

## Changes to Working Code

Do NOT rewrite working components simply because you prefer another approach.

When modification is necessary:
- Explain why
- Minimize scope
- Preserve external behavior unless intentionally changed

---

## AI-Assisted Contributions

AI-generated code must meet the same standards as human code.

Contributors are responsible for:
- Understanding submitted code
- Verifying correctness
- Reviewing changes
- Checking licenses and dependencies
- Checking security

Do NOT submit generated code merely because an AI produced it.

AI agents must follow `AGENTS.md`.

---

## Before Submitting

Verify:
- You understand the architecture
- Your change solves a specific problem
- You kept it focused
- You did not modify unrelated working code
- You added or updated tests
- You considered security/privacy
- You checked dependency licenses
- You updated documentation where needed
- You did NOT include secrets or private data
- Your claims match the actual implementation

---

## Code of Conduct

Follow `CODEOFCONDUCT.md`.

Technical disagreement is welcome. Personal attacks are not.

---

## Final Principle

Prioritize:
```
Useful + Correct + Reliable + Maintainable + Accessible + Scalable
```

before:

```
Fancy
```

A small feature that works is more valuable than a large feature that only exists in documentation.

Thank you for contributing to something useful.
