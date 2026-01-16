# 🚀 Quick Start - Syedco Custom Workflow

## Início Rápido em 5 Minutos

### Passo 1: Execute o Setup (1 min)

```bash
cd /caminho/para/whatsapp-integration-api
./syedco_main/scripts/setup.sh
```

Responda as perguntas e aguarde a conclusão.

### Passo 2: Configure o Ambiente (1 min)

Edite o arquivo `.env` que foi criado:

```bash
nano .env
```

Ou copie as configurações básicas:

```bash
DATABASE_PROVIDER=postgresql
DATABASE_URL=postgresql://evolution:evolution@localhost:5432/evolution
AUTHENTICATION_API_KEY=change-me-to-a-secure-key
```

### Passo 3: Ative os Workflows (1 min)

Copie os workflows para a pasta do GitHub:

```bash
cp syedco_main/workflows/*.yml .github/workflows/
git add .github/workflows/
git commit -m "chore: add syedco custom workflows"
git push
```

### Passo 4: Configure GitHub Secrets (1 min)

No GitHub, vá para:
**Settings → Secrets and variables → Actions → New repository secret**

Adicione:
- `DATABASE_PROVIDER` = `postgresql`
- `DATABASE_URL` = sua URL do banco
- `DOCKER_USERNAME` = seu usuário Docker (para deploy)
- `DOCKER_PASSWORD` = seu token Docker (para deploy)

### Passo 5: Teste! (1 min)

```bash
# Testar localmente
./syedco_main/scripts/test.sh

# Ou fazer um push para testar no GitHub
git push
```

Pronto! 🎉

---

## Comandos Úteis

```bash
# Setup completo
./syedco_main/scripts/setup.sh

# Rodar testes
./syedco_main/scripts/test.sh

# Deploy local
./syedco_main/scripts/deploy.sh development latest

# Build
npm run build

# Desenvolvimento
npm run dev:server

# Lint
npm run lint:check
```

---

## Workflows Disponíveis

✅ **Custom Build** - Build e testes automáticos  
✅ **Custom Deploy** - Deploy automático com Docker  
✅ **Custom Test** - Testes completos com cobertura  

---

## Próximos Passos

1. 📖 Leia o [GUIDE.md](./GUIDE.md) completo
2. ⚙️ Personalize [config/workflow-config.json](./config/workflow-config.json)
3. 🔧 Ajuste os workflows conforme sua necessidade
4. 🚀 Faça seu primeiro deploy!

---

## Estrutura Criada

```
syedco_main/
├── README.md                      # Documentação principal
├── GUIDE.md                       # Guia detalhado
├── QUICKSTART.md                  # Este arquivo
├── config/
│   ├── workflow-config.json       # Configurações do workflow
│   └── environment-config.json    # Configurações de ambiente
├── workflows/
│   ├── custom-build.yml           # Workflow de build
│   ├── custom-deploy.yml          # Workflow de deploy
│   └── custom-test.yml            # Workflow de testes
└── scripts/
    ├── setup.sh                   # Script de setup
    ├── deploy.sh                  # Script de deploy
    └── test.sh                    # Script de testes
```

---

## Precisa de Ajuda?

- 📖 [GUIDE.md](./GUIDE.md) - Guia completo
- 📖 [README.md](./README.md) - Visão geral
- 🌐 [Evolution API Docs](https://doc.evolution-api.com)
- 💬 [Discord](https://evolution-api.com/discord)
- 💬 [WhatsApp](https://evolution-api.com/whatsapp)

---

**Desenvolvido para o contexto syedco_main do Evolution API** 🚀
