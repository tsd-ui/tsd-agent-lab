# Codebase Map: auth-service

## Directory Structure

```
auth-service/
├── api/
│   └── proto/
│       └── auth.proto          # gRPC service definition (Login, Register, ValidateToken)
├── cmd/
│   └── server/
│       └── main.go             # Entry point — wires DB, Redis, auth service, starts gRPC server
├── internal/
│   ├── auth/
│   │   ├── service.go          # Core business logic: Login, CreateUser, ValidateToken, JWT generation
│   │   └── repository.go       # Repository interface + PostgreSQL implementation (users table)
│   └── cache/
│       └── redis.go            # Redis cache wrapper (Set/Get/Delete)
├── Dockerfile                  # Multi-stage Alpine build
├── Makefile                    # Build, test, lint, proto generation, Docker, migrations
├── go.mod                      # Go 1.22 module definition
├── input.yaml                  # Repo metadata (description, focus areas)
└── README.md                   # Setup and usage documentation
```

## Architecture Overview

This is a **gRPC authentication microservice** following a standard Go project layout:

- **Entry point** (`cmd/server/main.go`): Initializes PostgreSQL and Redis connections, creates the auth service, and starts a gRPC server on the configured port (default 50051).
- **Service layer** (`internal/auth/service.go`): Contains all business logic — user registration (bcrypt hashing), login (credential verification + JWT issuance), and token validation (HMAC-SHA256 verification). Tokens are cached in Redis with a 24-hour TTL.
- **Repository layer** (`internal/auth/repository.go`): Defines a `Repository` interface with `CreateUser` and `GetUserByEmail`. The `PostgresRepository` implementation uses parameterized SQL queries against a `users` table.
- **Cache layer** (`internal/cache/redis.go`): Thin wrapper around `go-redis` providing `Set`, `Get`, and `Delete` operations with TTL support.
- **API definition** (`api/proto/auth.proto`): Defines three RPCs — `Login`, `Register`, and `ValidateToken` — with their request/response messages.

**Data flow**: gRPC request -> Service (business logic) -> Repository (PostgreSQL) + Cache (Redis) -> gRPC response.

The architecture is a simple layered design (not hexagonal — the service directly depends on concrete `*cache.RedisCache` rather than an interface). No middleware, interceptors, or generated protobuf Go code are present in the repo.

## Build and Test Commands

| Command | Description |
|---------|-------------|
| `make build` | Compile binary to `./bin/auth-service` |
| `make test` | Run all tests with `-race -cover` |
| `make lint` | Run `golangci-lint` |
| `make proto` | Generate Go code from `.proto` files into `api/gen/` |
| `make docker-build` | Build Docker image (`auth-service:latest`) |
| `make docker-run` | Run Docker container, exposing port 50051 |
| `make migrate-up` | Apply database migrations (`cmd/migrate`) |
| `make migrate-down` | Roll back last migration |

## Key Dependencies

| Dependency | Purpose |
|------------|---------|
| `google.golang.org/grpc` v1.63.2 | gRPC server framework |
| `google.golang.org/protobuf` v1.33.0 | Protocol Buffers runtime |
| `github.com/golang-jwt/jwt/v5` v5.2.1 | JWT token creation and validation |
| `github.com/lib/pq` v1.10.9 | PostgreSQL driver for `database/sql` |
| `github.com/redis/go-redis/v9` v9.5.1 | Redis client |
| `go.uber.org/zap` v1.27.0 | Structured logging |
| `golang.org/x/crypto/bcrypt` | Password hashing (imported in service.go but not in go.mod — see risks) |

## Risk Areas

1. **Missing `golang.org/x/crypto` in `go.mod`**: `service.go` imports `golang.org/x/crypto/bcrypt` but it is not listed in `go.mod`. The project will not compile as-is.

2. **No generated protobuf Go code**: The `api/gen/` directory does not exist. The `Register()` method on `Service` is a stub that doesn't actually register the gRPC service implementation. The proto definition and the Go service methods are disconnected — there is no generated `AuthServiceServer` interface being implemented.

3. **No tests**: There are zero test files in the repository. The `make test` target exists but there is nothing to run.

4. **No migrations**: The Makefile references `cmd/migrate` but that directory doesn't exist. There's no schema definition for the `users` table.

5. **Concrete cache dependency**: `Service` takes `*cache.RedisCache` (concrete type) instead of an interface, making it hard to test without a real Redis instance.

6. **JWT secret from environment variable**: The `JWT_SECRET` is read directly from the environment with no validation — an empty string would silently produce insecure tokens.

7. **`ValidateToken` doesn't check cache**: Tokens are stored in Redis on login but `ValidateToken` only verifies the JWT signature. There's no revocation check against the cache, making the cache write in `Login` effectively dead code.

8. **Error masking in `CreateUser`**: Any database error (connection failure, constraint violation, etc.) is returned as `codes.AlreadyExists`, hiding real errors.

9. **Type assertion without check**: `claims["sub"].(string)` in `ValidateToken` (line 82) will panic if the claim is missing or not a string.

10. **No `go.sum` file**: The repository has `go.mod` but no `go.sum`, so dependency verification is incomplete.

## Recommended First Tasks

1. **Fix `go.mod` to add missing `golang.org/x/crypto` dependency** — The project won't compile without it. Run `go mod tidy` or add it explicitly.

2. **Generate protobuf Go code and wire up gRPC service** — Run `make proto` to generate the `AuthServiceServer` interface, then implement it in `service.go` so the gRPC endpoints actually work.

3. **Add unit tests for `Service` methods** — Start with `Login`, `CreateUser`, and `ValidateToken`. Define a cache interface so Redis can be mocked. Create a mock `Repository` for testing without PostgreSQL.

4. **Add the database migration for the `users` table** — Create `cmd/migrate` and a migration file defining the `users` schema (id, email, password_hash) to match the queries in `repository.go`.

5. **Fix the unsafe type assertion in `ValidateToken`** — Use the comma-ok idiom (`sub, ok := claims["sub"].(string)`) to prevent a runtime panic on malformed tokens.
