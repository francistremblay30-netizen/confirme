#!/usr/bin/env sh
# Confirme — plain HTTP examples. Free during launch (200 calls/day per IP).
B="https://www.synapseconnexion.com/ia"

# Is this page online?
curl -s "$B/confirme/page?url=https://example.com" | head -c 1200; echo

# Domain facts (registrar, expiry, DNS, SPF, DMARC)
curl -s "$B/confirme/domaine?domaine=example.com" | head -c 1200; echo

# Can this address receive? (no mail sent)
curl -s "$B/confirme/courriel?courriel=someone@example.com" | head -c 800; echo

# Heartbeat at the END of a successful scheduled run (choose a secret key, 8-80 chars)
curl -s -X POST "$B/confirme/battement" -H "Content-Type: application/json" \
  -d '{"cle":"my-nightly-report-9f3k","note":"report sent"}' | head -c 600; echo

# Did it run in the last 25 hours?
curl -s "$B/confirme/tache?cle=my-nightly-report-9f3k&depuis=90000" | head -c 800; echo

# Self-test of the signing chain, then verify the receipt (both free, not counted)
curl -s "$B/autotest" > /tmp/autotest.json
python3 -c 'import json,sys; json.dump(json.load(open("/tmp/autotest.json"))["recu"], open("/tmp/recu.json","w"))'
curl -s -X POST "$B/verifier" -H "Content-Type: application/json" --data-binary @/tmp/recu.json; echo
