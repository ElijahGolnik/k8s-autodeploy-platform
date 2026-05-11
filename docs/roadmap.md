# Current Project Roadmap (Subject to change)

Build a cloud-native environment, Kubernetes-based deployment platform with custom automation using Python and Go.

---

## Phase 1 - Foundation (Local Development)

**Goal:** Establish core application and containerization

### Milestones

* Containerize frontend (React → NGINX)
* Containerize backend (Node API)
* Validate local container execution
* Ensure frontend ↔ backend communication

---

## Phase 2 - Kubernetes Core

**Goal:** Deploy application into Kubernetes

### Milestones

* Create deployments for frontend, backend, MongoDB
* Configure ClusterIP services
* Remove localhost dependencies
* Validate internal DNS networking

---

## Phase 3 - CI/CD Fundamentals

**Goal:** Establish repeatable and deterministic builds

### Milestones

* Implement Docker image tagging (commit SHA)
* Push images to registry
* Remove reliance on `latest`
* Ensure repeatable builds

---

## Phase 4 - Production Readiness

**Goal:** Enable stable and externally accessible system

### Milestones

* Add readiness and liveness probes
* Configure rolling update strategy
* Implement Ingress for external access
* Validate zero-downtime deployments

---

## Phase 5 - Automation Layer (Python + Go)

**Goal:** Replace static CI/CD with programmable automation

### Milestones

* Build Python orchestrator (deployment logic)
* Integrate Go tools (Kubernetes API interaction)
* Implement rollout validation
* Add automated rollback capability

---

## Phase 6 - Cloud Deployment

**Goal:** Transition from local to cloud Kubernetes

### Milestones

* Deploy to managed Kubernetes (GKE or equivalent)
* Configure cloud ingress/load balancing
* Validate external access via public endpoint

---

## Phase 7 - Enhancements (Optional / Advanced)

**Goal:** Extend system toward production-grade platform

### Potential Additions

* TLS (HTTPS) via cert-manager
* Monitoring (Prometheus + Grafana)
* Logging (Loki / ELK)
* Horizontal Pod Autoscaling
* Multi-environment (dev/staging/prod)

---

## Final Projection

A fully automated, cloud-native deployment platform capable of:

* Building and deploying containerized applications
* Managing Kubernetes resources programmatically
* Performing zero-downtime updates
* Automatically validating and rolling back deployments
