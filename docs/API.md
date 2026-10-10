# Prototype API

This document describes the current local prototype API. It is not a production deployment contract.

## Processes

- `NidanApp` is the authoritative school API and frontend host. It owns SQLite records, sessions, class scope, assignments, marks, notices, chapter coverage, and doubts.
- `NidanContentServer` is a separate static-file process. It serves only files already installed in `Content/public`; it does not read the school database or make authorization decisions.
- Both processes bind to `127.0.0.1` by default. To expose them on a trusted classroom LAN, configure `NIDAN_BIND_HOST` and `NIDAN_CONTENT_BIND_HOST` explicitly, restrict access with the school network/firewall, and place TLS in front of both services before using real student data.

Run the services in separate terminals from the repository root:

```text
swift run NidanApp
swift run NidanContentServer
```

For the synthetic demonstration only, use an otherwise empty local database:

```text
NIDAN_DEMO_SEED=1 swift run NidanApp
```

## Enrollment

Enrollment codes are issued on the school server host and shown once in the operator's terminal. Keep that output private.

```text
swift run NidanApp issue-enrollment-code student --classes 9A
swift run NidanApp issue-enrollment-code teacher --classes 9A,9B --subjects Mathematics,Science
swift run NidanApp issue-enrollment-code vicePrincipal
swift run NidanApp issue-enrollment-code principal
```

Codes expire after 24 hours, are bound to a role and approved class/subject scope, and can be redeemed once. The code proves possession of an invitation, but is not yet bound to a school roster identity. Enrollment returns a seven-day session cookie.

Set `NIDAN_DEMO_SEED=1` when starting an otherwise empty local database to add a synthetic Grade 9 demo school. The seed refuses to run when any users already exist and runs only once per database.

## Authenticated Routes

| Method | Route | Access | Effect |
| --- | --- | --- | --- |
| `GET` | `/api/me` | Any enrolled role | Return current identity and role |
| `POST` | `/api/logout` | Any enrolled role | Revoke current session |
| `GET` | `/api/diagnostic/questions` | Student | Get skill-specific diagnostic questions |
| `POST` | `/api/diagnostic/attempts` | Student | Validate, score, and persist answers |
| `GET` | `/api/v1/student/dashboard` | Student | Read own classes, assignments, notices, and marks |
| `POST` | `/api/v1/student/assignments/{id}/submit` | Student assigned that work | Confirm paper hand-in at school |
| `POST` | `/api/v1/student/doubts` | Student in the named class | Queue a question for assigned staff |
| `GET` | `/api/v1/school/dashboard` | Teacher, vice-principal, principal | Return class-scoped teacher or school-wide leadership view |
| `GET` | `/api/v1/assignments/{id}/submissions` | Staff authorized for that class and subject | Read hand-in/mark status |
| `POST` | `/api/v1/assignments` | Assigned teacher or principal | Assign paper work to an authorized class |
| `POST` | `/api/v1/assignments/{id}/marks` | Assigned teacher or principal | Mark a submitted worksheet and record feedback |
| `POST` | `/api/v1/marks` | Assigned teacher or principal | Record a school test mark |
| `POST` | `/api/v1/chapter-progress` | Assigned teacher or principal | Update chapter coverage |
| `POST` | `/api/v1/notices` | Staff | Publish a class notice; only principal may publish school-wide |
| `POST` | `/api/v1/doubts/{id}/responses` | Staff assigned to the doubt's class and subject, or leadership | Save a response and close the doubt |

Student submissions and doubts derive identity from the session; clients cannot submit on behalf of another student. Teacher authorization is checked against persisted class and subject assignments in storage. Vice-principals have school-wide read access, class notices, and doubt responses, but cannot create assignments, edit marks, or update chapter coverage. Principals may perform those school-level workflows.

## Content Service

`NidanContentServer` defaults to port `8081`, serves `Content/public`, and exposes `/health`. Configure `NIDAN_CONTENT_DIRECTORY`, `NIDAN_CONTENT_BIND_HOST`, and `NIDAN_CONTENT_PORT` as needed. No books, media, or school files are included in the repository.

## Current Limitations

This implements a local Phase 5 prototype slice, not the Phase 5 exit gate. The prototype is a single-school SQLite deployment. It does not yet implement PostgreSQL deployment, school/tenant isolation, roster-bound identity verification, session renewal/recovery, device-side offline write queues, sync retry/conflict resolution, device provisioning, content metadata/catalog authorization, rate limits, request IDs, audit retention policy, or a production TLS/reverse-proxy setup. In particular, the current browser cannot complete assignments or queue doubts while disconnected. Do not use real student records or expose this directly to an untrusted network until those are addressed and reviewed.
