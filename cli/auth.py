import os
import json
import webbrowser
import requests
from http.server import BaseHTTPRequestHandler, HTTPServer
from threading import Thread
from urllib.parse import urlparse, parse_qs

from dotenv import load_dotenv
load_dotenv()

TOKEN_PATH = os.path.expanduser("~/.scribecloud/token.json")

# Read from environment
CLIENT_ID = os.getenv("SCRIBE_CLIENT_ID")
COGNITO_DOMAIN = os.getenv("SCRIBE_COGNITO_DOMAIN")
REDIRECT_PORT = int(os.getenv("SCRIBE_REDIRECT_PORT", "53120"))
REDIRECT_URI = f"http://localhost:{REDIRECT_PORT}/callback"

def save_token(token_data):
    os.makedirs(os.path.dirname(TOKEN_PATH), exist_ok=True)
    with open(TOKEN_PATH, "w") as f:
        json.dump(token_data, f)

def load_token():
    if os.path.exists(TOKEN_PATH):
        with open(TOKEN_PATH, "r") as f:
            return json.load(f)
    return None

class CallbackHandler(BaseHTTPRequestHandler):
    auth_code = None

    def do_GET(self):
        query = parse_qs(urlparse(self.path).query)
        if "code" in query:
            CallbackHandler.auth_code = query["code"][0]
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"Login successful. You may close this window.")
        else:
            self.send_response(400)
            self.end_headers()
            self.wfile.write(b"Login failed.")

def configure():
    if not CLIENT_ID or not COGNITO_DOMAIN:
        raise ValueError("Missing environment variables: SCRIBE_CLIENT_ID or SCRIBE_COGNITO_DOMAIN")

    print("🔐 Starting login flow...")

    def run_server():
        server = HTTPServer(('localhost', REDIRECT_PORT), CallbackHandler)
        server.handle_request()

    Thread(target=run_server, daemon=True).start()

    auth_url = (
        f"https://{COGNITO_DOMAIN}/login?"
        f"client_id={CLIENT_ID}&response_type=code&scope=email+openid+profile&"
        f"redirect_uri={REDIRECT_URI}"
    )

    print(f"🌍 Opening browser for login. If it doesn't open, visit:\n{auth_url}")
    webbrowser.open(auth_url)

    while CallbackHandler.auth_code is None:
        pass

    code = CallbackHandler.auth_code
    token_url = f"https://{COGNITO_DOMAIN}/oauth2/token"
    data = {
        "grant_type": "authorization_code",
        "client_id": CLIENT_ID,
        "code": code,
        "redirect_uri": REDIRECT_URI,
    }

    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    resp = requests.post(token_url, data=data, headers=headers)

    if resp.status_code == 200:
        save_token(resp.json())
        print("✅ Authenticated successfully.")
    else:
        print(f"❌ Failed to get tokens: {resp.text}")
