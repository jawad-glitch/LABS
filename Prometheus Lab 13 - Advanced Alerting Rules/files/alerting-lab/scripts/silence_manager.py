#!/usr/bin/env python3
"""create <alertname> <duration_minutes> <comment> <created_by> | list | delete <silence_id>  (Alertmanager API v2, urllib only)"""
import sys, json, urllib.request, urllib.error
from datetime import datetime, timedelta, timezone
ALERTMANAGER_URL = "http://localhost:9093"

class SilenceManager:
    def _req(self, method, path, body=None):
        data = json.dumps(body).encode() if body is not None else None
        req = urllib.request.Request(ALERTMANAGER_URL + path, data=data, method=method, headers={"Content-Type": "application/json"})
        with urllib.request.urlopen(req, timeout=10) as r:
            if not 200 <= r.status < 300: raise RuntimeError("HTTP %d" % r.status)
            raw = r.read(); return json.loads(raw) if raw else None
    def create(self, alertname: str, duration_minutes: int, comment: str, created_by: str) -> str:
        now = datetime.now(timezone.utc)
        body = {"matchers": [{"name": "alertname", "value": alertname, "isRegex": False, "isEqual": True}],
                "startsAt": now.isoformat(), "endsAt": (now + timedelta(minutes=int(duration_minutes))).isoformat(),
                "comment": comment, "createdBy": created_by}
        return self._req("POST", "/api/v2/silences", body)["silenceID"]
    def list_active(self) -> list:
        return [s for s in self._req("GET", "/api/v2/silences") if s.get("status", {}).get("state") == "active"]
    def delete(self, silence_id: str) -> None:
        self._req("DELETE", "/api/v2/silence/%s" % silence_id)

def main(args: list) -> None:
    sm = SilenceManager()
    try:
        if args[:1] == ["create"] and len(args) == 5:
            print(sm.create(args[1], int(args[2]), args[3], args[4]))
        elif args[:1] == ["list"]:
            for s in sm.list_active():
                m = ",".join("%s%s%s" % (x["name"], "=~" if x.get("isRegex") else "=", x["value"]) for x in s["matchers"])
                print("%s  matchers=%s  comment=%r  endsAt=%s" % (s["id"], m, s.get("comment"), s.get("endsAt")))
        elif args[:1] == ["delete"] and len(args) == 2:
            sm.delete(args[1]); print("deleted %s" % args[1])
        else:
            print(__doc__); sys.exit(1)
    except urllib.error.HTTPError as e:
        print("HTTP error %d: %s" % (e.code, e.read().decode()[:200])); sys.exit(2)

if __name__ == "__main__":
    main(sys.argv[1:])
