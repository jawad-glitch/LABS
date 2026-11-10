FROM nginx:1.27-alpine
ARG V
ARG H
RUN printf '<html><body><h1>demo-app</h1><p>Version: %s</p></body></html>\n' "$V" > /usr/share/nginx/html/index.html && \
    printf '{"status":"%s","version":"%s"}\n' "$H" "$V" > /usr/share/nginx/html/health
