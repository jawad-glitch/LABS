#!/usr/bin/env python3
"""
Configuration validator for OpenTelemetry Collector
"""

import yaml

def validate_otel_config():
    print("OpenTelemetry Collector Configuration Validator")
    print("=" * 55)
    try:
        with open('config/otel-config.yaml', 'r') as f:
            config = yaml.safe_load(f)
        print("✓ Configuration file loaded successfully")
        for section in ['receivers', 'processors', 'exporters', 'service']:
            print(f"✓ {section} section found" if section in config else f"✗ {section} section missing")
        print("✓ OTLP receiver configured" if 'otlp' in config.get('receivers', {}) else "✗ OTLP receiver not found")
        processors = config.get('processors', {})
        for proc in ['memory_limiter', 'batch', 'attributes']:
            print(f"✓ {proc} processor configured" if proc in processors else f"✗ {proc} processor missing")
        actions = processors.get('attributes', {}).get('actions', [])
        print("✓ service.environment attribute configured" if any(a.get('key') == 'service.environment' for a in actions) else "✗ service.environment attribute not found")
        pipelines = config.get('service', {}).get('pipelines', {})
        for pipeline in ['traces', 'metrics', 'logs']:
            if pipeline not in pipelines:
                print(f"✗ {pipeline} pipeline missing"); continue
            print(f"✓ {pipeline} pipeline configured")
            pc = pipelines[pipeline]
            if 'otlp' in pc.get('receivers', []):
                print(f"  ✓ {pipeline} pipeline has OTLP receiver")
            procs = pc.get('processors', [])
            if all(p in procs for p in ['memory_limiter', 'batch', 'attributes']):
                print(f"  ✓ {pipeline} pipeline has all required processors")
            else:
                print(f"  ✗ {pipeline} pipeline missing some processors")
            if procs and procs[0] == 'memory_limiter' and procs[-1] == 'batch':
                print(f"  ✓ {pipeline} pipeline order: memory_limiter first, batch last")
            else:
                print(f"  ✗ {pipeline} pipeline order should be memory_limiter first, batch last")
        print("\n" + "=" * 55)
        print("Configuration validation completed!")
    except Exception as e:
        print(f"✗ Error validating configuration: {e}")

if __name__ == "__main__":
    validate_otel_config()
