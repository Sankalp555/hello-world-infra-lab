# Project 1: Rails Hello World - Production Laboratory

## Project Goal
Building a simple Rails application to learn production systems, cloud fundamentals, deployment, Linux, observability, CI, and software engineering concepts. This is a YouTube series documentation.

## Guiding Principles
1. Discuss architecture first.
2. Explain "Why" before "How."
3. Mention alternatives and trade-offs.
4. Keep complexity low; build understanding first, automation later.
5. Treat this as a production laboratory.

## Roadmap & Progress
- [x] **Day 1: Project Introduction & Architecture**
- [x] **Day 2: Create Rails Hello World, health, and version endpoints**
- [ ] **Day 3: Git and GitHub**
- [ ] **Day 4: RSpec**
- [ ] **Day 5: Rubocop & Brakeman**
- [ ] **Day 6: GitHub Actions CI**
- [ ] ... (See full roadmap in original prompt)

## Current State
- Rails 8.1.3 initialized with PostgreSQL.
- `PagesController` created with `home`, `health`, and `version` actions.
- Routes configured:
  - `/` -> `pages#home`
  - `/health` -> `pages#health` (JSON)
  - `/version` -> `pages#version` (JSON)

## Architecture (Project 1)
Browser -> Nginx -> Puma -> Rails -> PostgreSQL/Redis.
Deployed on AWS EC2 (Manual setup first).

---
*Note: When starting a new chat in Cursor, reference this file to give the AI full context.*
