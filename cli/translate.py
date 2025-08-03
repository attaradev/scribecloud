import os
import sys
import json
import requests
import textwrap
from dotenv import load_dotenv
from cli.auth import load_token

load_dotenv()

API_BASE = os.environ.get(
    "SCRIBE_API_URL",
    "https://uttgyjyyy7.execute-api.us-east-1.amazonaws.com/dev"
)


def translate_text(source="en", target=None, text=None, output_json=False, use_rich=False):
    if not text and not sys.stdin.isatty():
        text = sys.stdin.read().strip()

    if not target or not text:
        print("❌ You must provide both a target language and text.")
        return

    token = load_token()
    if not token or "access_token" not in token:
        print("❌ You must run `python -m cli configure` first.")
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

    try:
        resp = requests.post(f"{API_BASE}/translate",
                             json=payload, headers=headers)
        resp.raise_for_status()
        data = resp.json()
        translated = data.get("translated_text")

        if output_json:
            print(json.dumps(data, indent=2))
        elif translated:
            wrapped = "\n".join(textwrap.wrap(translated, width=80))
            if use_rich:
                try:
                    from rich import print as rich_print
                    rich_print(
                        f"[bold green]✅ Translated text:[/bold green]\n{wrapped}")
                except ImportError:
                    print("✅ Translated text:\n" + wrapped)
            else:
                print("✅ Translated text:\n" + wrapped)
        else:
            print("⚠️ Translation succeeded but no text returned.")

    except requests.exceptions.HTTPError as http_err:
        print(f"❌ HTTP error {resp.status_code}: {resp.text}")
    except requests.exceptions.RequestException as req_err:
        print(f"❌ Request failed: {req_err}")
    except ValueError:
        print("❌ Response was not valid JSON.")
