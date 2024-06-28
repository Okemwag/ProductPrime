FROM golang:1.23rc1-alpine as builder


WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./


RUN go mod download


COPY . .


RUN go build -o main ./cmd/app

# Stage 2: Run the application with Air
FROM builder AS release


RUN go install github.com/air-verse/air@latest

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/main .
COPY --from=builder /app/.air.toml .


EXPOSE 8080


CMD ["air", "-c", ".air.toml"]
