# Rails Hello World Production Laboratory

## Goal
This is not a business application. It is a production laboratory to learn backend engineering, cloud infrastructure, DevOps fundamentals, Linux, observability, and system design.

The application itself is extremely simple, serving as a foundation for learning complex infrastructure and deployment patterns.

## Tech Stack
- **Ruby on Rails 8.1.3**
- **PostgreSQL**
- **Redis** (for Sidekiq/Caching)
- **RSpec** (Testing)
- **Rubocop** (Linting)
- **Brakeman** (Security Scanning)

## Routes
- `/` - Home page
- `/health` - Health check endpoint (JSON)
- `/version` - Application version (JSON)

## Development
### Setup
```bash
bundle install
rails db:prepare
```

### Running Tests
```bash
bundle exec rspec
```

### Linting
```bash
bundle exec rubocop
```

### Security Scan
```bash
bundle exec brakeman
```
