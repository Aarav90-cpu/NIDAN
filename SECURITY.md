# NIDAN Security Policy

Security is fundamental. NIDAN may handle information associated with students, teachers, and schools. Security and privacy issues must be treated seriously.

---

## Reporting Security Vulnerabilities

**Do NOT report security issues through public GitHub issues.**

A public issue may expose the vulnerability before a fix is available.

Use GitHub Security Advisories (if available) for private reporting.

If no private mechanism exists, contact maintainers through an official private channel and describe the issue without publishing sensitive details.

---

## What to Report Privately

Security-sensitive issues include:
- Authentication or authorization bypasses
- Exposure of private student data
- Access to another user's records
- Credential or secret leaks
- Remote code execution
- Privilege escalation
- SQL injection, command injection
- Path traversal
- Insecure synchronization
- Serious denial-of-service vulnerabilities
- Cryptographic failures
- Vulnerabilities bypassing restrictions
- Issues involving student communication or moderation

**When uncertain, report privately.**

---

## Reporting Details

Include:
- **Summary:** Short description
- **Component:** Affected part (e.g., NidanServer, NidanSync, NidanStudent)
- **Version/Commit:** When known
- **Reproduction:** Smallest sequence to reproduce
- **Impact:** What an attacker could do
- **Evidence:** Logs, screenshots, requests, stack traces (with synthetic data only)

Do NOT include real student information.

---

## Responsible Disclosure

Allow maintainers reasonable time to:
1. Acknowledge the report
2. Reproduce the issue
3. Assess severity
4. Develop a fix
5. Test and publish an advisory

Timeline varies by severity and complexity.

---

## Security Philosophy

- **Least privilege:** Components have only required permissions
- **Data minimization:** Do not collect unnecessary information
- **Defense in depth:** Do not rely on one control
- **Secure defaults:** Unsafe behavior is not default
- **Explicit authorization:** Authentication does not imply permission
- **Fail safely:** Failures do not silently disable controls

---

## Student Data Protection

Development and testing must use synthetic data.

Never commit:
- Real student names or contact information
- Passwords or authentication tokens
- Personal educational records
- Private communication

Logs must not unnecessarily contain student-sensitive information.

---

## Authentication & Authorization

Distinguish:

```
Authentication: "Who are you?"
Authorization: "What are you allowed to access?"
```

A valid student session must NOT grant access to another student's data.

Enforce authorization at appropriate boundaries.

---

## Offline Security

Offline operation creates unique concerns:
- Local data protection
- Device theft scenarios
- Unauthorized local access
- Sync after prolonged disconnection
- Stale credentials
- Replayed or duplicate operations
- Tampered local data
- Recovery after reset

Offline functionality must NOT bypass security controls.

---

## Synchronization Security

Synchronization must consider:
- Authenticated devices and users
- Authorization
- Request integrity
- Duplicate and replay detection
- Conflict handling
- Server validation

**The server must never blindly trust client data.**

---

## Secrets

Never commit secrets:
- API keys, passwords
- Private signing keys
- Database credentials
- Service tokens

Use appropriate environment or secret-management mechanisms.

If a secret is committed:
1. Treat it as compromised
2. Rotate or revoke it
3. Remove from active use
4. Investigate exposure
5. Fix the source

Removing from latest commit is insufficient if already exposed.

---

## Dependencies

Evaluate security-sensitive dependencies:
- Maintenance status
- Known vulnerabilities
- Platform compatibility
- License
- Transitive dependencies

Do NOT add libraries when security implications are unclear.

---

## Input Validation

Treat all external input as untrusted:
- API requests
- Sync payloads
- File paths
- Uploaded content
- Query parameters
- Form data

Validate at trust boundaries. Client-side validation does NOT replace server-side.

---

## File & Content Security

Educational content (PDFs, images, videos, documents) must handle:
- Path traversal
- Malicious filenames
- Unexpected file types
- Oversized files
- Archive abuse
- Executable content
- Malicious documents

Being "educational" does not make content trustworthy.

---

## Communication Features

Any student communication system requires:
- Authenticated identities
- Authorization
- Moderation
- Abuse reporting
- Blocking and rate limiting
- Message policies
- Administrator controls
- Privacy protections
- Retention rules

Do NOT implement communication casually.

---

## Security Testing

Test security-sensitive components:
- Auth and authorization failures
- Malformed requests
- Privilege escalation
- Unexpected state transitions
- Corrupted local data
- Sync abuse
- Dependency vulnerabilities
- Secret exposure
- Unsafe file handling

Test scale should match feature risk.

---

## AI-Generated Code

AI-assisted development does NOT reduce security requirements.

Review generated code for:
- Insecure defaults
- Incorrect cryptography
- Authentication/authorization mistakes
- Input-validation errors
- Secret leakage
- Unsafe dependencies
- Hallucinated security APIs

Do NOT assume generated code is secure because it compiles.

---

## Supported Versions

Security fixes focus on actively maintained releases.

Older versions may become unsupported when maintenance becomes impractical or unsafe.

---

## Security Advisories

When appropriate, maintainers publish advisories containing:
- Affected versions
- Severity and impact
- Fixed versions
- Mitigation steps
- Technical information

Handle sensitive exploitation details responsibly.

---

## Final Principle

Security in NIDAN is part of the architecture, not an afterthought.

A system for education must protect the people using it as carefully as the data they create.
