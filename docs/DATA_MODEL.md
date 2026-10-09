# Data Model

The NIDAN local database uses **SQLite** as its primary engine. It is fully relational.

## Core Tables

### 1. `users`
Represents both students and teachers.
- `id` (UUID, Primary Key)
- `role` (Enum: student, teacher)
- `display_name` (String)

### 2. `skills`
The nodes in the prerequisite graph.
- `id` (UUID, Primary Key)
- `name` (String)
- `description` (Text)
- `domain` (String - e.g., 'Math', 'Language')

### 3. `prerequisites`
The directed edges in the prerequisite graph.
- `target_skill_id` (UUID, Foreign Key -> skills)
- `prerequisite_skill_id` (UUID, Foreign Key -> skills)

### 4. `assessments` & `questions`
- `assessments` (id, title, skill_id)
- `questions` (id, assessment_id, prompt, correct_answer_hash, difficulty)

### 5. `progress`
The current state of a student for a particular skill.
- `student_id` (UUID, Foreign Key)
- `skill_id` (UUID, Foreign Key)
- `state` (Enum: NotStarted, Struggling, PartialMastery, Mastery)
- `confidence_score` (Float 0.0 - 1.0)
- `last_assessed_at` (Timestamp)
- *Primary Key: (student_id, skill_id)*

### 6. `sync_queue`
Manages offline-first network payloads.
- `id` (UUID)
- `entity_type` (String)
- `entity_id` (UUID)
- `action` (Enum: Create, Update, Delete)
- `status` (Enum: Pending, Syncing, Failed)
- `created_at` (Timestamp)
