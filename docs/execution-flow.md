# Execution Flow (Subject to change)

## Base Overview

This document describes the end-to-end flow from code change to deployed application.

---

## 1. Code Change

* Developer commits changes to repository
* Changes may affect frontend, backend, or automation logic

---

## 2. Python Orchestrator Trigger

```text
automation/cli.py
```

### Responsibilities

* Detect changed components (via git diff)
* Generate image tags (commit SHA)
* Coordinate build and deployment steps

---

## 3. Build & Push Images

* Docker builds images for affected services:

  * frontend
  * backend

* Images are tagged immutably:

```text
service-name:<commit-sha>
```

* Images are pushed to container registry

---

## 4. Deployment Update (Go + Kubernetes API)

Go tooling updates Kubernetes deployments:

```text
go-tools/deployer
```

### Actions

* Fetch deployment object
* Update container image
* Apply changes via Kubernetes API

---

## 5. Rolling Update (Kubernetes)

Kubernetes performs a rolling update:

```text
Old Pods → Gradually replaced → New Pods
```

### Guarantees

* No downtime (if configured correctly)
* Traffic only routed to ready pods

---

## 6. Readiness & Health Validation

### Internal

* Readiness probes confirm pods are ready

### External

* Python/Go health checks call:

```text
Ingress URL -> /health endpoint
```

---

## 7. Verification

System validates:

* All replicas are available
* Health endpoint returns 200 OK
* No errors during rollout

---

## 8. Failure Handling (Rollback)

If validation fails:

* Python orchestrator triggers rollback:

```text
kubectl rollout undo
```

* System returns to last stable version

---

## 9. Successful Deployment

If all checks pass:

* Deployment is marked successful
* Logs are recorded
* System continues running

---

## Rolling Updates Loop

```text
Change -> Build -> Deploy -> Verify -> Improve
```

---

## Key Ideas (WIP)

* Immutable images (no modification after build)
* Deterministic deployments (no "latest")
* Automated validation before success
* Self-healing via rollback
