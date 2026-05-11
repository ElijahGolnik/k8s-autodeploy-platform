# Architecture Overview (Subject to change)

## Core Objective

Define the structure and interaction of all system components.

---

## System Layers

### 1. Application Layer

* **Frontend**: React application served via NGINX
* **Backend**: Node.js API
* **Database**: MongoDB (official container)

---

### 2. Container Layer

Each component is containerized:

```text
Frontend -> NGINX container
Backend  -> Node container
MongoDB  -> Official image
```

---

### 3. Kubernetes Layer

#### Deployments

* Manage pod lifecycle
* Enable scaling and rolling updates

#### Services

* Provide stable internal networking
* Enable service-to-service communication

#### Ingress

* Exposes application externally
* Routes traffic to frontend

---

## Networking Model (Top -> Bottom)

```text
User
 |
Ingress
 |
Frontend Service -> Frontend Pods
 |
Backend Service -> Backend Pods
 |
MongoDB Service -> MongoDB Pod
```

---

## Automation Layer

### Python Orchestrator

* Controls deployment workflow
* Handles build, deploy, verify, rollback

### Go Tooling

* Direct interaction with Kubernetes API
* High-performance operations (deploy, scale, health checks)

---

## Deployment Model (WIP for security)

* Immutable images (tagged by commit SHA)
* Rolling updates (zero downtime)
* Readiness probes control traffic routing

---

## Design Principles (WIP)

### 1. Separation of Concerns

Each component has a single responsibility

---

### 2. Immutable Infrastructure

No modification after deployment—only replacement

---

### 3. Declarative + Programmatic Hybrid

* YAML defines desired state
* Python/Go enforce and adapt it dynamically

---

### 4. Fault Tolerance

* Failed pods are replaced automatically
* Failed deployments are rolled back

---

### 5. Scalability

* Services scale independently
* Kubernetes schedules workloads efficiently

---

## Resulting Deployment and Production System

A cloud-native platform capable of:

* Automated deployments
* Resilient service communication
* Zero-downtime updates
* Programmatic infrastructure control
