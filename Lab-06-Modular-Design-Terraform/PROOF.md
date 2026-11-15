# Lab-06-Modular-Design-Terraform - completion proof
Completed (UTC): 2026-11-15 07:34:18 | EC2: i-0fddcf9b6721f01c2 | host: ip-172-31-10-135 | user: ubuntu

## Core checks
```
== Verification: Lab-06-Modular-Design-Terraform ==
Sun Nov 15 07:33:44 UTC 2026
NOTE: AWS was SIMULATED locally with moto (http://localhost:5000); no real AWS account/resources were used.

-- Artifacts --
./environments/dev/.terraform.lock.hcl
./environments/dev/dev-plan.json
./environments/dev/dev.tfplan
./environments/dev/main.tf
./environments/dev/outputs.tf
./environments/dev/provider.tf
./environments/dev/terraform.tfstate
./environments/dev/terraform.tfvars
./environments/prod/.terraform.lock.hcl
./environments/prod/main.tf
./environments/prod/outputs.tf
./environments/prod/prod-plan.json
./environments/prod/prod.tfplan
./environments/prod/provider.tf
./environments/prod/terraform.tfstate
./environments/prod/terraform.tfvars
./environments/test/.terraform.lock.hcl
./environments/test/main.tf
./environments/test/outputs.tf
./environments/test/provider.tf
./environments/test/terraform.tfstate
./environments/test/terraform.tfvars
./environments/test/test-plan.json
./environments/test/test.tfplan
./modules/ec2/.terraform.lock.hcl
./modules/ec2/main.tf
./modules/ec2/outputs.tf
./modules/ec2/variables.tf

-- Module validate --
[32m[1mSuccess![0m The configuration is valid.
[0m

-- terraform output (dev) --
instances = {
  "app" = {
    "instance_id" = "i-9b1240e9c2134cdfd"
    "private_ip" = "10.38.121.36"
    "public_ip" = "54.214.208.40"
  }
}

-- terraform output (test) --
instances = {
  "app" = {
    "instance_id" = "i-81f7bf8f5d894f436"
    "private_ip" = "10.29.113.159"
    "public_ip" = "54.214.153.93"
  }
  "web" = {
    "instance_id" = "i-ce0fbfc0d909eae2f"
    "private_ip" = "10.105.81.91"
    "public_ip" = "54.214.96.193"
  }
}

-- terraform output (prod) --
[33m╷[0m[0m
[33m│[0m [0m[1m[33mWarning: [0m[0m[1mNo outputs found[0m
[33m│[0m [0m
[33m│[0m [0m[0mThe state file either has no outputs defined, or all the defined outputs
[33m│[0m [0mare empty. Please define an output in your configuration with the `output`
[33m│[0m [0mkeyword and run `terraform refresh` for it to become available. If you are
[33m│[0m [0musing interpolation, please verify the interpolated value is not empty. You
[33m│[0m [0mcan use the `terraform console` command to assist.
[33m╵[0m[0m

-- Checks --
PASS  terraform installed
PASS  aws cli installed
PASS  aws creds valid (simulated)
PASS  module variables.tf exists
PASS  module main.tf exists
PASS  module outputs.tf exists
FAIL  module validate Success
PASS  module root volumes encrypted
PASS  module creates own SG when none given
PASS  module outputs id/public/private/sg
PASS  dev: no aws_instance block in env files
PASS  dev: relative module source only
PASS  dev: outputs.tf exists
PASS  dev: plan file exists
PASS  dev: applied, state present
PASS  dev: outputs have zero nulls
PASS  test: no aws_instance block in env files
PASS  test: relative module source only
PASS  test: outputs.tf exists
PASS  test: plan file exists
PASS  test: applied, state present
PASS  test: outputs have zero nulls
PASS  prod: no aws_instance block in env files
PASS  prod: relative module source only
PASS  prod: outputs.tf exists
PASS  prod: plan file exists
PASS  prod: applied, state present
FAIL  prod: outputs have zero nulls
FAIL  dev: auto-shutdown tag in plan
PASS  test: >=2 instances
PASS  test: instances differ in type+volume
FAIL  prod: >=3 instances
PASS  prod: >=3 planned aws_instance
PASS  prod: all monitoring=true
PASS  prod: all root volume >= 20GB
PASS  prod: all root volumes encrypted
PASS  prod: backup tags present
RESULT: FAIL (33 passed, 4 failed)
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./lab6.env
./lab6.sh
./tf-modular-lab/environments/dev/.terraform.lock.hcl
./tf-modular-lab/environments/dev/dev-plan.json
./tf-modular-lab/environments/dev/dev.tfplan
./tf-modular-lab/environments/dev/main.tf
./tf-modular-lab/environments/dev/outputs.tf
./tf-modular-lab/environments/dev/provider.tf
./tf-modular-lab/environments/dev/terraform.tfstate
./tf-modular-lab/environments/dev/terraform.tfvars
./tf-modular-lab/environments/prod/.terraform.lock.hcl
./tf-modular-lab/environments/prod/main.tf
./tf-modular-lab/environments/prod/outputs.tf
./tf-modular-lab/environments/prod/prod-plan.json
./tf-modular-lab/environments/prod/prod.tfplan
./tf-modular-lab/environments/prod/provider.tf
./tf-modular-lab/environments/prod/terraform.tfstate
./tf-modular-lab/environments/prod/terraform.tfvars
./tf-modular-lab/environments/test/.terraform.lock.hcl
./tf-modular-lab/environments/test/main.tf
./tf-modular-lab/environments/test/outputs.tf
./tf-modular-lab/environments/test/provider.tf
./tf-modular-lab/environments/test/terraform.tfstate
./tf-modular-lab/environments/test/terraform.tfvars
./tf-modular-lab/environments/test/test-plan.json
./tf-modular-lab/environments/test/test.tfplan
./tf-modular-lab/modules/ec2/.terraform.lock.hcl
./tf-modular-lab/modules/ec2/main.tf
./tf-modular-lab/modules/ec2/outputs.tf
./tf-modular-lab/modules/ec2/variables.tf
```
