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
<img width="3189" height="644" alt="conclusion" src="https://github.com/user-attachments/assets/5a294f85-334d-49eb-97ae-7007260ccc60" />

    * *Configuration:* Strict content filtering enabled; "Data logging" disabled to ensure inputs are not used for model training.
* **Vector Database:** **Azure AI Search** configured with **Hybrid Retrieval** (Vector + Keyword Search) and Semantic Reranking to maximize relevance.
<img width="2201" height="611" alt="connection_name" src="https://github.com/user-attachments/assets/5f7c3943-09bf-4fc8-8234-260a5734f48d" />

* **Orchestration:** Python-based backend utilizing **LangChain** for context window management and prompt engineering.
<img width="930" height="453" alt="Private_Endpoint" src="https://github.com/user-attachments/assets/ae2d9da2-0716-42fa-85fc-792b971ba4cb" />

### 💻 User Experience (Streamlit)
The frontend provides a chat interface supporting **real-time token streaming** and **source citations**, allowing users to verify AI answers against original documents.

### 📸 Screenshot 1: Secure Application Interface
*Demonstrating the RAG chatbot running successfully via Private IP (10.0.1.5). Note the citation functionality which grounds the AI response in factual data.*

<img width="100%" alt="app_demo" src="https://github.com/user-attachments/assets/1822a9ee-a577-4a57-b3cd-493043ebf63f">

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
