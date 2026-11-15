from src.policy_generator import PolicyGenerator

config = {
    "project_name": "FinCore Library",
    "security_email": "security@fincore.example.com",
    "pgp_key_url": "https://fincore.example.com/pgp-key.asc",
    "supported_versions": [
        {"version": "3.2.x", "supported": True},
        {"version": "3.1.x", "supported": True},
        {"version": "3.0.x", "supported": False},
        {"version": "< 3.0", "supported": False},
    ],
    "sla": {
        "initial_response_hours": 48,
        "triage_days": 7,
        "fix_days_standard": 90,
        "fix_days_critical": 30,
    },
    "hall_of_fame": [],
}

generator = PolicyGenerator(config)
for name, path in generator.write_artifacts(".").items():
    print(f"Written: {name} -> {path}")
