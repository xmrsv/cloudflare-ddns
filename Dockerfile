FROM alpine:latest
RUN apk add --no-cache curl bash grep
COPY cloudflare.sh /usr/local/bin/cloudflare.sh
RUN chmod +x /usr/local/bin/cloudflare.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
