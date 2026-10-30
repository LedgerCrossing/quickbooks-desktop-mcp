#!/usr/bin/env bash
# List the first 10 customers from QuickBooks Desktop through LedgerCrossing.
# LC_URL: http://localhost:8284 on the QuickBooks machine, its name on the office network,
# or your LedgerCrossing Remote / tunnel address from anywhere.
LC_URL="${LC_URL:-http://localhost:8284}"
LC_KEY="${LC_KEY:?Set LC_KEY to the API key from Settings > Allowed Connections}"

curl -s "$LC_URL/api/v1/qbxml" \
  -H "X-Api-Key: $LC_KEY" \
  -H "Content-Type: application/json" \
  -d '{"qbxml": "<?xml version=\"1.0\"?><?qbxml version=\"13.0\"?><QBXML><QBXMLMsgsRq onError=\"stopOnError\"><CustomerQueryRq><MaxReturned>10</MaxReturned></CustomerQueryRq></QBXMLMsgsRq></QBXML>"}'
