package main

import (
	"log"

	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()

	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("Hello, Gabriel Okemwa!")
	})

	err := app.Listen(":8080")
	if err != nil {
		log.Fatalf("Error starting Fiber server: %v", err)
	}
}
