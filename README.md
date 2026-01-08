# Enterprise Secure RAG Solution on Azure (DevSecOps Edition)

![Build Status](https://github.com/SheiroQi/azure-enterprise-secure-rag/actions/workflows/terraform-security.yml/badge.svg)

A production-ready **Retrieval-Augmented Generation (RAG)** solution designed for highly regulated industries (Healthcare/Finance). 

This project bridges the gap between **AI Innovation** and **Enterprise Governance**, demonstrating how to deploy **GPT-4o** and **Vector Search** capabilities within a **Zero Trust** infrastructure boundary.

**Target Compliance Standards:** HIPAA / ISO 27001 (Simulated)

---

## 💡 The Business Scenario (AI Workload)

The core application addresses the challenge of **"Safe Enterprise AI"** — enabling internal teams to query proprietary knowledge bases without data leakage or hallucinations.

* **🤖 Generative AI Engine:** Utilizes **Azure OpenAI (GPT-4o)** for high-fidelity natural language synthesis.
* **🧠 Semantic Search:** Integrates **Azure AI Search** with Vector/Hybrid retrieval to ground model responses in factual enterprise data.
* **📚 RAG Architecture:** Implements the "Retrieve-then-Generate" pattern to ensure auditability and provide citations for every answer.
* **💻 Application Interface:** A Python-based **Streamlit** frontend serves as the user interaction layer, demonstrating real-time streaming and citation rendering.

---

## 🛡️ DevSecOps & Governance Workflow

To support this AI workload securely, the project implements a **Shift-Left Security** strategy. Infrastructure is treated as software with strict quality gates.

```mermaid
graph LR
    A[Dev Commit] -->|Push| B(GitHub Actions);
    B --> C{Checkov Security Scan};
    C -->|Pass| D[Terraform Plan];
    C -->|Fail - High Sev| E[Block Pipeline];
    D --> F[Ready for Apply];