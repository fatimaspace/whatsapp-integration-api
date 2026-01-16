# Guia de Uso - Syedco Custom Workflow

## Visão Geral

Este guia fornece instruções detalhadas sobre como usar o sistema de workflow personalizado do Syedco para o Evolution API.

## Índice

1. [Instalação Inicial](#instalação-inicial)
2. [Configuração](#configuração)
3. [Workflows Disponíveis](#workflows-disponíveis)
4. [Scripts Auxiliares](#scripts-auxiliares)
5. [Personalização](#personalização)
6. [Exemplos de Uso](#exemplos-de-uso)
7. [Solução de Problemas](#solução-de-problemas)

## Instalação Inicial

### Passo 1: Configuração Básica

Execute o script de setup para configurar o ambiente:

```bash
cd /caminho/para/whatsapp-integration-api
./syedco_main/scripts/setup.sh
```

Este script irá:
- ✅ Verificar a estrutura do projeto
- ✅ Instalar dependências
- ✅ Gerar o cliente Prisma
- ✅ Criar arquivo .env (se não existir)
- ✅ Copiar workflows para .github/workflows/ (opcional)
- ✅ Executar verificações de qualidade
- ✅ Fazer build do projeto

### Passo 2: Configurar Variáveis de Ambiente

Edite o arquivo `.env` com suas configurações:

```bash
# Banco de Dados
DATABASE_PROVIDER=postgresql
DATABASE_URL=postgresql://usuario:senha@localhost:5432/evolution

# API
AUTHENTICATION_API_KEY=sua-chave-secreta

# Redis (opcional)
CACHE_REDIS_ENABLED=true
REDIS_URI=redis://localhost:6379

# Outros...
```

## Configuração

### Configurações do Workflow

Edite `syedco_main/config/workflow-config.json` para personalizar:

```json
{
  "workflow": {
    "name": "Meu Workflow Personalizado",
    "version": "1.0.0"
  },
  "build": {
    "nodeVersion": "20.x",
    "buildCommand": "npm run build"
  },
  "deployment": {
    "enabled": true,
    "target": "production"
  }
}
```

### Configurações de Ambiente

Edite `syedco_main/config/environment-config.json` para cada ambiente:

```json
{
  "production": {
    "DATABASE_PROVIDER": "postgresql",
    "LOG_LEVEL": "error",
    "NODE_ENV": "production"
  }
}
```

## Workflows Disponíveis

### 1. Custom Build Workflow

**Arquivo:** `syedco_main/workflows/custom-build.yml`

**Quando é executado:**
- Push para branches main, develop, staging
- Pull requests para essas branches
- Manualmente via workflow_dispatch

**O que faz:**
1. Instala dependências
2. Executa linting
3. Gera cliente Prisma
4. Faz build da aplicação
5. Executa testes (se disponíveis)
6. Gera artefatos de build

**Como usar:**
```bash
# Copiar para .github/workflows/
cp syedco_main/workflows/custom-build.yml .github/workflows/

# Commit e push
git add .github/workflows/custom-build.yml
git commit -m "chore: add custom build workflow"
git push
```

### 2. Custom Deploy Workflow

**Arquivo:** `syedco_main/workflows/custom-deploy.yml`

**Quando é executado:**
- Push para branch main
- Push de tags (v*.*.*)
- Manualmente via workflow_dispatch

**O que faz:**
1. Faz build da imagem Docker
2. Publica no Docker Hub
3. Cria tags apropriadas
4. Gera relatório de deploy

**Configuração necessária no GitHub:**
- `DOCKER_USERNAME` - Seu usuário do Docker Hub
- `DOCKER_PASSWORD` - Sua senha/token do Docker Hub

**Como usar:**
```bash
# Copiar para .github/workflows/
cp syedco_main/workflows/custom-deploy.yml .github/workflows/

# Configurar secrets no GitHub
# Settings -> Secrets and variables -> Actions -> New repository secret

# Deploy via tag
git tag v1.0.0
git push origin v1.0.0

# Ou deploy manual no GitHub Actions UI
```

### 3. Custom Test Workflow

**Arquivo:** `syedco_main/workflows/custom-test.yml`

**Quando é executado:**
- Push para branches main, develop, staging
- Pull requests para essas branches
- Agendado diariamente às 2 AM UTC
- Manualmente via workflow_dispatch

**O que faz:**
1. Inicia serviços de teste (PostgreSQL, Redis)
2. Executa migrações de banco
3. Roda testes unitários
4. Roda testes de integração
5. Gera relatório de cobertura
6. Executa verificações de qualidade

**Como usar:**
```bash
# Copiar para .github/workflows/
cp syedco_main/workflows/custom-test.yml .github/workflows/

# Os testes rodarão automaticamente
git add .github/workflows/custom-test.yml
git commit -m "chore: add custom test workflow"
git push
```

## Scripts Auxiliares

### Setup Script

**Uso:**
```bash
./syedco_main/scripts/setup.sh
```

Configura todo o ambiente de desenvolvimento.

### Deploy Script

**Uso:**
```bash
# Deploy padrão (production, latest)
./syedco_main/scripts/deploy.sh

# Deploy com ambiente e versão específicos
./syedco_main/scripts/deploy.sh staging v1.2.3

# Deploy local com docker-compose
./syedco_main/scripts/deploy.sh production latest
# Responda 'y' quando perguntado sobre docker-compose
```

**Opções:**
- `$1` - Ambiente (production, staging, development)
- `$2` - Versão (latest, v1.0.0, etc.)

### Test Script

**Uso:**
```bash
# Executar todos os testes
./syedco_main/scripts/test.sh

# Executar testes específicos
./syedco_main/scripts/test.sh unit
./syedco_main/scripts/test.sh integration
./syedco_main/scripts/test.sh e2e
./syedco_main/scripts/test.sh coverage
```

**Tipos de teste:**
- `unit` - Testes unitários
- `integration` - Testes de integração
- `e2e` - Testes end-to-end
- `coverage` - Testes com cobertura
- `all` - Todos os testes (padrão)

## Personalização

### Adicionar Novos Workflows

1. Crie um novo arquivo em `syedco_main/workflows/`:

```yaml
name: Meu Workflow Customizado

on:
  push:
    branches: [ main ]

jobs:
  meu-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - name: Meu passo
        run: echo "Olá, mundo!"
```

2. Copie para `.github/workflows/`:

```bash
cp syedco_main/workflows/meu-workflow.yml .github/workflows/
```

### Adicionar Novos Scripts

1. Crie um novo script em `syedco_main/scripts/`:

```bash
#!/bin/bash
echo "Meu script customizado"
# Seu código aqui
```

2. Torne executável:

```bash
chmod +x syedco_main/scripts/meu-script.sh
```

### Modificar Configurações

Edite os arquivos JSON em `syedco_main/config/` conforme necessário.

## Exemplos de Uso

### Exemplo 1: CI/CD Completo

```bash
# 1. Setup inicial
./syedco_main/scripts/setup.sh

# 2. Copiar todos os workflows
cp syedco_main/workflows/*.yml .github/workflows/

# 3. Configurar secrets no GitHub
# - DATABASE_URL
# - DOCKER_USERNAME
# - DOCKER_PASSWORD

# 4. Fazer desenvolvimento
git checkout -b feature/minha-feature
# ... fazer mudanças ...
git commit -am "feat: minha nova feature"
git push origin feature/minha-feature

# 5. Criar PR - workflows de build e test rodam automaticamente

# 6. Merge para main - workflow de deploy roda automaticamente
```

### Exemplo 2: Desenvolvimento Local

```bash
# 1. Setup
./syedco_main/scripts/setup.sh

# 2. Rodar testes
./syedco_main/scripts/test.sh

# 3. Desenvolvimento
npm run dev:server

# 4. Build local
npm run build

# 5. Deploy local
./syedco_main/scripts/deploy.sh development latest
```

### Exemplo 3: Deploy Manual

```bash
# 1. Build e testes
npm run build
npm test

# 2. Deploy usando script
./syedco_main/scripts/deploy.sh production v2.0.0

# 3. Ou deploy via workflow manual no GitHub
# Vá para Actions -> Custom Deploy -> Run workflow
# Selecione environment: production
```

## Solução de Problemas

### Problema: Prisma client não gerado

**Solução:**
```bash
export DATABASE_PROVIDER=postgresql
npm run db:generate
```

### Problema: Testes falhando

**Solução:**
```bash
# Verificar se serviços estão rodando
docker-compose up -d postgres redis

# Executar migrações
npm run db:migrate:dev

# Rodar testes novamente
./syedco_main/scripts/test.sh
```

### Problema: Build Docker falha

**Solução:**
```bash
# Verificar Dockerfile
cat Dockerfile

# Build manual para ver erros
docker build -t test .

# Verificar logs
docker logs <container-id>
```

### Problema: Workflow não executa

**Solução:**
1. Verificar se o arquivo está em `.github/workflows/`
2. Verificar sintaxe YAML
3. Verificar permissões no GitHub (Settings -> Actions)
4. Ver logs no GitHub Actions

### Problema: Secrets não configurados

**Solução:**
```bash
# No GitHub:
# Settings -> Secrets and variables -> Actions
# New repository secret

# Adicionar:
# - DATABASE_URL
# - DOCKER_USERNAME
# - DOCKER_PASSWORD
```

## Recursos Adicionais

- [Documentação Evolution API](https://doc.evolution-api.com)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Documentation](https://docs.docker.com)
- [Prisma Documentation](https://www.prisma.io/docs)

## Suporte

Para problemas ou dúvidas:
1. Verifique a [documentação do Evolution API](https://doc.evolution-api.com)
2. Abra uma issue no [GitHub](https://github.com/EvolutionAPI/evolution-api/issues)
3. Entre no [Discord](https://evolution-api.com/discord)
4. Participe do [grupo WhatsApp](https://evolution-api.com/whatsapp)

---

**Nota:** Este sistema de workflow foi criado especificamente para o contexto do syedco_main e pode ser personalizado conforme suas necessidades.
