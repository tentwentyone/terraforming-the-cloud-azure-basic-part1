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

### Configurar a cloud shell

Abrir o endereço: <https://portal.azure.com>

Autenticar na Azure Cloud:

![alt text](/images/sign_in.png)

Abrir a Cloud Shell:

![alt text](/images/cloud_shell.png)

Selecionar Bash:

![alt text](/images/bash_pshell.png)

Seleciona a subscrição <>

![alt text](/images/subscription.png)

Mudar para o editor:

![alt text](/images/choose_editor.png)

Confirmar a mudança:

![alt text](/images/classic_shell.png)

Clonar o projeto:

```bash
git clone https://github.com/tentwentyone/terraforming-the-cloud-azure-basic-part1.git
```

Mudar de diretório.

```bash
cd terraforming-the-cloud--azure-basic-part1
```

Abrir o editor:

![alt text](/images/open_editor.png)

Setup está completo!

![alt text](/images/setup_complete.png)

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
az vm ssh --name <vm-name> --resource-group <resource-group> --subscription <subscription-id>

# Obter o self-link de uma vpc a importar do lado do GCP
az network vnet list -g <my_resource_group> | grep "$(terraform output -raw my_generic_identifier)"

# Obter o self-link de uma subnet a importar do lado do GCP
az network vnet list -g <my_resource_group> | grep "$(terraform output -raw my_generic_identifier)"
```
