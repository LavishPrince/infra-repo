# Network Port Standardization Architecture

This document defines the standardized port allocation strategy for our single-server infrastructure. All deployed applications, APIs, databases, and DevOps tools must strictly adhere to these ranges to prevent port collisions and simplify firewall management.

## 📂 Port Allocation Matrix (Functional Blocks)

We use a **Functional Allocation Strategy** where ports are grouped by the underlying service layer rather than the individual project. 

| Port Range | Service Category | Typical Use Cases |
| :--- | :--- | :--- |
| **3000 – 3999** | **Web Frontends** | User-facing UIs, SSR frameworks (Next.js, Remix), static site servers. |
| **5000 – 5999** | **Databases & Caches** | Persistent storage, key-value stores (PostgreSQL, Redis, MongoDB). |
| **8000 – 8999** | **Application APIs** | Core backend logic, REST APIs, GraphQL endpoints, gRPC services. |
| **9000 – 9499** | **Monitoring & DevOps** | Metrics, logs, container management (Prometheus, Grafana, Portainer). |
| **9500 – 9999** | **Internal Service Mesh** | Private, non-public microservice-to-microservice communication. |

---

## 🔒 Security & Deployment Rules

1. **The Edge Boundary:** Only ports `80` (HTTP) and `443` (HTTPS) are permitted to accept external traffic from the public internet. 
2. **Reverse Proxy Enforcement:** All applications must be routed through the reverse proxy (e.g., Nginx, Caddy, Traefik). External domain mappings must point internally to localhost (e.g., `://example.com` $\rightarrow$ `127.0.0.1:8080`).
3. **Local Loopback Binding:** Unless a service explicitly requires broad internal network access, always bind the service host to `127.0.0.1` (localhost) or use isolated internal bridge networks if deploying via Docker. Do **not** bind to `0.0.0.0`.
4. **Protected Ephemeral Range:** Do not assign permanent services to ports **49152–65535**. This range is reserved by the Linux kernel for dynamic outbound connections.
