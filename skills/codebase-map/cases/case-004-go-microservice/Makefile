BINARY := auth-service
PKG := github.com/example/auth-service
PROTO_DIR := api/proto
GEN_DIR := api/gen

.PHONY: build test lint proto docker-build docker-run migrate-up migrate-down

build:
	go build -o bin/$(BINARY) ./cmd/server

test:
	go test -race -cover ./...

lint:
	golangci-lint run ./...

proto:
	protoc --go_out=$(GEN_DIR) --go_opt=paths=source_relative \
		--go-grpc_out=$(GEN_DIR) --go-grpc_opt=paths=source_relative \
		$(PROTO_DIR)/*.proto

docker-build:
	docker build -t $(BINARY):latest .

docker-run:
	docker run -p 50051:50051 $(BINARY):latest

migrate-up:
	go run ./cmd/migrate -direction up

migrate-down:
	go run ./cmd/migrate -direction down
