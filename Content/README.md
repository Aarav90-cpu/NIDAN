# NIDAN Content Service

The content service is a separate Swift executable from the school API server.

- The main `NidanApp` process owns users, sessions, class membership, assignments, marks, notices, doubts, progress, and authorization.
- `NidanContentServer` serves only files explicitly installed under `Content/public` (or the directory named by `NIDAN_CONTENT_DIRECTORY`). It does not access the school database or infer access from a URL.
- The default content port is `8081`; set `NIDAN_CONTENT_PORT` to change it.
- `/health` reports process readiness. Other paths resolve only within the configured static directory through Vapor's file middleware.

No textbooks, student records, or video files are included by this prototype. Add only material the school is permitted to store and distribute, and keep its title, source, license, and attribution with its content metadata. This service is a local prototype and is not an authenticated production media gateway.
