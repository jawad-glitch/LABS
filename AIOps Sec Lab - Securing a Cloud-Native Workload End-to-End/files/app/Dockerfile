FROM python:3.12-alpine
RUN apk upgrade --no-cache && (python -m pip uninstall -y pip setuptools wheel >/dev/null 2>&1 || true) && adduser -D -H -u 10001 -s /sbin/nologin app
WORKDIR /app
COPY --chown=root:root app.py .
USER 10001:10001
EXPOSE 8443
CMD ["python", "/app/app.py"]
