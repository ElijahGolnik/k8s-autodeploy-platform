### k8s-autodeploy-platform
 
## 1. Core infrastructure
* [x] Dockerize my Frontend and Backend
* [x] Deploy basic Kubernetes
* [x] Getting a local cluster working

## 2. Networking and Services
* [x] Implement Kubernetes Services and DNS communication
* [ ] Remove any localhost dependencies
* [x] Validating all internal connectivity between pods and services

## 3. CI/CD Pipeline Implementation
* [x] Deploy a working pipeline capable of reaching a localhost domain and transferring data from a connected database, and ensure that Kubernetes and Docker always run.
* [ ] Deploy a working pipeline to a cloud registry (Still determining which to work with, as AWS, Azure, and anything besides GitHub public repos cost money)
* [x] Implementing SHA256 Version tagging rather than using the "Latest" tag

## 4. Production Readiness
* [x] Implementing Ingress
* [x] Using simple YAML scripts to perform pod health checks and replacements
* [x] Implementing consistent rolling updates without downtime

## 5. Advanced Automation
* [ ] Using Go tools and scripts to further my project's business appearance
* [ ] Implementing Rollback and Code/Script Verification and security logic

## Application Changes:

#Version 0.5
* Implemented complete memory recovery and picks up where it was left off if Kubernetes or Docker ever went down.
* Implemented Ingress for domain help and allowed me to construct my own local domain application
* Used Kustomize to ensure backups are SHA-Tagged.
* Changed from multi-containers to stacking my frontend and backend to my main application, speeding up startup.
* Implemented a way to create users through the database and pass it through all the way to the front end to see clearly on the local domain.
* Shrank Dockerfile to package everything up, build, and send to GitHub for checking.
* Utilized Traefik to act as a cloud API delivery for later


## Startup

#Run Docker/Kubernetes
 * Cluster restores itself from its previous backup, which happens every 36 hours.
 * Open VS Code with the correct repository applied.
 * Open up MongoDB Compass
 * Launch the initial pipeline starter command. - Docker Compose Up
 * Auto-connects the database to the cluster and Docker
 * Automatically runs health checks, pod checks, and backup logs to ensure that there are no issues between versions.
 * Check the Image retention to ensure shell scripts are automatically culling any previous bad versions

## Version Updates
* V0.01
* V0.5 Alpha
  
## Fixes / Changes
