# List the first 10 customers from QuickBooks Desktop through LedgerCrossing.
$LcUrl = if ($env:LC_URL) { $env:LC_URL } else { "http://localhost:8284" }
$LcKey = $env:LC_KEY  # API key from Settings > Allowed Connections

$qbxml = '<?xml version="1.0"?><?qbxml version="13.0"?><QBXML><QBXMLMsgsRq onError="stopOnError"><CustomerQueryRq><MaxReturned>10</MaxReturned></CustomerQueryRq></QBXMLMsgsRq></QBXML>'

$result = Invoke-RestMethod -Method Post -Uri "$LcUrl/api/v1/qbxml" `
  -Headers @{ "X-Api-Key" = $LcKey } -ContentType "application/json" `
  -Body (@{ qbxml = $qbxml } | ConvertTo-Json)

if ($result.success) { $result.response } else { $result }
