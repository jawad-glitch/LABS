# DAG Workflow Troubleshooting Guide

## Common Issues and Solutions
### 1. Circular Dependencies
**Problem**: Tasks have circular dependencies. **Solution**: Review DAG structure and ensure no cycles exist (argo lint rejects cycles).
### 2. Resource Constraints
**Problem**: Tasks fail due to insufficient resources. **Solution**: Add resource limits and requests to templates.
### 3. Parameter Passing Issues
**Problem**: Parameters not passed correctly. **Solution**: Workflow arguments only take effect if the template declares/uses them (spec.arguments + {{workflow.parameters.x}}).
### 4. Conditional Logic Errors
**Problem**: when conditions not evaluating correctly. **Solution**: Quote string operands: when: "'{{workflow.parameters.env}}' == 'dev'".
### 5. Executor permission errors
**Problem**: workflowtaskresults forbidden. **Solution**: Grant the workflow's ServiceAccount create/patch on workflowtaskresults.

## Best Practices
1. Keep DAGs Simple  2. Use Meaningful Names  3. Add Resource Limits  4. Test Incrementally  5. Monitor Execution
