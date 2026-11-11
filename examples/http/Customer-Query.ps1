# List the first 10 customers from QuickBooks Desktop through LedgerCrossing.
$LcUrl = if ($env:LC_URL) { $env:LC_URL } else { "http://localhost:8284" }
$LcKey = $env:LC_KEY  # API key from Settings > Allowed Connections
if (-not $LcKey) { throw "Set LC_KEY to the API key from Settings > Allowed Connections" }

$qbxml = '<?xml version="1.0"?><?qbxml version="13.0"?><QBXML><QBXMLMsgsRq onError="stopOnError"><CustomerQueryRq><MaxReturned>10</MaxReturned></CustomerQueryRq></QBXMLMsgsRq></QBXML>'

# By default each request names its company file (QuickBooks File page: The caller names the file in each request).
# To send it, use this -Body instead:
#   -Body (@{ qbxml = $qbxml; company_file = "C:\Users\Public\Documents\Intuit\QuickBooks\Company Files\MyCompany.qbw" } | ConvertTo-Json)
$result = Invoke-RestMethod -Method Post -Uri "$LcUrl/api/v1/qbxml" `
  -Headers @{ "X-Api-Key" = $LcKey } -ContentType "application/json" `
  -Body (@{ qbxml = $qbxml } | ConvertTo-Json)

if ($result.success) { $result.response } else { $result }
