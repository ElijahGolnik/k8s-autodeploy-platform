# Current Sprint Plan (Subject to change)

## Sprint 1 - Core Containerization

**Goal:** Containerize frontend and backend services

### Tasks

* [ ] Create Dockerfile for frontend (React → NGINX)
* [ ] Create Dockerfile for backend (Node API)
* [ ] Build and run containers locally
* [ ] Verify frontend ↔ backend communication

### Deliverables

* Working Docker images
* Local container execution

---

## Sprint 2 - Kubernetes Foundation

**Goal:** Deploy application to local Kubernetes cluster

### Tasks

* [ ] Create deployments for frontend/backend
* [ ] Create ClusterIP services
* [ ] Remove localhost dependencies
* [ ] Validate service-to-service communication

### Deliverables

* Running app in Kubernetes
* Internal networking functional

---

## Sprint 3 - CI/CD + Image Strategy

**Goal:** Automate builds and deployments

### Tasks

* [ ] Implement image tagging with commit SHA
* [ ] Build + push images to registry
* [ ] Deploy using versioned images
* [ ] Remove reliance on "latest"

### Deliverables

* Repeatable builds
* Immutable image pipeline

---

## Sprint 4 - Production Readiness

**Goal:** Ensure reliability and external access

### Tasks

* [ ] Add readiness + liveness probes
* [ ] Configure rolling update strategy
* [ ] Implement Ingress for external access
* [ ] Validate zero-downtime deployments

### Deliverables

* Publicly accessible app
* Stable deployment behavior

---

## Sprint 5 - Advanced Automation (Python + Go)

**Goal:** Replace static CI/CD with programmable automation

### Tasks

* [ ] Build Python orchestrator (deploy.py)
* [ ] Integrate Go-based Kubernetes tooling
* [ ] Add rollout validation logic
* [ ] Implement automated rollback

### Deliverables

* Custom deployment engine
* API-driven infrastructure control
