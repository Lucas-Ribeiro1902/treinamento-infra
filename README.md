# treinamento-infra
# Provisionamento de VM no Azure com Terraform

Este repositório contém um script Terraform para provisionar uma máquina virtual (VM) no Microsoft Azure. O script também inclui um arquivo `cloud-init` para configurar a VM durante sua criação.

## Pré-requisitos

Antes de começar, certifique-se de ter os seguintes pré-requisitos instalados:

1. **Conta no Azure**: Uma conta ativa no Azure. Se você ainda não tem uma, crie uma conta gratuita em [Azure](https://azure.microsoft.com/free/).
2. **Terraform**: Instale o Terraform. Você pode baixar a versão mais recente do Terraform em [terraform.io](https://www.terraform.io/downloads.html).
3. **Git**: Certifique-se de ter o Git instalado. Você pode baixar o Git em [git-scm.com](https://git-scm.com/).

## Configuração do Projeto

### 1. Clone o Repositório

Clone este repositório para sua máquina local:

```bash
git clone https://github.com/SEU_USUARIO/NOME_DO_REPOSITORIO.git
cd NOME_DO_REPOSITORIO

Certifique-se de estar autenticado no Azure CLI e configure as variáveis de ambiente necessárias:
az login
export ARM_CLIENT_ID="seu-client-id"
export ARM_CLIENT_SECRET="seu-client-secret"
export ARM_SUBSCRIPTION_ID="seu-subscription-id"
export ARM_TENANT_ID="seu-tenant-id"

Gere sua chave ssh
Como Gerar um Par de Chaves SSH
Para gerar um par de chaves SSH (chave pública e chave privada), você pode usar o comando ssh-keygen. Aqui está como fazer isso no terminal do seu sistema:
 -ssh-keygen -t rsa -b 2048 -f chave_ssh

No arquivo main.tf sustitua o nome do arquivo da chave ssh pulica pelo gerado pela sua maquina

Execute o comando terraform init para inicializar o diretório do Terraform e baixar os plugins necessários:
terraform init

Verifique o plano de execução do Terraform para garantir que as alterações são como esperado:
terraform plan

Provisione a VM no Azure aplicando o plano de execução:
terraform apply

Após a conclusão do comando terraform apply, acesse o Portal do Azure para verificar a VM provisionada.
