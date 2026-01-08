# Enterprise Secure RAG Solution on Azure (DevSecOps Edition)

![Build Status](https://github.com/SheiroQi/azure-enterprise-secure-rag/actions/workflows/terraform-security.yml/badge.svg)

A production-ready **Retrieval-Augmented Generation (RAG)** solution designed for highly regulated industries (Healthcare/Finance). 

This project demonstrates the **"Full Stack Architect"** capability: from the **AI Application layer** (GPT-4o, Vector Search) down to the **Infrastructure layer** (Terraform, Private Link, Zero Trust), all governed by a **DevSecOps pipeline**.

**Target Compliance Standards:** HIPAA / ISO 27001 (Simulated)

---

## 💡 Part 1: The Business Workload (AI Innovation)

The core application enables internal teams to query proprietary knowledge bases securely. It uses the "Retrieve-then-Generate" pattern to ensure answers are grounded in factual data with citations.

* **🤖 Engine:** Azure OpenAI (GPT-4o) + Azure AI Search (Vector).
* **💻 Interface:** Python (Streamlit) frontend with real-time streaming.

### 📸 Screenshot 1: Secure Application Interface
*Demonstrating the RAG chatbot running successfully via Private IP (10.0.1.5), proving the application logic is fully functional.*
<img width="100%" alt="app_demo" src="[https://github.com/user-attachments/assets/1822a9ee-a577-4a57-b3cd-493043ebf63f](https://github.com/user-attachments/assets/1822a9ee-a577-4a57-b3cd-493043ebf63f)">

---

## 🛡️ Part 2: The Governance Layer (DevSecOps)

To support this AI workload securely, the project implements a **Shift-Left Security** strategy. Infrastructure is treated as software with strict quality gates.

```mermaid
graph LR
    A[Dev Commit] -->|Push| B(GitHub Actions);
    B --> C{Checkov Security Scan};
    C -->|Pass| D[Terraform Plan];
    C -->|Fail - High Sev| E[Block Pipeline];
    D --> F[Ready for Apply];