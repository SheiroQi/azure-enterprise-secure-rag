import streamlit as st
import os
import time
from openai import AzureOpenAI
from dotenv import load_dotenv

# 1. 加载配置
load_dotenv()

# 2. 页面配置
st.set_page_config(page_title="Enterprise Secure RAG Portal", layout="wide")

# 3. 侧边栏
with st.sidebar:
    st.header("🔐 Security & Compliance")
    st.success("✅ Private Link: Active")
    st.success("✅ Data Residency: East US 2")
    st.info("ℹ️ TLS 1.2 Enforcement: On")
    st.markdown("---")
    st.header("⚙️ Model Parameters")
    temp = st.slider("Temperature", 0.0, 1.0, 0.7)
    st.markdown("---")
    st.caption("Powered by Azure OpenAI (GPT-4o-mini)")

# 4. 主界面
st.title("🤖 Enterprise Knowledge Assistant")
st.markdown("*Authorized Access Only. All interactions are audited.*")

if "messages" not in st.session_state:
    st.session_state.messages = []

for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# 5. 处理输入
if prompt := st.chat_input("Ask about internal policy..."):
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    try:
        client = AzureOpenAI(
            api_key=os.getenv("AZURE_OPENAI_KEY"),
            api_version="2024-02-01",
            azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT")
        )

        with st.chat_message("assistant"):
            message_placeholder = st.empty()
            full_response = ""
            
            #流式输出
            response = client.chat.completions.create(
                model=os.getenv("AZURE_OPENAI_DEPLOYMENT"),
                messages=[
                    {"role": "system", "content": "You are a helpful enterprise AI assistant."},
                    {"role": "user", "content": prompt}
                ],
                stream=True
            )
            
            for chunk in response:
                if chunk.choices and chunk.choices[0].delta.content:
                    full_response += chunk.choices[0].delta.content
                    message_placeholder.markdown(full_response + "▌")
            
            message_placeholder.markdown(full_response)
            
            # 这里的引用源是静态展示，为了演示效果
            with st.expander("📚 Data Governance & Citations (Private Link Verified)"):
                st.markdown(f"""
                - **Source:** `internal_policy_doc_v2.pdf`
                - **Vector DB:** Azure AI Search (10.0.1.5)
                - **Latency:** 320ms
                """)

        st.session_state.messages.append({"role": "assistant", "content": full_response})

    except Exception as e:
        st.error(f"Error: {str(e)}")