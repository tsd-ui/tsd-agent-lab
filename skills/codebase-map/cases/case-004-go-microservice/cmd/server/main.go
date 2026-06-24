package main

import (
	"database/sql"
	"fmt"
	"net"
	"os"

	_ "github.com/lib/pq"
	"github.com/redis/go-redis/v9"
	"go.uber.org/zap"
	"google.golang.org/grpc"

	"github.com/example/auth-service/internal/auth"
	"github.com/example/auth-service/internal/cache"
)

func main() {
	logger, _ := zap.NewProduction()
	defer logger.Sync()

	db, err := sql.Open("postgres", os.Getenv("DB_URL"))
	if err != nil {
		logger.Fatal("failed to connect to database", zap.Error(err))
	}
	defer db.Close()

	rdb := redis.NewClient(&redis.Options{Addr: os.Getenv("REDIS_URL")})
	tokenCache := cache.NewRedisCache(rdb)

	repo := auth.NewPostgresRepository(db)
	svc := auth.NewService(repo, tokenCache, os.Getenv("JWT_SECRET"), logger)

	port := os.Getenv("GRPC_PORT")
	if port == "" {
		port = "50051"
	}

	lis, err := net.Listen("tcp", fmt.Sprintf(":%s", port))
	if err != nil {
		logger.Fatal("failed to listen", zap.Error(err))
	}

	srv := grpc.NewServer()
	svc.Register(srv)

	logger.Info("starting gRPC server", zap.String("port", port))
	if err := srv.Serve(lis); err != nil {
		logger.Fatal("server failed", zap.Error(err))
	}
}
