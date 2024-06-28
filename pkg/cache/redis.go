package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/redis/go-redis/v9"
)

// RedisCache represents a Redis client
type RedisCache struct {
	client *redis.Client
	ctx    context.Context
}

// NewRedisCache creates a new RedisCache instance
func NewRedisCache(addr, password string, db int) *RedisCache {
	// Initialize Redis client
	client := redis.NewClient(&redis.Options{
		Addr:     addr,
		Password: password,
		DB:       db,
	})

	// Ping Redis to check connectivity
	ctx := context.Background()
	_, err := client.Ping(ctx).Result()
	if err != nil {
		log.Fatalf("Failed to connect to Redis: %v", err)
	}

	return &RedisCache{
		client: client,
		ctx:    ctx,
	}
}

// Set sets a key-value pair in Redis with expiration time
func (rc *RedisCache) Set(key string, value interface{}, expiration time.Duration) error {
	err := rc.client.Set(rc.ctx, key, value, expiration).Err()
	if err != nil {
		return fmt.Errorf("failed to set key %s in Redis: %w", key, err)
	}
	return nil
}

// Get retrieves a value from Redis based on key
func (rc *RedisCache) Get(key string) (string, error) {
	val, err := rc.client.Get(rc.ctx, key).Result()
	if err != nil {
		return "", fmt.Errorf("failed to get key %s from Redis: %w", key, err)
	}
	return val, nil
}


