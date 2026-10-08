# NIDAN Security Policy

Security is a fundamental requirement of NIDAN.

The project may eventually handle information associated with students, teachers, schools and educational activity. Security and privacy issues must therefore be treated seriously.

This document describes how security issues should be reported and how contributors should approach security-sensitive changes.

---

# 1. Reporting a Security Vulnerability

## Do not report security vulnerabilities through public GitHub issues.

A public issue may expose a vulnerability before a fix is available.

Security-sensitive reports should be submitted through the private security-reporting mechanism provided by the repository.

If GitHub Security Advisories are enabled for this repository, use the repository's **Security Advisories** interface to submit the report.

If no private reporting mechanism is currently available, do not publish sensitive technical details publicly. Contact the project maintainers through an official private communication channel associated with the project.

---

# 2. What Should Be Reported Privately?

Examples include:

* authentication bypasses,
* authorization bypasses,
* exposure of private student data,
* access to another user's records,
* credential leaks,
* secret exposure,
* remote code execution,
* privilege escalation,
* SQL injection,
* command injection,
* path traversal,
* insecure synchronization,
* insecure file handling,
* serious denial-of-service vulnerabilities,
* cryptographic implementation failures,
* vulnerabilities that allow bypassing school/device restrictions,
* security issues involving student communication or moderation.

When uncertain whether an issue is security-sensitive, treat it as sensitive and report it privately.

---

# 3. What to Include in a Report

A useful report should contain:

### Summary

A short description of the vulnerability.

### Affected component

For example:

```text
NidanServer
NidanSync
NidanStudent
NidanTeacher
Nidan OS
```

### Affected version or commit

Provide the version, release, branch or commit when known.

### Reproduction steps

Provide the smallest reliable sequence needed to reproduce the issue.

### Impact

Explain what an attacker could accomplish.

### Evidence

Include relevant:

* logs,
* screenshots,
* requests,
* responses,
* stack traces,
* proof-of-concept code,

when safe to provide.

Do not include real student information.

Use synthetic accounts and synthetic data.

---

# 4. Responsible Disclosure

Please avoid publicly disclosing a vulnerability before the maintainers have had a reasonable opportunity to investigate and address it.

The maintainers may:

1. acknowledge the report,
2. reproduce the issue,
3. assess its severity,
4. develop a fix,
5. test the fix,
6. publish an advisory when appropriate.

The exact timeline may vary depending on severity and complexity.

---

# 5. Security Philosophy

NIDAN follows several security principles.

## Least privilege

A component should have only the permissions it requires.

## Data minimization

Do not collect information that is not needed.

## Defense in depth

Do not rely on one security control.

## Secure defaults

Unsafe behavior should not be the default configuration.

## Explicit authorization

Authentication alone does not imply permission to access resources.

## Fail safely

Failure should not silently disable security controls.

---

# 6. Student Data

Student-related information must be treated carefully.

Development and testing should use synthetic data whenever possible.

Never commit:

* real student names,
* addresses,
* phone numbers,
* passwords,
* authentication tokens,
* personal educational records,
* private communication,
* government identifiers.

Logs should not unnecessarily contain student-sensitive information.

---

# 7. Authentication and Authorization

The system must distinguish between:

```text
Authentication
"Who are you?"
```

and:

```text
Authorization
"What are you allowed to access?"
```

Examples of potential roles include:

* student,
* teacher,
* school administrator,
* system administrator.

A valid student session must not automatically grant access to another student's data.

Authorization must be enforced at the appropriate application and backend boundaries.

---

# 8. Offline Security

Offline operation creates security considerations of its own.

Contributors working on offline functionality should consider:

* local data protection,
* device theft,
* unauthorized local access,
* synchronization after prolonged disconnection,
* stale credentials,
* replayed operations,
* duplicate operations,
* tampered local data,
* recovery after device reset.

Offline functionality must not become an excuse to bypass security controls.

---

# 9. Synchronization Security

Synchronization should consider:

* authenticated devices,
* authenticated users,
* authorization,
* request integrity,
* duplicate requests,
* replay protection where required,
* conflict handling,
* server validation,
* malformed data,
* unexpected state transitions.

The server must never blindly trust data supplied by a client.

---

# 10. Secrets

Never commit secrets to the repository.

This includes:

* API keys,
* passwords,
* private keys,
* signing keys,
* tokens,
* database credentials,
* service credentials.

Use appropriate environment or secret-management mechanisms.

If a secret is accidentally committed:

1. Treat it as compromised.
2. Rotate or revoke it.
3. Remove it from active use.
4. Investigate whether it was exposed elsewhere.
5. Correct the source of the leak.

Removing a secret from the latest commit is not sufficient if the secret has already been exposed.

---

# 11. Dependencies

Security-sensitive dependencies should be evaluated for:

* maintenance,
* known vulnerabilities,
* compatibility,
* license,
* transitive dependencies.

Do not introduce a library solely because it provides a convenient shortcut when the security implications are unclear.

---

# 12. Input Validation

All externally controlled input should be treated as untrusted.

Validate:

* API requests,
* synchronization payloads,
* file paths,
* uploaded content,
* identifiers,
* query parameters,
* form data,
* serialized objects.

Validation should happen at trust boundaries.

Client-side validation must not replace server-side validation.

---

# 13. File and Content Security

Educational content may eventually include:

* PDFs,
* images,
* videos,
* documents,
* interactive activities.

Content handling must consider:

* path traversal,
* malicious file names,
* unexpected file types,
* oversized files,
* archive abuse,
* executable content,
* malicious documents.

A file being labelled "educational" does not magically make it trustworthy.

---

# 14. Communication Features

Any future student communication system requires additional security and safety controls.

Potential requirements include:

* authenticated identities,
* authorization,
* moderation,
* abuse reporting,
* blocking,
* rate limiting,
* message handling policies,
* administrator controls,
* privacy protections,
* retention rules.

Communication features should not be implemented casually.

---

# 15. Security Testing

Security-sensitive components should be tested for:

* authentication failures,
* authorization failures,
* malformed requests,
* privilege escalation,
* unexpected state transitions,
* corrupted local data,
* synchronization abuse,
* dependency vulnerabilities,
* secret exposure,
* unsafe file handling.

Security testing should be proportionate to the risk of the feature.

---

# 16. AI-Generated Code

AI-assisted development does not reduce security requirements.

AI-generated code must be reviewed for:

* insecure defaults,
* incorrect cryptography,
* authentication mistakes,
* authorization mistakes,
* input-validation errors,
* secret leakage,
* unsafe dependencies,
* hallucinated security APIs.

Do not assume generated code is secure because it compiles.

---

# 17. Supported Versions

Security fixes should generally focus on actively maintained releases.

The project may choose to stop supporting older versions when maintaining them becomes impractical or unsafe.

The currently supported versions should be documented in project releases when the project reaches a release-based deployment model.

---

# 18. Security Advisories

When appropriate, maintainers may publish a security advisory containing:

* affected versions,
* severity,
* impact,
* fixed versions,
* mitigation,
* relevant technical information.

Sensitive exploitation details should be handled responsibly.

---

# 19. Scope

The security policy applies to:

* NIDAN source code,
* official NIDAN services,
* official APIs,
* official deployment tools,
* official NIDAN hardware/software components where applicable.

Third-party services and dependencies have their own security policies.

---

# 20. Final Principle

Security in NIDAN is not a feature added at the end.

It is part of the architecture.

A system intended for education must protect the people using it as carefully as it protects the data they create.
