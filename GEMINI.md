# LedgerCrossing: QuickBooks Desktop

The `ledgercrossing` MCP server connects you to QuickBooks Desktop through LedgerCrossing, a Windows
app on the QuickBooks computer. Requests are Intuit qbXML. QuickBooks must be running with the
company file open (or auto-openable).

## Tools

| Tool | What it does |
|---|---|
| `list_operations` | Lists or searches the 240 qbXML operations, with category and minimum QuickBooks version |
| `get_operation` | Full field reference for one operation (element order, required fields, max lengths, enums), plus a minimal example request |
| `validate_qbxml` | Checks a request against the catalog without touching QuickBooks |
| `read_quickbooks` | Runs a query or report in QuickBooks Desktop and returns the response. Refuses any request that would change data |
| `write_quickbooks` | Adds, modifies, deletes or voids records in QuickBooks Desktop. Refuses requests that change nothing |
| `explain_error` | Turns a QuickBooks status code into what went wrong and what to change |
| `get_status` | Is QuickBooks up, which company file is open, is the bridge connected |

## How to work

- Find what you need on demand: `list_operations`, then `get_operation`, then `validate_qbxml`, then
  `read_quickbooks` or `write_quickbooks`. Validate every request before you run it.
- By default each request names its company file. If the user hasn't said which file, ask, or check
  `get_status`.
- A list or transaction query with no limit is stopped before it reaches QuickBooks. Set one.
- `write_quickbooks` changes the user's books: adds, changes, deletes and voids. Use it only when the
  user asked for a change, and say what you will change before you call it.
- If QuickBooks returns a status code, call `explain_error` before you retry.
- `run_qbxml` no longer exists (replaced in LedgerCrossing 1.16.0). Use `read_quickbooks` or
  `write_quickbooks`.

Docs: https://ledgercrossing.com/docs/mcp
