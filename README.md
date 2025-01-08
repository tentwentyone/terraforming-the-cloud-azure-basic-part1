# Terraforming the Cloud - Part 1

Temas abordados neste modulo:

* Os 4 principais comandos de terraform: `init`, `plan`, `apply` e `destroy`.
* Estrutura base de um projecto terraform: `main.tf`, `variables.tf`, `outputs.tf`
* Utilização de `variable`, `data`, `resource` e `output`.
* `terrafom.tfvars` é usado por defeito se tiver presente na mesma diretória.
* Gestão de alterações: **simples**, **disruptivas** e **dependentes**.
* Destruição seletiva de recursos.

## Início

Esta secção explica como preparar a Azure Cloud Shell para executarem os comandos.

💡 Ao fazerem copy-paste na `Azure Cloud Shell`, aconselhamos a que "colem" os conteúdos com `ctrl+shift+v`.

## Configurar a cloud shell

<details>

<summary>Clicar para expandir</summary>

Abrir o endereço com o botão direito do rato numa nova janela/tab (também podem ficar a premir o `ctrl` quando clicarem no link) : <a href="https://portal.azure.com" target="_blank">Open Azure Portal</a>

Autenticar na Azure Cloud:

![alt text](/images/sign_in.png)

Abrir a Cloud Shell:

![alt text](/images/cloud_shell.png)

Selecionar Bash:

![alt text](/images/bash_pshell.png)

Seleciona "Mount storage account" e a subscrição.

![alt text](/images/subscription.png)

Clica Apply depois das seleções.

![alt text](/images/subscription_apply.png)

Seleciona "Select existing storage account" e clica "Next"

![alt text](/images/mount_storage.png)

Seleciona a subscrição <>, o Resource Group "tf-azure-workshop-rg", a Storage account name "tfazureworkshopsatto" e o File share "fileshare" e clica "Select"

![alt text](/images/select_st_account.png)

Mudar para o editor após a conexão ser realizada:

![alt text](/images/choose_editor.png)

Confirmar a mudança:

![alt text](/images/classic_shell.png)

Clonar o projeto:

```bash
git clone https://github.com/tentwentyone/terraforming-the-cloud-azure-basic-part1.git
```

💡 Ao fazerem copy-paste na `Azure Cloud Shell`, aconselhamos a que "colem" os conteúdos com `ctrl+shift+v`.

Mudar de diretório.

```bash
cd terraforming-the-cloud-azure-basic-part1
```

💡 Ao fazerem copy-paste na `Azure Cloud Shell`, aconselhamos a que "colem" os conteúdos com `ctrl+shift+v`.

Abrir o editor:

![alt text](/images/open_editor.png)

⚠️ NOTA: o editor não atualiza automaticamente quaisquer mudanças, é preciso clicar no botão de refresh, localizado aqui.

![alt text](/images/refresh_vscode.png)

Setup está completo!

![alt text](/images/setup_complete.png)

</details>

## Configurar o vscodeserver
<!-- markdownlint-disable MD033 -->
<details>

<summary>Clicar para expandir</summary>
<!-- markdownlint-enable MD033 -->

Abre o terminal no vscode com o comando:

```bash
ctrl+ç
```

Faz git clone do repositório:

```bash
git clone https://github.com/tentwentyone/terraforming-the-cloud-azure-basic-part1.git
```

Abre a diretoria do projecto:

```bash
cd para o terraforming-the-cloud-azure-basic-part1
```

Abre a diretoria com o comando:

```bash
ctrl+k+ctrl+o
```

Seleciona o path para o codetour:

```bash
/home/coder/terraforming-the-cloud-azure-basic-part1
```

</details>

## Tutorial

🧭 [Clica aqui para começar!](tutorial.md)

### Comandos Úteis

```bash
# Obter a lista de machine-types
az vm list-sizes --location westeurope --output table

# Listar a lista de regioes disponiveis
az account list-locations --output table

# Listar as zonas disponiveis para uma dada regiao
az vm list-sizes --location westeurope --output table

# Listar VMs para uma dada subscription
az vm list --subscription <subscription-id> --output table

# Ligar à VM usando por ssh
az vm ssh --name <vm-name> --resource-group=$(terraform output -raw my_identifier)-rg --subscription <subscription-id>

# Obter o self-link de uma vpc a importar do lado de Azure
az vm list -g=$(terraform output -raw my_identifier)-rg

# Obter o self-link de uma subnet a importar do lado de Azure
az network vnet subnet list -g=$(terraform output -raw my_identifier)-rg --vnet-name=$(terraform output -raw my_identifier)-vnet
```
