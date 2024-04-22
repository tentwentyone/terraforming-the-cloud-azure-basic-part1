# Terraforming the Cloud - Part 1

![alt text](/images/terraform_part_1.png)

## Index

- [0. Pré Requisitos](#0-pré-requisitos)
- [1. O primeiro contacto](#1-o-primeiro-contacto)
- [2. Lidar com as alterações](#2-lidar-com-as-alterações)
  - [2.1 Introduzindo alterações não-disruptivas](#21-introduzindo-alterações-não-disruptivas)
  - [2.2 Introduzindo alterações disruptivas](#22-introduzindo-alterações-disruptivas)
  - [2.3 Introduzindo alterações dependentes](#23-introduzindo-alterações-dependentes)
- [3. Terraform Import](#3-terraform-import--move)
  - [3.1 Criar um recurso (`azurerm_virtual_network`) usando os comandos azure](#31-criar-um-recurso-azurerm_virtual_network-usando-os-comandos-azure)
  - [3.2 Importar recursos existentes](#32-importar-recursos-existentes)
  - [3.3 Move](#33-move)
- [4. Exercício](#4-exercício)
  - [Ajudas😵](#ajudas)
- [5. Wrap up & Destroy](#5-wrap-up--destroy)

### Temas abordados neste modulo

- Estrutura base de um projecto terraform: `main.tf`, `variables.tf`, `outputs.tf`
- Utilização de `variable`, `data`, `resource` e `output`.
- `terrafom.tfvars` é usado por defeito se tiver presente na mesma diretória.
- Os 4 principais comandos de terraform: `init`, `plan`, `apply` e `destroy`.
- Gestão de alterações: **simples**, **disruptivas** e **dependentes**.
- Importação de recursos existentes.
- Exercicio final.

**Tempo estimado**: Cerca de 2 horas

## 0. Pré requisitos

Antes de começares, é necessário verificares algumas coisas.

<details>
  <summary>Clica para veres os pré requisitos</summary>

Certifica-te que tens a `azure-cloud-shell` devidamente configurada, correndo o comando:

```bash
source ./scripts/get-azure-credentials.sh
```

Deve dar os valores do `AZURE_SUBSCRIPTION_ID` e `AZURE_TENANT_ID`.

</details>

---

## 1. O primeiro contacto

> **Nesta secção iremos executar os 4 principais comandos de terraform: `init`, `plan`, `apply` e `destroy`.**

<details><summary>Clica para veres o exercício 1</summary>

### Comando `init`

> *[from docs:](https://www.terraform.io/docs/cli/commands/init.html) The `terraform init` command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.*

```bash
terraform init
```

### Comando `plan`

> *[from docs:](https://www.terraform.io/docs/cli/commands/plan.html) The `terraform plan` command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure. By default, when Terraform creates a plan it:*
>
> - *Reading the current state of any already-existing remote objects to make sure that the Terraform state is up-to-date.*
> - *Comparing the current configuration to the prior state and noting any differences.*
> - *Proposing a set of change actions that should, if applied, make the remote objects match the configuration.*

```bash
terraform plan
```

Devem ter um resultado semelhante a isto:

```bash
Terraform will perform the following actions:

  # azurerm_resource_group.default will be created
  + resource "azurerm_resource_group" "default" {
      + id       = (known after apply)
      + location = "westeurope"
      + name     = (known after apply)
    }

  # azurerm_subnet.default will be created
  + resource "azurerm_subnet" "default" {
      + address_prefixes                               = [
          + "10.0.1.0/24",
        ]
      + default_outbound_access_enabled                = true
      + enforce_private_link_endpoint_network_policies = (known after apply)
      + enforce_private_link_service_network_policies  = (known after apply)
      + id                                             = (known after apply)
      + name                                           = (known after apply)
      + private_endpoint_network_policies              = (known after apply)
      + private_endpoint_network_policies_enabled      = (known after apply)
      + private_link_service_network_policies_enabled  = (known after apply)
      + resource_group_name                            = (known after apply)
      + virtual_network_name                           = (known after apply)
    }

  # azurerm_virtual_network.default will be created
  + resource "azurerm_virtual_network" "default" {
      + address_space       = [
          + "10.0.0.0/16",
        ]
      + dns_servers         = (known after apply)
      + guid                = (known after apply)
      + id                  = (known after apply)
      + location            = "westeurope"
      + name                = (known after apply)
      + resource_group_name = (known after apply)
      + subnet              = (known after apply)
    }

  # random_pet.this will be created
  + resource "random_pet" "this" {
      + id        = (known after apply)
      + length    = 2
      + prefix    = "az"
      + separator = "-"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + my_identifier     = (known after apply)
  + region            = "westeurope"
  + subnet_name       = (known after apply)
  + subscription_name = "IFT Terraform training"

```

### Comando `apply`

> *[from docs:](https://www.terraform.io/docs/cli/commands/apply.html) The `terraform apply` command executes the actions proposed in a Terraform plan.*

```bash
terraform apply
```

- Não te esqueças de escrever `yes` para confirmar o apply.

- ⏳ Tempo do apply - 1 min.

Após o apply repara nos seguintes **outputs**

```bash
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

my_identifier     = "az-tender-prawn" (nome gerado aleatóriamente)
region            = "westeurope"
subnet_name       = "az-tender-prawn-subnet" (nome gerado aleatóriamente)
subscription_name = "IFT Terraform training"

```

Esta informação diz respeito aos recursos que criaste!

Para verificares que os recursos remotos foram criados utiliza os seguintes comandos:

```bash
az group show --name=$(terraform output -raw my_identifier)-rg --output table
```

Para verificar todos os resource groups:

```bash
az group list --output table
```

### Comando `destroy`

> *[from docs:](https://www.terraform.io/docs/cli/commands/destroy.html) The `terraform destroy` command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.*
>
> *While you will typically not want to destroy long-lived objects in a production environment, Terraform is sometimes used to manage ephemeral infrastructure for development purposes, in which case you can use `terraform destroy` to conveniently clean up all of those temporary objects once you are finished with your work.*

```bash
terraform destroy
```

- Não te esqueças de escrever `yes` para confirmar o destroy.

Para verificares que os recursos remotos foram destruídos:

```bash
az group show --name=$(terraform output -raw my_identifier)-rg
```

Deverá apresentar um erro a dizer `No outputs found` porque estes foram destruídos.

</details>

---

## 2. Lidar com as alterações

> **Nesta secção iremos demonstrar a utilização de terraform perante vários tipos de alterações.**

<details><summary>Clica para veres o exercício 2</summary>

### Criar uma Máquina Virtual

- Abrir o ficheiro `main.tf`
- Descomentar o bloco referente ao `exercicio 2.` - seleciona o bloco referente ao exercício 2 e de seguida `ctrl+k+u` ou se estiveres num mac `cmd+k+u`.
- Não te esqueças de salvar o ficheiro depois de fazeres alterações! `ctrl+s` ou se estiveres num mac `cmd+s`.

Executar o `plan`:

```bash
terraform plan
```

<details><summary>Resultado</summary>


```bash
Terraform will perform the following actions:

  # azurerm_linux_virtual_machine.default will be created
  + resource "azurerm_linux_virtual_machine" "default" {
      + admin_password                                         = (sensitive value)
      + admin_username                                         = "adminuser"
      + allow_extension_operations                             = true
      + bypass_platform_safety_checks_on_user_schedule_enabled = false
      + computer_name                                          = (known after apply)
      + disable_password_authentication                        = false
      + disk_controller_type                                   = (known after apply)
      + extensions_time_budget                                 = "PT1H30M"
      + id                                                     = (known after apply)
      + location                                               = "westeurope"
      + max_bid_price                                          = -1
      + name                                                   = (known after apply)
      + network_interface_ids                                  = (known after apply)
      + patch_assessment_mode                                  = "ImageDefault"
      + patch_mode                                             = "ImageDefault"
      + platform_fault_domain                                  = -1
      + priority                                               = "Regular"
      + private_ip_address                                     = (known after apply)
      + private_ip_addresses                                   = (known after apply)
      + provision_vm_agent                                     = true
      + public_ip_address                                      = (known after apply)
      + public_ip_addresses                                    = (known after apply)
      + resource_group_name                                    = (known after apply)
      + size                                                   = "Standard_B1ls"
      + virtual_machine_id                                     = (known after apply)
      + vm_agent_platform_updates_enabled                      = false

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "UbuntuServer"
          + publisher = "Canonical"
          + sku       = "16.04-LTS"
          + version   = "latest"
        }
    }

  # azurerm_network_interface.default will be created
  + resource "azurerm_network_interface" "default" {
      + accelerated_networking_enabled = (known after apply)
      + applied_dns_servers            = (known after apply)
      + dns_servers                    = (known after apply)
      + enable_accelerated_networking  = (known after apply)
      + enable_ip_forwarding           = (known after apply)
      + id                             = (known after apply)
      + internal_dns_name_label        = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = (known after apply)
      + location                       = "westeurope"
      + mac_address                    = (known after apply)
      + name                           = (known after apply)
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = (known after apply)
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_resource_group.default will be created
  + resource "azurerm_resource_group" "default" {
      + id       = (known after apply)
      + location = "westeurope"
      + name     = (known after apply)
    }

  # azurerm_subnet.default will be created
  + resource "azurerm_subnet" "default" {
      + address_prefixes                               = [
          + "10.0.1.0/24",
        ]
      + default_outbound_access_enabled                = true
      + enforce_private_link_endpoint_network_policies = (known after apply)
      + enforce_private_link_service_network_policies  = (known after apply)
      + id                                             = (known after apply)
      + name                                           = (known after apply)
      + private_endpoint_network_policies              = (known after apply)
      + private_endpoint_network_policies_enabled      = (known after apply)
      + private_link_service_network_policies_enabled  = (known after apply)
      + resource_group_name                            = (known after apply)
      + virtual_network_name                           = (known after apply)
    }

  # azurerm_virtual_network.default will be created
  + resource "azurerm_virtual_network" "default" {
      + address_space       = [
          + "10.0.0.0/16",
        ]
      + dns_servers         = (known after apply)
      + guid                = (known after apply)
      + id                  = (known after apply)
      + location            = "westeurope"
      + name                = (known after apply)
      + resource_group_name = (known after apply)
      + subnet              = (known after apply)
    }

  # random_pet.this will be created
  + resource "random_pet" "this" {
      + id        = (known after apply)
      + length    = 2
      + prefix    = "az"
      + separator = "-"
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + my_identifier          = (known after apply)
  + network_interface_name = (known after apply)
  + region                 = "westeurope"
  + subnet_name            = (known after apply)
  + subscription_name      = "IFT Terraform training"
  + virtual_machine_name   = (known after apply)
```

</details>

⚠️ Repara que os recursos criados no `exercício 1` vão ser recriados. Isto acontece porque apesar de terem sido destruídos na atividade anterior continuam declarados no código.

Executar o `apply`:

```bash
terraform apply
```

- Não te esqueças de escrever `yes` para confirmar o apply.
- ⌛Tempo do apply 2:00 min.

Após o apply iremos ter os seguintes **outputs**

```bash
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

my_identifier = "az-supreme-basilisk" (nome gerado aleatóriamente)
network_interface_name = "az-supreme-basilisk-ni" (nome gerado aleatóriamente)
region = "westeurope"
subnet_name = "az-supreme-basilisk-subnet" (nome gerado aleatóriamente)
subscription_name = "IFT Terraform training"
virtual_machine_name = "az-supreme-basilisk-vm" (nome gerado aleatóriamente)
```

Verifica que a virtual machine foi criada!

```hcl
az vm show -g=$(terraform output -raw my_identifier)-rg -n=$(terraform output -raw my_identifier)-vm -d --output table
```

Para verificar todas as virtual machines existentes:

```bash
az vm list --output table
```

</details>

### 2.1 Introduzindo alterações não-disruptivas

> **As alterações não disruptivas são pequenas alterações que possibilitam a re-configuração do recurso sem que este tenha que ser recriado, não afetando as suas dependências**

<details><summary>Clica para veres o exercício 2.1</summary>

- Edita o ficheiro `main.tf`, localizar o recurso `azurerm_virtual_machine.default` e descomenta (seleciona o conteúdo e prime `ctrl+k+u` para remover os `#`) o campo `tags`.

- Guarda as tuas alterações! `ctrl+s` ou se estiveres num mac `cmd+s`.
- ⌛Tempo do apply 30 segundos.

Executar o `plan`.

```bash
terraform plan
```

Este deverá apresentar algo semelhante a:

```bash
Terraform will perform the following actions:

  # azurerm_linux_virtual_machine.default will be updated in-place
  ~ resource "azurerm_linux_virtual_machine" "default" {
      (...)
      ~ tags                                                   = {
          + "environment" = "staging"
        }
    }

Plan: 0 to add, 1 to change, 0 to destroy.

```

Executar o `apply`:

```bash
terraform apply
```

- ⌛Tempo do apply 30 sec.

</details>

---

### 2.2 Introduzindo alterações disruptivas

> **As alterações disruptivas são provocadas por alterações de propriedades que provocam a recriação do recurso e consequentes dependencias**

<details><summary>Clica para veres o exercício 2.2</summary>

- No ficheiro `main.tf`, localizar o recurso `azurerm_virtual_machine.default` e alterar o campo `name` para o seguinte: `"${random_pet.this.id}-vm-new"`

```bash
"${random_pet.this.id}-vm-new"
```

- Guarda as tuas alterações! `ctrl+s` ou se estiveres num mac `cmd+s`.
- Executar `terraform plan` e verificar que o Terraform irá efectuar um `replacement` - é uma alteração disruptiva.

Executar o `plan`:

```bash
terraform plan
```

O resultado deverá querer fazer um `must be replaced` por causa da mudança do nome.

```bash
Terraform will perform the following actions:

  # azurerm_linux_virtual_machine.default must be replaced
-/+ resource "azurerm_linux_virtual_machine" "default" {
      (...)
      ~ name                                                   = "az-supreme-basilisk-vm" -> "az-supreme-basilisk-vm-new" # forces replacement
      (...)
    }

Plan: 1 to add, 0 to change, 1 to destroy.

Changes to Outputs:
  ~ virtual_machine_name   = "az-supreme-basilisk-vm" -> "az-supreme-basilisk-vm-new"
```

Executar o `apply`:

```bash
terraform apply
```

- ⌛Tempo do apply 2 min.


Verifica que a nova virtual machine foi criada!

```hcl
az vm show -g=$(terraform output -raw my_identifier)-rg -n=$(terraform output -raw my_identifier)-vm-new -d --output table
```

Para verificar todas as virtual machines existentes:

```bash
az vm list --output table
```

</details>

---

### 2.3 Introduzindo alterações dependentes

> **As alterações também podem ser derivadas de dependências, e quando isso acontece, todo o grafo de dependendencias é afetado.**

<details><summary>Clica para veres o exercício 2.3</summary>

- Editar o ficheiro `terraform.tfvars` e alterar o valor da variavel `prefix` de `az` para `new`
- Guarda as tuas alterações! `ctrl+s` ou se estiveres num mac `cmd+s`.

Executar o `plan` e verificar todo o grafo de dependencias é afetado:

```bash
terraform plan
```

Executar o `apply`:

```bash
terraform apply
```

- ⌛Tempo do apply 4:00 min.

*Notem que apenas alterámos uma mera variável...*

>**NOTA: NÃO DESTRUIR OS RECURSOS pois vamos usa-los no próximo passo**

</details>

---

## 3. Terraform Import & Move

> **Disponível a partir do terraform `v1.5`. Toda a documentação deste capítulo está descrita [aqui](https://developer.hashicorp.com/terraform/tutorials/state/state-import).**

<details><summary>Clica para veres o exercício 3</summary>

> *[from docs:](https://developer.hashicorp.com/terraform/tutorials/state/state-import)Terraform supports bringing your existing infrastructure under its management. By importing resources into Terraform, you can consistently manage your infrastructure using a common workflow.*
>
> *This is a great way to slowly transition infrastructure to Terraform, or to be able to be confident that you can use Terraform in the future if it potentially doesn't support every feature you need today.*

Assegurar que não existem alterações pendentes:

```bash
terraform plan
```

Se o plan apresentar mudanças, façam o apply com o comando:

```bash
terraform apply
```

</details>

---

### 3.1 Criar um recurso (`azurerm_virtual_network`) usando os comandos azure

> **Nesta parte vamos criar recursos recorrendo a uma ferramenta externa ao terraform por forma a criar um use-case de recursos que existem fora do `state` do terraform.**

<details><summary>Clica para veres o exercício 3.1</summary>

O objetivo é simular recursos que já existiam para que os possamos *terraformar*.

Criar uma **Virtual Network**:

```bash
az network vnet create --name=$(terraform output -raw my_identifier)-import-vnet --subscription="$(terraform output -raw subscription_name)" --resource-group=$(terraform output -raw my_identifier)-rg
```

- ⌛Tempo para a criação do recurso 30 segundos.

Para verificar se a virtual network foi criada:

```bash
az network vnet show --name=$(terraform output -raw my_identifier)-import-vnet --subscription="$(terraform output -raw subscription_name)" --resource-group=$(terraform output -raw my_identifier)-rg --output table
```

Para verificar todas as virtual machines existentes:

```bash
az network vnet list --output table
```

</details>

---

### 3.2 Importar recursos existentes

> **Nesta parte vamos criar o bloco de `import` para fazer a importação do recurso criado anteriormente.**

<details><summary>Clica para veres o exercício 3.2</summary>

> O processo de importação de recursos consiste em duas partes:

- Obtenção da informação do recurso na cloud.
- Criação de um bloco `import` que irá indicar ao terraform que o recurso já existe e que o mesmo deve ser gerido pelo terraform.

O primeiro passo da importação de recursos é [declarar a importação dos mesmos](https://developer.hashicorp.com/terraform/tutorials/state/state-import).

Para isto, [temos que definir o bloco `import`](https://developer.hashicorp.com/terraform/tutorials/state/state-import#define-import-block), que necessita de dois argumentos:

- `id`: o id do recurso a importar do lado de Azure
- `to`: o identificador terraform do recurso a importar

Exemplo de um bloco `import`:

```hcl
 import {
   id = "/subscriptions/$(terraform output -raw subscription_id)/resourceGroups/${azurerm_resource_group.default.name}/providers/Microsoft.Network/virtualNetworks/${random_pet.this.id}-import-vnet"
   to = azurerm_virtual_network.my_imported_vnet
 }
```

- Para o exercicio que segue, vamos ao ficheiro `import-exercise.tf` descomentar (seleciona o conteúdo e prime `ctrl+k+u` para remover os `#`) o conteúdo.

- Não te esqueças de gravar as tuas alterações com `ctrl+s` ou se estiveres num mac `cmd+s`.

- O que estamos a fazer é a definir um bloco de `import` em que especificamos o recurso a importar e o seu destino.

- Temos no entanto de definir o destino do mesmo para que possamos alojar o recurso e passar a geri-lo por terraform, é essa a razão pela qual definimos um bloco de `resource` no `import-exercise.tf`.

---

Executar o `plan`:

```bash
terraform plan
```

Agora no resultado, iremos ter `to import` no plan:

```bash

Terraform will perform the following actions:

  # azurerm_virtual_network.my_imported_vnet will be imported
    resource "azurerm_virtual_network" "my_imported_vnet" {
    (...)
    }

Plan: 1 to import, 0 to add, 0 to change, 0 to destroy.

```

Executar o `apply`:

```bash
terraform apply
```

- ⌛Tempo do apply - 10 segundos.

Executar o `plan`:

```bash
terraform plan
```

Se o terraform indicar que não tem alterações à infraestrutura, confirma-se que os recursos foram importados com sucesso.

</details>

---

### 3.3 Move

> **O [move](https://developer.hashicorp.com/terraform/cli/state/move) é usado em casos onde é importante preservar o objeto existente na infraestrutura, reorganizando a nossa configuração de Terraform, renomeando recursos, entre outros casos mais complexos como movendo recursos entre módulos.**

<details><summary>Clica para veres o exercício 3.3</summary>

Vamos agora supôr que queremos mudar o nome dum recurso em terraform. Se formos mudar o nome do recurso, o terraform irá considerar que estamos a destruir o recurso anterior e a querer criar um novo com as mesmas especificações.

Para evitar esse comportamento, uma vez que não queremos destruir o recurso, vamos usar o `move`.

Vai ao ficheiro `move-exercise.tf` e descomenta (seleciona o conteúdo e prime `ctrl+k+u` para remover os `#`) o `resource` do `random.pet`

```bash
resource "random_pet" "new_id" {
  length    = 2
  separator = "-"
  prefix    = var.prefix
}
```

Executar o `plan`:

```bash
terraform plan
```

Executar o `apply`:

```bash
terraform apply
```

- ⌛Tempo do apply - 20 segundos.

Agora, vamos mudar o nome do recurso para que o `resource "random_pet" "new_id"` seja `resource "random_pet" "moved"`.

Se agora, fizermos um `terraform plan` o resultado será algo semelhante a isto:

```bash
  # random_pet.moved will be created
  + resource "random_pet" "moved" {
      + id        = (known after apply)
      + length    = 2
      + prefix    = ""
      + separator = "-"
    }

  # random_pet.new_id will be destroyed
  # (because random_pet.new_id is not in configuration)
  - resource "random_pet" "new_id" {
      - id        = "test-subtle-tiger" -> null
      - length    = 2 -> null
      - prefix    = "" -> null
      - separator = "-" -> null
    }

Plan: 1 to add, 0 to change, 1 to destroy.
```

Como podem ver, ao alterar o nome do recurso o terraform pretende destruir o recurso anterior e criar um novo.

⚠️ **NOTA: NÃO DESTRUIR OS RECURSOS / NÃO FAZER APPLY DOS RECURSOS**

Para alterar o nome do recurso sem que o mesmo seja destruído, descomentamos (seleciona o conteúdo e prime `ctrl+k+u` para remover os `#`) o bloco de `move`. Isto fará com que o nome do recurso seja **alterado**, evitando que este seja destruído e recriado.

```bash
moved {
  from = random_pet.new_id
  to = random_pet.moved
}
```

Executar o `plan`:

```bash
terraform plan
```

Como podem ver, agora temos o seguinte resultado:

```bash
random_pet.new_id has moved to random_pet.moved
```

Executar o `apply`:

```bash
terraform apply
```

- ⌛Tempo do apply - 20 segundos.

Desta forma, conseguimos manter o mesmo objeto e mudar o seu nome, sem ter de o destruir!

</details>

---

## 4. Exercício

> **Neste exercicio o objectivo é aplicar alguns dos conhecimentos adquiridos nesta sessão sem que exista uma solução pronta para descomentarem 😉.**

<details><summary>Clica para veres o exercício 4</summary>

Prentende-se o seguinte:

- 👉 Criar uma User-Assigned Managed Identity com os seguintes requisitos:
  - `name` deverá ser prefixada com valor definido no recurso `random_pet.this.id` para evitar colisões de nomes
- 👉 Criar uma Azure Virtual Machine com os seguintes requisitos:
  - Nome da máquina deverá ser: `${random_pet.this.id}-vm-final`
  - Tipo de máquina: `Standard_B1ls`
  - Zona: `westeurope`
  - Deverá conter uma tag.
  - A rede (`subnetwork`) onde a VM vai correr fica ao vosso critério: podem criar uma nova, ou podem usar as já existentes.
  - A máquina deverá correr com a `azurerm_user_assigned_identity` previamente criada.
  - 👉 Devem fazer o exercicio no ficheiro `final-exercise.tf`.

---

### Ajudas😵

💡 Usem a pesquisa no terraform registry / azure para saberem mais informação acerca dos recursos que estão a usar:

- [`azurerm_user_assigned_identity`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity)
- [`azurerm_virtual_machine`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)
- [`azurerm_network_interface`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)
- [`azurerm_subnet`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)

💡 Uma subnet já existente poderá ser `azurerm_subnet.default.id`.

</details>

---

<details>
  <summary>Solution</summary>

  ```hcl
resource "azurerm_user_assigned_identity" "uai" {
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  name                = "${random_pet.this.id}-uai"
}

resource "azurerm_linux_virtual_machine" "final_exercise_machine" {
  name                            = "${random_pet.this.id}-vm-final"
  location                        = var.region
  resource_group_name             = azurerm_resource_group.default.name
  size                            = "Standard_B1ls"
  admin_username                  = "adminuser"
  admin_password                  = "Password1234!"
  disable_password_authentication = false
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.uai.id
    ]
  }
  tags = {
    ## Example
    # environment = "staging"
  }
  lifecycle {
    ignore_changes = [
      identity
    ]
  }
  network_interface_ids = [
    azurerm_network_interface.final_exercise_nic.id
  ]

}

resource "azurerm_network_interface" "final_exercise_nic" {
  name                = "${random_pet.this.id}-nic"
  location            = var.region
  resource_group_name = azurerm_resource_group.default.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
}
```

</details>

---

## 5. Wrap-up & Destroy

Destruir os conteúdos!

```bash
terraform destroy
```

🔚🏁 Chegámos ao fim 🏁🔚

<!-- markdownlint-disable-file MD013 -->
<!-- markdownlint-disable-file MD033 -->
