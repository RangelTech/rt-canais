# rt-canais

Gateway de canais **dos produtos** (Atende AI, Grupo AI), separado do LUAR. Mesmo código do gateway do `chatwoot-rt/bridge`
(`app/channels`), sem nada do Chatwoot, com Synapse e pontes mautrix próprios (stack `rt-canais` no vps_rt_infra).

- WhatsApp, Messenger e DMs do Instagram pelas pontes mautrix (Matrix); TikTok pelo worker ReLttk (um processo por conta).
- API em `/internal/channels` (token), webhook assinado (HMAC) para cada produto, appservice Matrix em `/_matrix/app/v1`.
- Contrato: igual ao `docs/canais/CONTRATO_GATEWAY.md` do chatwoot-rt.
- Testes: `DATABASE_URL=postgresql://... python -m pytest -q` (Postgres descartável).

Deploy: release neste repo; implantação só pelo `vps_rt_infra` (stack `rt-canais`). Todo tráfego das pontes sai pelo proxy SP.
