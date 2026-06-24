FROM golang:1.22-alpine AS build

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /bin/auth-service ./cmd/server

FROM alpine:3.19

RUN apk add --no-cache ca-certificates
COPY --from=build /bin/auth-service /usr/local/bin/auth-service

EXPOSE 50051
ENTRYPOINT ["auth-service"]
