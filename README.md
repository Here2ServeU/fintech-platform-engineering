# NERP — Fintech Platform Engineering (Simulation)

> **Naweji Enterprise Reliability Platform (NERP)**

> Created and owned by **Emmanuel Naweji**

> Copyright (c) 2026. All rights reserved.

---

## About This Project

This project is a **simulation** of the **Naweji Enterprise Reliability Platform (NERP)** — a production-grade, multi-vertical platform engineering initiative created by **Rev. Dr. Emmanuel Naweji**.

The purpose of this simulation is to demonstrate how the NERP Fintech vertical operates in a local environment. It provides three containerized microservices that replicate the core transaction-processing, fraud-detection, and payment-gateway capabilities of the full NERP platform — without requiring any external infrastructure.

### What is NERP?

**NERP (Naweji Enterprise Reliability Platform)** is a unified framework for building, deploying, and operating mission-critical microservices across industries. It is owned and maintained by **Rev. Dr. Emmanuel Naweji**. NERP emerged from Ph.D. research in AI/ML, Robotics, and Quantum Computing applied to regulated environments such as healthcare systems and financial institutions.

NERP is built on three core principles:

- **Reliability-first design** — every service exposes health checks, metrics, and chaos-injection endpoints for resilience testing.
- **Domain-driven verticals** — each industry vertical (fintech, healthcare, etc.) is self-contained with its own services, data boundaries, and compliance posture.
- **Local-first development** — the entire stack runs on a single machine via Docker Compose with zero external dependencies.

### What does this simulation include?

This repository simulates the **NERP Fintech vertical**: three microservices that model real-time transaction processing, ML-based fraud scoring, and payment gateway interactions. All transaction data is held in memory — nothing is persisted — making it safe and simple for local experimentation.

## Architecture

```
┌────────────────────────────────────────────────────┐
│                   Presentation Layer               │
│                 Client / API Consumer              │
└───────────────────────┬────────────────────────────┘
                        │
┌───────────────────────▼────────────────────────────┐
│          NERP Transaction Engine :8090              │
│          Idempotent Processing & Routing            │
└──────────┬─────────────────────────┬───────────────┘
           │                         │
┌──────────▼──────────┐   ┌─────────▼──────────────┐
│  NERP Fraud         │   │  NERP Payment Gateway  │
│  Detector :8091     │   │  Simulator :8092       │
└─────────────────────┘   └────────────────────────┘
```

### Simulated Services

| Service                       | Port | Role                                                                 |
|-------------------------------|------|----------------------------------------------------------------------|
| **NERP Transaction Engine**   | 8090 | Orchestration core — receives, validates, and routes transactions    |
| **NERP Fraud Detector**       | 8091 | Scores transactions for fraud probability using configurable rules  |
| **NERP Payment Gateway**      | 8092 | Simulates processor interactions with chaos-injection support       |

## Prerequisites

- **Docker & Docker Compose** (for containerized testing), or
- **Python 3.11+** and `pip` (for running services directly)

## Quick Start

### Option A — Docker Compose (recommended)

```bash
docker compose up --build
```

All three NERP services build, start, and join a shared `nerp-fintech-net` bridge network automatically.

### Option B — Run locally without Docker

```bash
pip install -r requirements.txt
```

Then start each NERP service in its own terminal:

```bash
python transaction_engine.py        # → http://localhost:8090
python fraud_detector_service.py    # → http://localhost:8091
python payment_gateway_service.py   # → http://localhost:8092
```

## Verify Services

```bash
curl -s http://localhost:8090/health | python3 -m json.tool
curl -s http://localhost:8091/health | python3 -m json.tool
curl -s http://localhost:8092/health | python3 -m json.tool
```

Each health response includes `"platform": "NERP"` to confirm the simulated service identity.

## API Reference

### NERP Transaction Engine (`:8090`)

| Method | Endpoint                     | Description                          |
|--------|------------------------------|--------------------------------------|
| GET    | `/health`                    | Health check                         |
| GET    | `/metrics`                   | Transaction throughput and error rate |
| POST   | `/api/v1/transactions`       | Submit a transaction                 |
| GET    | `/api/v1/transactions`       | List recent transactions             |
| GET    | `/api/v1/settlement/status`  | Settlement batch status              |
| POST   | `/ops/chaos/latency`         | Inject processing latency            |
| POST   | `/ops/chaos/error`           | Inject processing errors             |

### NERP Fraud Detector (`:8091`)

| Method | Endpoint       | Description                            |
|--------|----------------|----------------------------------------|
| GET    | `/health`      | Health check (includes model version)  |
| GET    | `/metrics`     | Scoring stats, precision, recall       |
| POST   | `/score`       | Score a transaction for fraud          |
| POST   | `/model/swap`  | Hot-swap the active fraud model        |

### NERP Payment Gateway (`:8092`)

| Method | Endpoint                      | Description                         |
|--------|-------------------------------|-------------------------------------|
| GET    | `/health`                     | Health check                        |
| GET    | `/metrics`                    | Processing stats and currencies     |
| POST   | `/api/v1/process`             | Process a payment                   |
| POST   | `/api/v1/settlement/trigger`  | Trigger a settlement batch          |
| GET    | `/api/v1/settlement/batches`  | List settlement batches             |
| POST   | `/ops/chaos/latency`          | Inject gateway latency              |
| POST   | `/ops/chaos/error`            | Inject gateway errors               |
| POST   | `/ops/reset`                  | Reset all chaos injections          |

## Usage Examples

**Submit a transaction:**
```bash
curl -X POST http://localhost:8090/api/v1/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "account_id": "acct_001",
    "amount": 250.00,
    "currency": "USD",
    "merchant": "coffee_shop",
    "merchant_category_code": "5814",
    "channel": "pos"
  }'
```

**Score a transaction for fraud:**
```bash
curl -X POST http://localhost:8091/score \
  -H "Content-Type: application/json" \
  -d '{
    "transaction_id": "txn_abc123",
    "amount": 7500.00,
    "channel": "card_not_present",
    "country_code": "NG",
    "merchant_category_code": "6051"
  }'
```

**Process a payment through the gateway:**
```bash
curl -X POST http://localhost:8092/api/v1/process \
  -H "Content-Type: application/json" \
  -d '{
    "transaction_id": "txn_abc123",
    "amount": 250.00,
    "currency": "USD"
  }'
```

**Trigger a settlement batch:**
```bash
curl -X POST http://localhost:8092/api/v1/settlement/trigger
```

**Inject chaos — add 2-second gateway latency:**
```bash
curl -X POST http://localhost:8092/ops/chaos/latency \
  -H "Content-Type: application/json" \
  -d '{"delay_ms": 2000}'
```

**Reset chaos injections:**
```bash
curl -X POST http://localhost:8092/ops/reset
```

## Project Structure

```
├── docker-compose.yaml           # Orchestrates all NERP Fintech services
├── Dockerfile                    # NERP Transaction Engine image
├── Dockerfile.fraud              # NERP Fraud Detector image
├── Dockerfile.gateway            # NERP Payment Gateway image
├── requirements.txt              # Python dependencies
├── transaction_engine.py         # NERP Transaction Engine service
├── fraud_detector_service.py     # NERP Fraud Detector service
├── payment_gateway_service.py    # NERP Payment Gateway service
└── README.md
```

## Teardown

```bash
docker compose down
```

**Check container logs:**
```bash
docker compose logs nerp-transaction-engine --tail 20
docker compose logs nerp-fraud-detector --tail 20
docker compose logs nerp-payment-gateway --tail 20
```

## Next Steps: Making NERP Cloud-Ready

The following roadmap outlines how to evolve this local simulation into a production-grade cloud deployment.

### Step 1 — Externalize Configuration

Replace hardcoded environment variables with a centralized config strategy:

- Use a `.env` file or **HashiCorp Vault** for secrets (API keys, DB credentials, fraud thresholds).
- Inject configuration via environment variables at deploy time — never bake secrets into images.
- Introduce a shared `config.py` module that reads from `os.environ` with sensible defaults for local dev.

### Step 2 — Add Persistent Storage

The current simulation holds all data in memory. For cloud readiness:

- **Transaction Engine** → connect to **PostgreSQL** or **Amazon Aurora** for durable transaction records.
- **Fraud Detector** → integrate **Redis** for scoring cache and rate-limiting state.
- **Payment Gateway** → persist settlement batches to a database for audit trails.
- Use SQLAlchemy or a lightweight ORM to keep the migration path clean.

### Step 3 — Add Observability

Production services need more than `/health` and `/metrics`:

- **Structured logging** → ship JSON logs to **CloudWatch**, **Datadog**, or an **ELK stack**.
- **Distributed tracing** → instrument with **OpenTelemetry** and export to **Jaeger** or **AWS X-Ray**.
- **Metrics** → expose Prometheus-format metrics and scrape with **Prometheus + Grafana** or a managed equivalent.
- **Alerting** → define SLOs (e.g., p99 latency < 200ms, fraud scoring < 50ms) and alert on breaches.

### Step 4 — Secure the Services

- Add **API authentication** (JWT or API key middleware) to all endpoints.
- Enable **TLS termination** at the load balancer or API gateway level.
- Restrict `/ops/chaos/*` endpoints to internal networks or authenticated operators only.
- Run containers as non-root users in the Dockerfiles (`USER appuser`).
- Scan images for vulnerabilities with **Trivy** or **Snyk**.

### Step 5 — Containerize for Production

Update the Dockerfiles for production-grade builds:

- Use **multi-stage builds** to minimize image size.
- Pin exact dependency versions in `requirements.txt`.
- Add `HEALTHCHECK` instructions to each Dockerfile.
- Tag images with commit SHA or semantic version (not `latest`).

### Step 6 — Set Up CI/CD

Automate the build-test-deploy pipeline:

- **CI** (GitHub Actions, GitLab CI, or Jenkins):
  - Lint and unit test on every push.
  - Build and push Docker images to a container registry (ECR, GCR, Docker Hub).
  - Run integration tests against the Docker Compose stack.
- **CD** (ArgoCD, Flux, or pipeline-native deploy):
  - Deploy to a staging environment on merge to `main`.
  - Promote to production after approval or automated canary validation.

## Shipping to the Cloud

Once the services are cloud-ready, choose a deployment target and ship.

### Option A — Kubernetes (EKS / GKE / AKS)

This is the recommended path for production NERP deployments.

1. **Create Kubernetes manifests** (or Helm charts) for each service:
   - `Deployment` with resource limits, readiness/liveness probes, and replica count.
   - `Service` (ClusterIP) for internal communication between NERP services.
   - `Ingress` or `Gateway API` for external traffic routing.
   - `ConfigMap` and `Secret` for environment configuration.

2. **Push images to a container registry:**
   ```bash
   # Example: Amazon ECR
   aws ecr get-login-password | docker login --username AWS --password-stdin <account>.dkr.ecr.<region>.amazonaws.com
   docker build -t nerp-transaction-engine .
   docker tag nerp-transaction-engine:latest <account>.dkr.ecr.<region>.amazonaws.com/nerp-transaction-engine:v1.0.0
   docker push <account>.dkr.ecr.<region>.amazonaws.com/nerp-transaction-engine:v1.0.0
   ```

3. **Deploy to the cluster:**
   ```bash
   kubectl apply -f k8s/
   # or
   helm install nerp-fintech ./charts/nerp-fintech
   ```

4. **Set up autoscaling:**
   - Horizontal Pod Autoscaler (HPA) based on CPU/memory or custom metrics (e.g., transactions per second).

### Option B — Serverless Containers (AWS Fargate / Google Cloud Run)

A simpler path for teams that don't need full Kubernetes orchestration.

1. **Push images** to ECR or Artifact Registry.
2. **Define task/service definitions** with CPU, memory, port mappings, and environment variables.
3. **Deploy:**
   ```bash
   # Example: AWS Fargate via ECS
   aws ecs create-service \
     --cluster nerp-fintech \
     --service-name nerp-transaction-engine \
     --task-definition nerp-transaction-engine:1 \
     --desired-count 2 \
     --launch-type FARGATE
   ```
4. **Attach a load balancer** (ALB or Cloud Load Balancing) for traffic distribution and TLS.

### Option C — VM-Based (EC2 / Compute Engine)

For simpler deployments or regulated environments that require VM-level isolation.

1. **Provision VMs** with Docker installed.
2. **Copy `docker-compose.yaml`** and images to the host.
3. **Run:**
   ```bash
   docker compose up -d
   ```
4. Place behind a **load balancer** and configure **systemd** to restart services on failure.

### Cloud Deployment Checklist

| Task                                  | Status  |
|---------------------------------------|---------|
| Externalize secrets and config        | Pending |
| Add persistent database               | Pending |
| Instrument with OpenTelemetry         | Pending |
| Add authentication to API endpoints   | Pending |
| Production Dockerfile optimizations   | Pending |
| CI/CD pipeline configured             | Pending |
| Container images pushed to registry   | Pending |
| Kubernetes manifests or Helm charts   | Pending |
| TLS and domain configured             | Pending |
| Autoscaling and monitoring in place   | Pending |

---

**NERP — Naweji Enterprise Reliability Platform**
*This project simulates the NERP Fintech vertical for local development and testing.*
*Created and maintained Emmanuel Naweji. Copyright (c) 2026. All rights reserved.*
