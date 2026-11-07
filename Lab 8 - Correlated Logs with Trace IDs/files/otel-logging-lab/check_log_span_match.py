import json, re, sys
txt = open(sys.argv[1]).read()
spans, buf, on = [], [], False
for line in txt.splitlines():
    if line == "{": on, buf = True, [line]; continue
    if on:
        buf.append(line)
        if line == "}":
            try: spans.append(json.loads("\n".join(buf)))
            except Exception: pass
            on = False
S = {(s["context"]["trace_id"][2:], s["context"]["span_id"][2:]): s for s in spans}
logs = re.findall(r'\[trace_id=([0-9a-f]+) span_id=([0-9a-f]+)\] - (.*)', txt)
inspan = [l for l in logs if set(l[0]) != {"0"}]
outside = [l for l in logs if set(l[0]) == {"0"}]
matched = [(t, s, m) for t, s, m in inspan if (t, s) in S]
expect = {"Validating data": "validate_user_data", "Saving data": "save_user_data", "Starting to process": "process_user_request"}
right = sum(1 for t, s, m in matched for k, v in expect.items() if m.startswith(k) and S[(t, s)]["name"] == v)
needed = sum(1 for t, s, m in inspan for k in expect if m.startswith(k))
err = [S[(t, s)] for t, s, m in matched if "Failed to save data for user 999" in m]
exc = bool(err) and any(e.get("name") == "exception" for e in err[0].get("events", [])) and err[0]["attributes"].get("save.status") == "failed"
traces = {t for t, s, m in inspan}
print(f"spans exported: {len(spans)} | log lines: {len(logs)} (in-span {len(inspan)}, outside-span trace_id=0: {len(outside)})")
print(f"in-span log lines whose trace_id+span_id match an exported span: {len(matched)}/{len(inspan)}")
print(f"log lines attributed to the correct span name: {right}/{needed}")
print(f"distinct traces with logs: {len(traces)} | user 999 error log in span with recorded exception: {exc}")
print("ALL_MATCH=" + ("yes" if inspan and len(matched) == len(inspan) else "no"))
print("RIGHT_SPAN=" + ("yes" if needed and right == needed else "no"))
print("EXC_CORRELATED=" + ("yes" if exc else "no"))
