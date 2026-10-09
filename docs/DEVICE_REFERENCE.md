# T1 and T2 Hardware Architecture

## T1: The Student Device
The T1 is the long-term goal for the student's personal learning device. 
- **Target Cost:** ~₹1,000 lifetime cost.
- **Hardware:** Extremely low-end, highly repairable, modular components (likely ARM or low-power x86).
- **OS:** Custom NIDAN OS (derived from Debian). It boots directly into the NIDAN session. There is no standard desktop environment to distract the student.
- **Capabilities:** Runs `NidanCore`, `SwiftCrossUI`, and a local `SQLite` database.

## T2: The Classroom Hub
The T2 is the local classroom server.
- **Target Cost:** ~₹2,000.
- **Purpose:** Acts as the local "cloud" when the classroom has no external internet. It serves the Vapor backend and PostgreSQL database.
- **Capabilities:** 
  - Hosts bulk educational content (videos, large PDFs).
  - Syncs data from 30-50 T1 student devices simultaneously over a local mesh or Wi-Fi network.
  - Provides the Teacher Dashboard via a web interface or dedicated local app.
  - Opportunistically syncs to the National Cloud when internet is available.
