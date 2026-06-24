package auth

import (
	"context"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"go.uber.org/zap"
	"golang.org/x/crypto/bcrypt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/example/auth-service/internal/cache"
)

type Service struct {
	repo      Repository
	cache     *cache.RedisCache
	jwtSecret []byte
	logger    *zap.Logger
}

func NewService(repo Repository, cache *cache.RedisCache, secret string, logger *zap.Logger) *Service {
	return &Service{repo: repo, cache: cache, jwtSecret: []byte(secret), logger: logger}
}

func (s *Service) Register(srv *grpc.Server) {
	// Register gRPC service implementation with the server
}

func (s *Service) Login(ctx context.Context, email, password string) (string, error) {
	user, err := s.repo.GetUserByEmail(ctx, email)
	if err != nil {
		return "", status.Error(codes.NotFound, "user not found")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(password)); err != nil {
		return "", status.Error(codes.Unauthenticated, "invalid credentials")
	}

	token, err := s.generateToken(user.ID, user.Email)
	if err != nil {
		s.logger.Error("failed to generate token", zap.Error(err))
		return "", status.Error(codes.Internal, "token generation failed")
	}

	_ = s.cache.Set(ctx, fmt.Sprintf("token:%s", user.ID), token, 24*time.Hour)
	return token, nil
}

func (s *Service) CreateUser(ctx context.Context, email, password string) (string, error) {
	hash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", status.Error(codes.Internal, "failed to hash password")
	}

	id, err := s.repo.CreateUser(ctx, email, string(hash))
	if err != nil {
		return "", status.Error(codes.AlreadyExists, "user already exists")
	}
	return id, nil
}

func (s *Service) ValidateToken(ctx context.Context, tokenStr string) (string, error) {
	token, err := jwt.Parse(tokenStr, func(t *jwt.Token) (interface{}, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", t.Header["alg"])
		}
		return s.jwtSecret, nil
	})
	if err != nil || !token.Valid {
		return "", status.Error(codes.Unauthenticated, "invalid token")
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		return "", status.Error(codes.Internal, "invalid claims")
	}
	return claims["sub"].(string), nil
}

func (s *Service) generateToken(userID, email string) (string, error) {
	claims := jwt.MapClaims{
		"sub":   userID,
		"email": email,
		"exp":   time.Now().Add(24 * time.Hour).Unix(),
		"iat":   time.Now().Unix(),
	}
	return jwt.NewWithClaims(jwt.SigningMethodHS256, claims).SignedString(s.jwtSecret)
}
