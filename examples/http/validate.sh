#!/usr/bin/env bash
# Check a qbXML request against the operation catalog without touching QuickBooks.
# Accepts {"qbxml": "..."} or a raw XML body.
LC_URL="${LC_URL:-http://localhost:8284}"
LC_KEY="${LC_KEY:?Set LC_KEY to the API key from Settings > Allowed Connections}"

curl -s "$LC_URL/api/v1/validate" \
  -H "X-Api-Key: $LC_KEY" \
  -H "Content-Type: application/xml" \
  --data-binary '<?xml version="1.0"?><?qbxml version="13.0"?><QBXML><QBXMLMsgsRq onError="stopOnError"><InvoiceQueryRq><MaxReturned>5</MaxReturned><PaidStatus>NotPaidOnly</PaidStatus></InvoiceQueryRq></QBXMLMsgsRq></QBXML>'
