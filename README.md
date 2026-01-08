# Enterprise Secure RAG Solution on Azure (DevSecOps Edition)

![Build Status](https://github.com/SheiroQi/azure-enterprise-secure-rag/actions/workflows/terraform-security.yml/badge.svg)

A production-ready **Retrieval-Augmented Generation (RAG)** solution designed for highly regulated industries (Healthcare/Finance). 

This project demonstrates the **"Full Stack Architect"** capability: from the **AI Application layer** (GPT-4o, Vector Search) down to the **Infrastructure layer** (Terraform, Private Link, Zero Trust), all governed by a **DevSecOps pipeline**.

**Target Compliance Standards:** HIPAA / ISO 27001 (Simulated)

---

## 💡 Part 1: The Business Workload (AI Innovation)

This architecture hosts a production-grade **Retrieval-Augmented Generation (RAG)** application designed to solve the "Enterprise Knowledge Gap." It enables employees to query internal proprietary documents securely without data leakage.

### 🧠 Core AI Architecture
* **Generative Engine:** **Azure OpenAI Service (GPT-4o)** deployed as a private instance.
    * *Configuration:* Strict content filtering enabled; "Data logging" disabled to ensure inputs are not used for model training.
* **Vector Database:** **Azure AI Search** configured with **Hybrid Retrieval** (Vector + Keyword Search) and Semantic Reranking to maximize relevance.
* **Orchestration:** Python-based backend utilizing **LangChain** for context window management and prompt engineering.

### 💻 User Experience (Streamlit)
The frontend provides a chat interface supporting **real-time token streaming** and **source citations**, allowing users to verify AI answers against original documents.

### 📸 Screenshot 1: Secure Application Interface
*Demonstrating the RAG chatbot running successfully via Private IP (10.0.1.5).*


<img width="100%" alt="app_demo" src="https://github.com/user-attachments/assets/1822a9ee-a577-4a57-b3cd-493043ebf63f">

Infrastructure as Code (Terraform)
All resources (Private Endpoints, Cognitive Services) are defined in Terraform Modules, ensuring reproducibility and drift control.

<img width="100%" alt="terraform_code" src="https://github.com/user-attachments/assets/8de22cee-3e14-4cce-aa04-849909192a9b">

Part 3: Architecture & Security Features

Zero Trust Networking (Perimeter Security)
Public Access Disabled: Both Azure OpenAI and AI Search services have public_network_access_enabled = false.

Private Link Enforcement: The Python application (Src) communicates with AI PaaS services exclusively through the Azure backbone via Private Endpoints (10.0.1.x).

Private Networking Validation
Validating in Azure Portal that the AI Service is accessible only via Private Endpoint. Public internet access is strictly blocked.

<img width="100%" alt="azure_private_link" src="https://github.com/user-attachments/assets/3cae3e19-1f49-4e90-bc40-4c8b6eda6c45">

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


