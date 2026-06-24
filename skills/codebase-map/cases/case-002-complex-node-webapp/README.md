# TaskFlow

A full-stack task management application built with Express, React, and PostgreSQL.

## Tech Stack

- **Backend:** Node.js with Express
- **Frontend:** React (Vite)
- **Database:** PostgreSQL
- **Session Store:** Redis
- **Auth:** JWT-based authentication with bcrypt password hashing

## Project Structure

```
packages/
  api/     Express REST API
  web/     React single-page application
```

## Getting Started

### Prerequisites

- Docker and Docker Compose
- Node.js 20+

### Running Locally

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Start all services with Docker Compose:
   ```bash
   docker-compose up
   ```

   This starts the API server on port 3001, the web dev server on port 5173, PostgreSQL on port 5432, and Redis on port 6379.

3. For local development without Docker:
   ```bash
   npm install
   npm run dev
   ```

### Environment Variables

| Variable       | Description                  | Default                              |
|----------------|------------------------------|--------------------------------------|
| `DATABASE_URL` | PostgreSQL connection string | `postgres://taskflow:taskflow@localhost:5432/taskflow` |
| `REDIS_URL`    | Redis connection string      | `redis://localhost:6379`             |
| `JWT_SECRET`   | Secret key for signing JWTs  | (required, no default)               |
| `PORT`         | API server port              | `3001`                               |

## Testing

```bash
npm test
```

Runs Jest test suites for the API package.

## License

MIT
