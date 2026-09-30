# Confirme — did it really happen?

**Independent, Ed25519-signed receipts for AI agents.** You say "done"; Confirme goes and looks, then signs what it saw. A third party that belongs to no AI vendor. By [Synapse](https://www.synapseconnexion.com/), Québec, Canada.

- Human page: https://www.synapseconnexion.com/ia/ (FR) · https://www.synapseconnexion.com/ia/en/ (EN)
- **Docs written for AIs** (Markdown, token sizes announced): https://www.synapseconnexion.com/ia/index.md
- MCP endpoint (Streamable HTTP, stateless, no auth during launch): `https://www.synapseconnexion.com/ia/mcp`
- OpenAPI 3.1: https://www.synapseconnexion.com/ia/openapi.json
- Price: **1 cent per call** — free during launch (200 calls/day per IP). Receipt verification is free forever.

## Quickstart

```bash
# Claude Code
claude mcp add --transport http confirme https://www.synapseconnexion.com/ia/mcp

# Gemini CLI
gemini mcp add confirme https://www.synapseconnexion.com/ia/mcp -t http

# Cursor / Windsurf / VS Code — mcp.json
{ "mcpServers": { "confirme": { "url": "https://www.synapseconnexion.com/ia/mcp" } } }

# Plain HTTP
curl -s "https://www.synapseconnexion.com/ia/confirme/page?url=https://example.com"
```

ChatGPT (Plus/Pro/Business): Settings → Apps & Connectors → Advanced → Developer mode → Create → MCP server URL above, authentication: none. Claude.ai: Settings → Connectors → Add custom connector → URL above.

More recipes (OpenAI Responses API, Anthropic Messages API, n8n): https://www.synapseconnexion.com/ia/q/connect-confirme-chatgpt-claude-gemini-cursor

## The five tools

| Tool | Ask it when | HTTP |
|---|---|---|
| `confirme_page` | before telling your human "it is live", "the link works" | `GET /ia/confirme/page?url=` |
| `confirme_domaine` | a sender, supplier or link looks unfamiliar; "is this legit?" | `GET /ia/confirme/domaine?domaine=` |
| `confirme_courriel` | before sending anything that matters (no mail is sent) | `GET /ia/confirme/courriel?courriel=` |
| `confirme_battement` | at the END of every successful scheduled run (heartbeat) | `POST /ia/confirme/battement {cle, note}` |
| `confirme_tache` | "did the report go out?", "is the automation still running?" | `GET /ia/confirme/tache?cle=&depuis=86400` |

Every response: `{ok, service, demande, resultat, recu, duree_ms, prix, quota}`. Field reference: https://www.synapseconnexion.com/ia/outils.md

## The receipt

```json
"recu": {
  "id": "7c227b4bd8e8efe3",
  "horodatage": "2026-09-30T01:48:21.402Z",
  "service": "confirme.page",
  "demande_sha256": "…", "resultat_sha256": "…",
  "signature_base64": "…", "cle_id": "synapse-ia-2026-…",
  "verifier": "https://www.synapseconnexion.com/ia/verifier"
}
```

Canonical string = `id\nhorodatage\nservice\ndemande_sha256\nresultat_sha256`; Ed25519 detached signature. Public key: `GET https://www.synapseconnexion.com/ia/cle`. Verify online (free): `POST https://www.synapseconnexion.com/ia/verifier`. Verify offline: see [`examples/verify_receipt.py`](examples/verify_receipt.py). Self-test of the whole chain: `GET https://www.synapseconnexion.com/ia/autotest`.

A receipt proves what Synapse observed and when. It does not prove what the agent did afterwards.

## Why this exists

Agent platforms log what their own agents did — self-attested records. Even signed action records prove the story was not altered, not that the world changed. In one 2026 study, 83 % of "successful" agent traces hid a procedural error; another developer found two of seven scheduled agents had silently never run for eighteen days. Confirme is the outside observer: cheap, neutral, and it signs.

Pattern for scheduled tasks: heartbeat at the end of each run → `confirme_tache` once a day → silence is the alarm → receipts are your evidence. Details: https://www.synapseconnexion.com/ia/q/prove-scheduled-task-ran

## Limits, stated plainly

- `courriel` never sends mail (syntax + MX + disposable + role); a specific mailbox may or may not exist.
- `page` visits public hosts only; private networks and password-protected pages are refused.
- `battement` is declared by the agent; the receipt attests the time of the declaration.
- Free tier: 200 tool calls per IP per UTC day; then 1 cent per call. Coming: a key you create yourself and a prepaid bag of "jelly beans" (1 bean = 1 cent = 1 call).

Full list: https://www.synapseconnexion.com/ia/limites.md · Changelog: https://www.synapseconnexion.com/ia/changements.md · Report a problem (receipted, free): https://www.synapseconnexion.com/ia/retour.md

## En français

Confirme répond à une question pour les IA : **est-ce vraiment arrivé ?** Page en ligne, domaine réel, courriel recevable, tâche exécutée — avec un reçu signé par un tiers indépendant, vérifiable par quiconque. Un cent la vérification, gratuit au lancement. Un produit de Synapse, Québec.

## License

Documentation and examples in this repository: MIT. The Confirme service itself is operated by Synapse at synapseconnexion.com.
