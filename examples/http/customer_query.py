"""List the first 10 customers from QuickBooks Desktop through LedgerCrossing (standard library only)."""
import json
import os
import urllib.request

LC_URL = os.environ.get("LC_URL", "http://localhost:8284")
LC_KEY = os.environ["LC_KEY"]  # API key from Settings > Allowed Connections

QBXML = (
    '<?xml version="1.0"?><?qbxml version="13.0"?>'
    '<QBXML><QBXMLMsgsRq onError="stopOnError">'
    "<CustomerQueryRq><MaxReturned>10</MaxReturned></CustomerQueryRq>"
    "</QBXMLMsgsRq></QBXML>"
)

req = urllib.request.Request(
    f"{LC_URL}/api/v1/qbxml",
    data=json.dumps({"qbxml": QBXML}).encode(),
    headers={"X-Api-Key": LC_KEY, "Content-Type": "application/json"},
)
with urllib.request.urlopen(req) as resp:
    result = json.load(resp)

print(result["response"] if result.get("success") else result)
