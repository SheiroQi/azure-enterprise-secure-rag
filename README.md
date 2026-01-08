# Enterprise Secure RAG Solution on Azure (DevSecOps Edition)

![Build Status](https://github.com/SheiroQi/azure-enterprise-secure-rag/actions/workflows/terraform-security.yml/badge.svg)

An enterprise-grade Generative AI infrastructure reference architecture. This project demonstrates **"Compliance-as-Code"** by integrating automated security scanning, **Zero Trust Networking**, and **Infrastructure as Code (IaC)** governance pipelines.

**Target Compliance Standards:** HIPAA / ISO 27001 (Simulated for Healthcare & Finance sectors)

---

## 🛡️ DevSecOps & Governance Workflow

This project moves beyond simple deployment by implementing a **Shift-Left Security** strategy. Every infrastructure change undergoes rigorous scanning before provisioning.

```mermaid
graph LR
    A[Dev Commit] -->|Push| B(GitHub Actions);
    B --> C{Checkov Security Scan};
    C -->|Pass| D[Terraform Plan];
    C -->|Fail - High Sev| E[Block Pipeline];
    D --> F[Ready for Apply];