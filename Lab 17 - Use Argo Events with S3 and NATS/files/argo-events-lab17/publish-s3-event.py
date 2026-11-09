#!/usr/bin/env python3
# Optional manual publisher (not needed: MinIO now publishes real S3 events to NATS).
# Run inside a venv:  python3 -m venv ~/natsenv && ~/natsenv/bin/pip install nats-py && ~/natsenv/bin/python publish-s3-event.py event-bucket file.txt
import asyncio, json, sys, datetime
from nats.aio.client import Client as NATS
async def main(bucket, key):
    nc = NATS(); await nc.connect("nats://localhost:4222")
    rec = {"eventName": "s3:ObjectCreated:Put", "eventTime": datetime.datetime.now(datetime.timezone.utc).isoformat(), "s3": {"bucket": {"name": bucket}, "object": {"key": key}}}
    await nc.publish("s3.file.uploaded", json.dumps({"EventName": "s3:ObjectCreated:Put", "Key": bucket + "/" + key, "Records": [rec]}).encode())
    await nc.flush(); await nc.close(); print("published", bucket, key)
if __name__ == "__main__":
    if len(sys.argv) != 3: print("Usage: publish-s3-event.py <bucket> <key>"); sys.exit(1)
    asyncio.run(main(sys.argv[1], sys.argv[2]))
