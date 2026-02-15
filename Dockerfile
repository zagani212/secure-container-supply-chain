# ---------- Stage 1: Build ----------
FROM golang:1.25-alpine AS builder

# Set the working directory
WORKDIR /app

# Ensure a portable, static-ish binary
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

COPY go.mod main.go ./

# Build the Go application (strip debug info for smaller size)
RUN go build -trimpath -ldflags="-s -w" -o myapp .

# ---------- Stage 2: Final ----------
FROM alpine:3.23

# Set the working directory
WORKDIR /app

# Install runtime dependencies you actually need
RUN apk add --no-cache ca-certificates tzdata

# Create non-root user for security
RUN addgroup -S appuser \
    && adduser -S -G appuser -H -s /sbin/nologin appuser

# Copy the binary and set ownership
COPY --from=builder /app/myapp /app/myapp

# Run as non-root user
USER appuser

# port is variable
EXPOSE 8080 

# Set the entrypoint command
ENTRYPOINT ["/app/myapp"]