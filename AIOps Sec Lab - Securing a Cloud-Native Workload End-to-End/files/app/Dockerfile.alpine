FROM python:3.12-alpine
RUN adduser -D -H -u 10001 -s /sbin/nologin app
WORKDIR /app
COPY --chown=root:root app.py .
USER 10001:10001
EXPOSE 8443
CMD ["python", "/app/app.py"]
