# Retrospectives Between Previous Projects and Current

## Sprint 1 - Containerization

### What Went Well

* Successfully containerized both frontend and backend
* Multi-stage build reduced frontend image size

### What Didn’t Go Well

* Initial Docker builds were slow due to poor layer caching
* Misconfigured working directories caused build failures

### Improvements

* Optimized Dockerfile layer ordering
* Introduced `.dockerignore` to reduce build context

---

## Sprint 2 - Kubernetes Foundation

### What Went Well

* Services enabled stable communication between pods
* Kubernetes DNS simplified service discovery

### What Didn’t Go Well

* Used localhost initially, causing networking failures
* Misaligned labels caused services to not route traffic

### Improvements

* Standardized service naming conventions
* Validated pod labels and selectors carefully

---

## Sprint 3 - CI/CD + Image Strategy

### What Went Well

* Implemented commit SHA tagging for images
* Pipeline became deterministic and repeatable

### What Didn’t Go Well

* Early reliance on "latest" caused inconsistent deployments
* Debugging image mismatch was difficult

### Improvements

* Eliminated "latest" usage entirely
* Introduced immutable image strategy

---

## Sprint 4 - Production Readiness

### What Went Well

* Rolling updates prevented downtime
* Readiness probes improved deployment stability

### What Didn’t Go Well

* Improper probe timing caused failed rollouts
* Ingress configuration required multiple iterations

### Improvements

* Tuned probe timing for application startup
* Validated ingress routing with test endpoints

---

## Sprint 5 - Automation Layer

### What Went Well

* Python orchestrator enabled dynamic deployments
* Go tools improved performance and concurrency

### What Didn’t Go Well

* Initial API integration had authentication issues
* Rollback logic was incomplete in early iterations

### Improvements

* Implemented full rollout validation
* Added automated rollback on health check failure
