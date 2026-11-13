def project_status():
    return {
        "name": "Open Governance Sample Project",
        "governance": "hybrid",
        "status": "active"
    }


if __name__ == "__main__":
    for key, value in project_status().items():
        print(f"{key}: {value}")
