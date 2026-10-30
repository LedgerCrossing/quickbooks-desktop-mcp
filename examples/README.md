# Examples

Every example needs LedgerCrossing installed on the QuickBooks machine, QuickBooks running, and
the API key from **Settings > Allowed Connections**. Set `LC_URL` to reach it from elsewhere: the
machine's name on your office network, or your LedgerCrossing Remote or tunnel address from anywhere.
Over Remote, the owner must first turn on **Allow the API key** (**Settings > Allowed Connections >
Internet**), which is off by default.

| File | What it shows |
|---|---|
| `http/customer-query.sh` | curl: run a qbXML query |
| `http/validate.sh` | curl: validate qbXML without touching QuickBooks |
| `http/customer_query.py` | Python, standard library only |
| `http/customer-query.mjs` | Node.js 18+ |
| `http/Customer-Query.ps1` | PowerShell |
| `mcp-configs/claude_desktop_config.json` | Claude Desktop, stdio mode (same machine) |
| `mcp-configs/cursor-mcp.json` | Cursor (`.cursor/mcp.json`) |
| `mcp-configs/vscode-mcp.json` | VS Code (`.vscode/mcp.json`) |

Queries should be bounded (`MaxReturned`, a date range, or similar). LedgerCrossing refuses
unbounded queries by default.
