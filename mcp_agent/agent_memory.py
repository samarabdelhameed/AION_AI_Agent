from membase.memory.multi_memory import MultiMemory
from membase.memory.message import Message
import sys

# تهيئة الاتصال مع Unibase Membase
mm = MultiMemory(
    membase_account="default",
    auto_upload_to_hub=True,
    preload_from_hub=True
)

def save_to_membase(wallet, action, strategy, amount):
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
    print("✅ Memory saved to Unibase")

# تنفيذ مباشر عند الاستدعاء من Node.js أو terminal
if __name__ == "__main__":
    if len(sys.argv) < 5:
        print("Usage: python3 agent_memory.py <wallet> <action> <strategy> <amount>")
        sys.exit(1)

    wallet = sys.argv[1]
    action = sys.argv[2]
    strategy = sys.argv[3]
    amount = sys.argv[4]

    save_to_membase(wallet, action, strategy, amount)
