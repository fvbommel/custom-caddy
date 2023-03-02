FROM caddy:2-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/fvbommel/caddy-combine-ip-ranges \
    --with github.com/fvbommel/caddy-dns-ip-range \
    --with github.com/WeidiDeng/caddy-cloudflare-ip

FROM caddy:2

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

CMD [ "caddy", "run", "--watch", "--config", "/etc/caddy/Caddyfile" ]
