FROM golang:1-alpine AS builder

WORKDIR /src

# Tell Go where its caches are.
ENV GOMODCACHE=/go-mod-cache GOCACHE=/go-build-cache

# Get module definition.
COPY go.* ./

# Update mod cache.
RUN --mount=type=cache,target=/go-mod-cache \
    go mod download

# Get source code.
COPY *.go ./

# Compile, using mod cache and build cache.
RUN --mount=type=cache,target=/go-mod-cache \
    --mount=type=cache,target=/go-build-cache \
    go build -v -o /caddy

# Adapt the official Caddy image using the new binary.
FROM caddy:2

COPY --from=builder /caddy /usr/bin/caddy

# Allow using privileged ports without root.
RUN setcap cap_net_bind_service=+ep /usr/bin/caddy

CMD [ "caddy", "run", "--watch", "--config", "/etc/caddy/Caddyfile" ]
