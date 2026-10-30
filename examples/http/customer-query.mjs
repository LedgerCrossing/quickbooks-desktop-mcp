// List the first 10 customers from QuickBooks Desktop through LedgerCrossing (Node 18+).
const LC_URL = process.env.LC_URL ?? "http://localhost:8284";
const LC_KEY = process.env.LC_KEY; // API key from Settings > Allowed Connections

const qbxml =
  '<?xml version="1.0"?><?qbxml version="13.0"?>' +
  '<QBXML><QBXMLMsgsRq onError="stopOnError">' +
  "<CustomerQueryRq><MaxReturned>10</MaxReturned></CustomerQueryRq>" +
  "</QBXMLMsgsRq></QBXML>";

const res = await fetch(`${LC_URL}/api/v1/qbxml`, {
  method: "POST",
  headers: { "X-Api-Key": LC_KEY, "Content-Type": "application/json" },
  body: JSON.stringify({ qbxml }),
});
const result = await res.json();
console.log(result.success ? result.response : result);
