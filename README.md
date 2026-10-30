# LedgerCrossing — MCP server and HTTP API for QuickBooks Desktop

<!-- mcp-name: com.ledgercrossing/quickbooks-desktop -->

LedgerCrossing gives QuickBooks Desktop (Pro, Premier, Enterprise) an HTTP/qbXML API and an MCP
server that your apps and AI agents can reach from anywhere: the same machine, your office
network, or the internet through [LedgerCrossing Remote](https://ledgercrossing.com/remote).

Claude, ChatGPT, Cursor, VS Code and any other MCP client get six tools covering all 240 qbXML
operations. Your own code gets `POST /api/v1/qbxml`: send qbXML, get qbXML back. No SOAP service
to host, and no Web Connector polling.

**This repository holds documentation, examples, the MCP Registry entry (`server.json`) and, in its
releases, the Claude Desktop extension bundle (`.mcpb`).** The LedgerCrossing app itself is a commercial Windows
app: a one-time purchase, licensed per machine, with unlimited company files. See
[ledgercrossing.com](https://ledgercrossing.com) for pricing. Its source is not in this repository, and
nothing here works without the app installed on the QuickBooks machine.

> **Compatibility:** LedgerCrossing works with anything that can make a web request. Off-the-shelf
> apps that sync through the Web Connector today are controlled by their vendors, and LedgerCrossing
> is not a replacement underneath them. If you (or your developer) control the integration,
> switching is straightforward: send the same qbXML you send today as an HTTP POST.

## Why QuickBooks Desktop needs this

QuickBooks Desktop has no cloud API. It accepts qbXML only through a COM interface on the machine
where it runs. Intuit's official AI connectors cover QuickBooks Online, not Desktop. LedgerCrossing
runs beside QuickBooks on that machine and turns it into an endpoint your tools can call.

## Connect an AI client

Pick the path by where the AI runs relative to the QuickBooks computer.

| Client | From | How | Needs |
|---|---|---|---|
| Claude Desktop | the QuickBooks computer | [`.mcpb` bundle](#claude-desktop) | nothing to copy |
| Claude Desktop | another computer in the office | `.mcpb` bundle + address and API key | **Settings > Allowed Connections > Local network** turned on |
| claude.ai, ChatGPT, Meta Muse | anywhere | [LedgerCrossing Remote](https://ledgercrossing.com/docs/connect) ($39/mo) | per-person sign-in (OAuth); Meta Muse needs LedgerCrossing 1.15.1 or later |
| Claude Code, Cursor, VS Code | any of the above | [HTTP config](#claude-code-cursor-vs-code) | MCP URL + API key (same machine or office); sign-in over Remote |
| Codex, Gemini CLI | the QuickBooks computer or the office | [quickstart](https://ledgercrossing.com/docs/mcp#codex-and-gemini-cli) | nothing on the QuickBooks computer (stdio); MCP URL + API key from another computer |

The MCP endpoint is `http://<machine>:8284/mcp` (streamable HTTP). **Settings > Allowed
Connections** in the app shows the exact address and the API key.

### Claude Desktop

1. Download `ledgercrossing.mcpb` from this repository's
   [latest release](../../releases/latest).
2. In Claude Desktop open **Settings > Extensions > Advanced settings > Extension Developer >
   Install Extension…** and pick the file. (Windows has no file association for `.mcpb`, so
   double-clicking it won't work.)
3. Leave the settings at their defaults on the QuickBooks computer. On another office computer, set
   **LedgerCrossing address** (for example `http://qb-server:8284`) and paste the **API key**.

Prefer a config file? See [`examples/mcp-configs/claude_desktop_config.json`](examples/mcp-configs/claude_desktop_config.json)
(stdio mode, same machine only).

### Claude Code, Cursor, VS Code

```
claude mcp add --transport http quickbooks http://localhost:8284/mcp --header "X-Api-Key: YOUR_KEY"
```

Cursor and VS Code configs are in [`examples/mcp-configs/`](examples/mcp-configs/). From another
office computer, replace `localhost` with the machine's name. From anywhere, connect over
LedgerCrossing Remote with per-person sign-in, the same way as claude.ai (see
[/docs/connect](https://ledgercrossing.com/docs/connect)).

Then ask: *"Which customers are 60+ days overdue?"*

## The six tools

| Tool | What it does |
|---|---|
| `list_operations` | Lists or searches the 240 qbXML operations, with category and minimum QuickBooks version |
| `get_operation` | Full field reference for one operation: element order, required fields, max lengths, enums |
| `validate_qbxml` | Checks a request against the catalog without touching QuickBooks |
| `run_qbxml` | Runs the qbXML in QuickBooks Desktop and returns the response |
| `explain_error` | Turns a QuickBooks status code into what went wrong and what to change |
| `get_status` | Is QuickBooks up, which company file is open, is the bridge connected |

The agent discovers what it needs on demand (`list_operations` → `get_operation` →
`validate_qbxml` → `run_qbxml`), so the catalog never floods its context.

**Before you connect an agent:** it can write. On the QuickBooks computer and the office network,
`run_qbxml` can create invoices, payments and edits, with the same power as the HTTP API. Over
LedgerCrossing Remote, each person starts read-only until the owner allows changes. Unbounded
queries are refused by default,
and QuickBooks' Audit Trail records every posted transaction. Connect agents you trust, to company
files you mean them to touch.

## Call it from your own code

```bash
curl -s http://localhost:8284/api/v1/qbxml \
  -H "X-Api-Key: YOUR_KEY" -H "Content-Type: application/json" \
  -d '{"qbxml": "<?xml version=\"1.0\"?><?qbxml version=\"13.0\"?><QBXML><QBXMLMsgsRq onError=\"stopOnError\"><CustomerQueryRq><MaxReturned>10</MaxReturned></CustomerQueryRq></QBXMLMsgsRq></QBXML>"}'
```

More in [`examples/`](examples/): Python, Node.js and PowerShell, plus validating a request
before sending it.

| Endpoint | Purpose |
|---|---|
| `POST /api/v1/qbxml` | Run a qbXML request |
| `POST /api/v1/validate` | Validate qbXML against the catalog, no QuickBooks round-trip |
| `GET /api/v1/docs?search=` | Search the operation catalog |
| `GET /api/v1/docs/{operation}` | Field reference for one operation, e.g. `CustomerQuery` |
| `GET /api/v1/errors/{code}` | Explain a QuickBooks status code |
| `GET /api/v1/health` | Liveness check |
| `POST /mcp` | MCP endpoint (streamable HTTP) |

## Reach it from anywhere

- **Same machine:** `http://localhost:8284`.
- **Office network:** turn on **Settings > Allowed Connections > Local network**; the app requires
  an API key first and manages its own firewall rule. Free.
- **Internet:** [LedgerCrossing Remote](https://ledgercrossing.com/remote) ($39/mo), a managed
  HTTPS relay with per-person sign-in, which claude.ai and ChatGPT require (Meta Muse is verified
  over it too). Or run your own tunnel
  with the [free guide](https://ledgercrossing.com/docs/quickbooks-remote-access-cloudflare-tunnel)
  for clients that can send an API key header.

## Requirements

- Windows 10 or 11, or Windows Server 2016–2025, with QuickBooks Desktop Pro, Premier or Enterprise.
- QuickBooks running with the company file open (or auto-openable). That is a QuickBooks Desktop
  constraint.
- LedgerCrossing installed and activated on that machine (1.15.1 or later for Meta Muse).

## Links

- Product and pricing: https://ledgercrossing.com
- MCP quickstart: https://ledgercrossing.com/docs/mcp
- Connect Claude to QuickBooks Desktop, every option compared: https://ledgercrossing.com/connect-claude-to-quickbooks-desktop
- claude.ai and ChatGPT setup: https://ledgercrossing.com/docs/connect
- Support: support@ledgercrossing.com

## License

The documentation, examples and `server.json` in this repository are MIT licensed (see
[LICENSE](LICENSE)). The LedgerCrossing app and the `.mcpb` bundle are commercial software,
licensed per machine under the terms at [ledgercrossing.com](https://ledgercrossing.com). The MIT
license does not cover them.

---

QuickBooks is a registered trademark of Intuit Inc. LedgerCrossing is an independent product for
QuickBooks Desktop and is not affiliated with or endorsed by Intuit. Client names belong to their
respective owners.
