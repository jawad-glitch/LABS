# Simulated steps (fast mode) - Lab 13 - Implement Pause-Resume for Rollouts
No cluster or Rollouts controller ran. The controller is MODELLED by a step state machine fed with the steps from the YAML files
(setWeight -> scale canary=ceil(replicas*weight/100), stable=rest; pause {} -> CanaryPauseStep; pause {duration} -> timed (simulated clock);
analysis -> real job script run; manual pause -> spec.paused; promote -> clears manual pause and advances past a pause step; abort -> canary 0, Degraded; undo -> stable revision).
Real: CLI v1.10.2 (incl. proof that 'resume' does not exist), schema validation, nginx pods per revision, 40 HTTP requests per state (version from Server header), analysis job script.
Full mode: replace every 'kubectl argo rollouts resume' with 'kubectl argo rollouts promote'; replace '--watch' with 'kubectl argo rollouts status <name> -n rollout-demo --timeout 300s'.
