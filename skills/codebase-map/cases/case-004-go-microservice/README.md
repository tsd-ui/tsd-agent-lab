# auth-service

A gRPC-based authentication microservice written in Go. Handles user registration, login, and JWT token validation.

## Prerequisites

- Go 1.22+
- PostgreSQL 15+
- Redis 7+
- protoc (Protocol Buffers compiler)
- protoc-gen-go and protoc-gen-go-grpc plugins

## Getting Started

```bash
# Install protobuf plugins
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Generate protobuf code
make proto

# Run database migrations
make migrate-up

# Build and run
make build
./bin/auth-service
```

## Make Targets

| Target         | Description                        |
|----------------|------------------------------------|
| `build`        | Compile the binary to `./bin/`     |
| `test`         | Run all tests with race detection  |
| `lint`         | Run golangci-lint                  |
| `proto`        | Generate Go code from `.proto`     |
| `docker-build` | Build Docker image                 |
| `docker-run`   | Run service in Docker              |
| `migrate-up`   | Apply database migrations          |
| `migrate-down` | Roll back last migration           |

## Configuration

Set via environment variables:

- `DB_URL` — PostgreSQL connection string
- `REDIS_URL` — Redis connection string
- `GRPC_PORT` — gRPC listen port (default: 50051)
- `JWT_SECRET` — Secret key for signing tokens

## Deployment

Build and run via Docker:

```bash
make docker-build
docker run -p 50051:50051 \
  -e DB_URL=postgres://user:pass@db:5432/auth \
  -e REDIS_URL=redis://cache:6379 \
  -e JWT_SECRET=changeme \
  auth-service:latest
```
