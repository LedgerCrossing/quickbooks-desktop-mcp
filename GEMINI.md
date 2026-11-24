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
  `read_quickbooks` or `write_quickbooks`. Validate every request before you run it, and send exactly
  the request that passed.
- Start every request with `<?xml version="1.0"?>` then `<?qbxml version="13.0"?>`. The qbXML
  version is 13.0, not 1.0.
- By default each request names its company file. If the user hasn't said which file, check
  `get_status`, and if it doesn't show one, ask the user. Don't search the computer for it.
- Pass `company_file` as a plain Windows path. A network path starts with two backslashes and has
  single backslashes after that (`\\server\share\Company.qbw`). Never send the doubled backslashes
  of an escaped JSON string.
- Reach QuickBooks only through the ledgercrossing tools. Never open LedgerCrossing's settings or log
  files, or the company file itself, with shell or file tools: the settings hold keys, and those files
  are not a way into the books.
- A list or transaction query with no limit is stopped before it reaches QuickBooks. Set one.
- To filter by a customer that has jobs, use `FullNameWithChildren`, not `FullName`: sales are usually
  recorded on the jobs, so `FullName` on the parent customer can return nothing.
- Most standard reports are a report type inside one of two operations: `GeneralSummaryReportQuery`
  (for example ProfitAndLossStandard, SalesByCustomerSummary, ExpenseByVendorSummary) and
  `GeneralDetailReportQuery` (for example ExpenseByVendorDetail). Searching `list_operations` for a
  report's name, such as "vendor", finds nothing. Open those two with `get_operation` and pick the
  report type there.
- Ask for the smallest report that answers the question: one total column rather than one per month
  or week (unless the user asked for the trend), and only the dates asked about. Check the report's
  column options with `get_operation`. To compare two years, run one total-only report per year
  rather than one report with a column per year. Gemini CLI cuts any tool result over 40,000
  characters, and a monthly report can be several times that. If a result is cut anyway, ask
  QuickBooks again for a smaller report; don't parse the saved output with shell tools or scripts.
- `write_quickbooks` changes the user's books: adds, changes, deletes and voids. Use it only when the
  user asked for a change, and say what you will change before you call it.
- If QuickBooks returns a status code, call `explain_error` before you retry.
- `run_qbxml` no longer exists (replaced in LedgerCrossing 1.16.0). Use `read_quickbooks` or
  `write_quickbooks`.

Docs: https://ledgercrossing.com/docs/mcp
