# mcp_agent/agent_memory.py

from membase.memory.multi_memory import MultiMemory
from membase.memory.message import Message
from membase.knowledge.chroma import ChromaKnowledgeBase
from membase.knowledge.document import Document
import sys

# 🧠 إعداد MultiMemory لتخزين الذاكرة في Unibase
mm = MultiMemory(
    membase_account="default",
    auto_upload_to_hub=True,
    preload_from_hub=True
)

# 📚 إعداد Knowledge Base لحفظ المعرفة المستخلصة
kb = ChromaKnowledgeBase(
    persist_directory="/tmp/ainon_kb", 
    membase_account="default",
    auto_upload_to_hub=True
)

# 🧠 تسجيل الذاكرة + 📚 تسجيل المعرفة
def save_to_membase(wallet, action, strategy, amount):
    # حفظ في Unibase memory
    msg = Message(
        name="AinonAgent",
        content=f"User performed {action} of {amount} BNB with strategy {strategy}",
        role="assistant",
        metadata={
            "wallet": wallet,
            "strategy": strategy,
            "amount": amount
        }
    )
    mm.add(msg, wallet)

    # حفظ في قاعدة المعرفة
    doc = Document(
        content=f"Executed {strategy} strategy via {action} of {amount} BNB",
        metadata={"wallet": wallet, "action": action, "source": "AinonAgent"}
    )
    kb.add_documents(doc)

    print("✅ Memory & Knowledge saved successfully.")

# 🏁 تشغيل مباشر لو تم استدعاء السكربت من Node.js أو من CLI
if __name__ == "__main__":
    if len(sys.argv) < 5:
        print("Usage: python3 agent_memory.py <wallet> <action> <strategy> <amount>")
        sys.exit(1)

    wallet = sys.argv[1]
    action = sys.argv[2]
    strategy = sys.argv[3]
    amount = sys.argv[4]

    save_to_membase(wallet, action, strategy, amount)
