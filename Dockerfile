# Stage 1: Build the application
FROM golang:1.23rc1-alpine as builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN go build -o main ./cmd/app

# Stage 2: Run the application with Air
FROM builder AS release

# Install Air
RUN go install github.com/air-verse/air@latest

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/main .
COPY --from=builder /app/.air.toml .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the binary
CMD ["air", "-c", ".air.toml"]
