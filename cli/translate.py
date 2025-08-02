import requests
from cli.auth import load_token

API_BASE = "https://api.scribecloud.app"

def translate_text(source, target, text):
    token = load_token()
    if not token:
        print("❌ You must run `scribecloud configure` first.")
        return

    headers = {
        "Authorization": f"Bearer {token['access_token']}",
        "Content-Type": "application/json"
    }

    payload = {
        "source_language": source,
        "target_language": target,
        "text": text
    }

    resp = requests.post(f"{API_BASE}/translate", json=payload, headers=headers)

    if resp.status_code == 200:
        print("✅ Translation:", resp.json().get("translated_text"))
    else:
        print(f"❌ Error {resp.status_code}: {resp.text}")
