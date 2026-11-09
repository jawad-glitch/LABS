#!/bin/bash
kubectl get workflows -n argo --sort-by=.metadata.creationTimestamp
kubectl get eventsources,sensors,eventbus -n argo-events
kubectl get events -n argo-events --sort-by=.metadata.creationTimestamp | tail -10
