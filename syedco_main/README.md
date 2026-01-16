# Syedco Main - Custom Workflow Configuration

Este diretório contém as configurações e workflows personalizados para o projeto Evolution API.

## Estrutura do Diretório

```
syedco_main/
├── config/          # Arquivos de configuração personalizados
├── workflows/       # Templates de workflows do GitHub Actions
├── scripts/         # Scripts auxiliares para automação
└── README.md        # Esta documentação
```

## Como Usar

### 1. Configuração Inicial

Os arquivos de configuração em `config/` contêm as definições personalizadas para seu ambiente:

- `workflow-config.json` - Configurações gerais do workflow
- `environment-config.json` - Variáveis de ambiente personalizadas

### 2. Workflows Disponíveis

Os templates de workflow em `workflows/` podem ser copiados para `.github/workflows/` e personalizados conforme necessário:

- `custom-deploy.yml` - Deploy personalizado
- `custom-test.yml` - Testes personalizados
- `custom-build.yml` - Build personalizado

### 3. Scripts Auxiliares

Os scripts em `scripts/` auxiliam na automação de tarefas:

- `setup.sh` - Script de configuração inicial
- `deploy.sh` - Script de deploy personalizado
- `test.sh` - Script de testes personalizados

## Personalização

Para personalizar os workflows para suas necessidades:

1. Edite os arquivos em `config/` com suas configurações
2. Copie os templates de `workflows/` para `.github/workflows/`
3. Ajuste os workflows conforme sua necessidade
4. Execute os scripts auxiliares quando necessário

## Integração com Evolution API

Este setup está configurado para trabalhar com:
- Node.js 20.x
- TypeScript
- Prisma (PostgreSQL/MySQL)
- Docker
- ESLint/Prettier

## Variáveis de Ambiente Necessárias

Configure as seguintes variáveis no GitHub Secrets:

- `DATABASE_PROVIDER` - postgresql ou mysql
- `DATABASE_URL` - URL de conexão do banco de dados
- `DOCKER_USERNAME` - Usuário do Docker Hub (para deploy)
- `DOCKER_PASSWORD` - Senha do Docker Hub (para deploy)

## Suporte

Para mais informações sobre o Evolution API, consulte:
- [Documentação Oficial](https://doc.evolution-api.com)
- [GitHub Repository](https://github.com/EvolutionAPI/evolution-api)
