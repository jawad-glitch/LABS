FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Create logs directory
RUN mkdir -p /app/logs

ENV PYTHONUNBUFFERED=1
CMD ["python", "app.py"]
