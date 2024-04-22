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
  - [Vault Deletion](#vault-deletion)

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

Caso o script não esteja a correr, usar este comando primeiro:

```bash
chmod 100 ./scripts/get-azure-credentials.sh
```

Após isto, podem verificar a subscrição em que se encontram usando este comando:

```bash
az account show --query name -o tsv
```

Na eventualidade da subscrição não ser <subscrição correcta> faz o seguinte comando:

```bash
az account set --subscription $AZURE_SUBSCRIPTION_ID
```

💡 Ao fazerem copy-paste na `Azure Cloud Shell`, aconselhamos a que "colem" os conteúdos com `ctrl+shift+v`.

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

### Comando `apply`

> *[from docs:](https://www.terraform.io/docs/cli/commands/apply.html) The `terraform apply` command executes the actions proposed in a Terraform plan.*

```bash
terraform apply
```

⏳ Tempo do apply - 1 min.

Após o apply repara nos seguintes **outputs**

![alt text](/images/outputs.png)

Esta informação diz respeito aos recursos que criaste!

Para verificares que os recursos remotos foram criados utiliza os seguintes comandos:

`Resource Group:`

```bash
az group show --name=$(terraform output -raw my_identifier)-rg
```

### Comando `destroy`

> *[from docs:](https://www.terraform.io/docs/cli/commands/destroy.html) The `terraform destroy` command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.*
>
> *While you will typically not want to destroy long-lived objects in a production environment, Terraform is sometimes used to manage ephemeral infrastructure for development purposes, in which case you can use `terraform destroy` to conveniently clean up all of those temporary objects once you are finished with your work.*

```bash
terraform destroy
```

Para verificares que os recursos remotos foram destruídos:

`Resource Group:`

```bash
az group show --name=$(terraform output -raw my_identifier)-rg
```

</details>

</details>

---

## 2. Lidar com as alterações

> **Nesta secção iremos demonstrar a utilização de terraform perante vários tipos de alterações.**

<details><summary>Clica para veres o exercício 2</summary>

### Criar uma Máquina Virtual

- Abrir o ficheiro `main.tf`
- Descomentar o bloco referente ao `exercicio 2.` - seleciona o bloco referente ao exercício 2 e de seguida `ctrl+k+u` ou se estiveres num mac `cmd+k+u`.
- Descomentar o bloco referente ao `exercicio 2` no ficheiro `outputs.tf`
- Não te esqueças de salvar o ficheiro depois de fazeres alterações! `ctrl+s` ou se estiveres num mac `cmd+s`.
- ⌛Tempo do apply 1:30 min.

Verifica que a virtual machine foi criada!

```hcl

az vm show -g=$(terraform output -raw my_identifier)-rg -n=$(terraform output -raw my_identifier)-vm -d

```

### Assegurar a criação dos recursos (`plan` e `apply`)

```bash
terraform plan
```

```bash
terraform apply
```

</details>

### 2.1 Introduzindo alterações não-disruptivas

> **As alterações não disruptivas são pequenas alterações que possibilitam a re-configuração do recurso sem que este tenha que ser recriado, não afetando as suas dependências**

<details><summary>Clica para veres o exercício 2.1</summary>

- Edita o ficheiro `main.tf`, localizar o recurso `azurerm_virtual_machine.my_virtual_machine` e descomenta o campo `tags` - define uma tag para a tua vm!
- Guarda as tuas alterações! `ctrl+s` ou se estiveres num mac `cmd+s`.
- ⌛Tempo do apply 30 segundos.

(ie: `tags = {project = terraform_workshop}`)

Executar `terraform plan` e verificar que o Terraform irá efectuar um `update in-place` - isto é uma alteração simples.

```bash
terraform plan
```

Executar `terraform apply`.

```bash
terraform apply
```

</details>

---

### 2.2 Introduzindo alterações disruptivas

> **As alterações disruptivas são provocadas por alterações de propriedades que provocam a recriação do recurso e consequentes dependencias**

<details><summary>Clica para veres o exercício 2.2</summary>

- No ficheiro `main.tf`, localizar o recurso `azurerm_virtual_machine.my_virtual_machine` e alterar o campo `name` para o seguinte: `"${random_pet.this.id}-vm-new"`
- Guarda as tuas alterações! `ctrl+s` ou se estiveres num mac `cmd+s`.
- Executar `terraform plan` e verificar que o Terraform irá efectuar um `replacement` - é uma alteração disruptiva.
- ⌛Tempo do apply 2 min.

```bash
terraform plan
```

Aplicar o `plan`, verificar e acompanhar observando na execução do terraform que irá acontecer um `destroy` seguido de um `create`:

```bash
terraform apply
```

</details>

---

### 2.3 Introduzindo alterações dependentes

> **As alterações também podem ser derivadas de dependêndencias, e quando isso acontece, todo o grafo de dependendencias é afetado.**

<details><summary>Clica para veres o exercício 2.3</summary>

- Editar o ficheiro terraform.tfvars e alterar o valor da variavel `prefix` de `az` para `new`
- Guarda as tuas alterações! `ctrl+s` ou se estiveres num mac `cmd+s`.
- ⌛Tempo do apply 2:30 min.

Executar o `plan` e verificar todo o grafo de dependencias é afetado:

```bash
terraform plan
```

Executar o `apply`:

```bash
terraform apply
```

[Clica aqui caso não consigas prosseguir](#vault-deletion)

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
az network vnet create --name=$(terraform output -raw my_identifier)-vnet --subscription=$(terraform output -raw subscription_id) --resource-group=$(terraform output -raw my_identifier)-rg
```

- ⌛Tempo para a criação do recurso 30 segundos.

</details>

---

### 3.2 Importar recursos existentes

> **Nesta parte vamos criar o bloco de `import` para fazer a importação do recurso criado anteriormente.**

<details><summary>Clica para veres o exercício 3.2</summary>

> O processo de importação de recursos consiste em duas partes:

- Obtenção da informação do recurso na cloud.
- Criação de um bloco `import` que irá indicar ao terraform que o recurso já existe e que o mesmo deve ser gerido pelo terraform.
- ⌛Tempo do apply - 10 segundos.

O primeiro passo da importação de recursos é [declarar a importação dos mesmos](https://developer.hashicorp.com/terraform/tutorials/state/state-import).

Para isto, [temos que definir o bloco `import`](https://developer.hashicorp.com/terraform/tutorials/state/state-import#define-import-block), que necessita de dois argumentos:

- `id`: o id do recurso a importar do lado de Azure
- `to`: o identificador terraform do recurso a importar

Exemplo de um bloco `import`:

```hcl
 import {
   id = "/subscriptions/$(terraform output -raw subscription_id)/resourceGroups/${azurerm_resource_group.default.name}/providers/Microsoft.Network/virtualNetworks/${random_pet.this.id}-vnet"
   to = azurerm_virtual_network.my_imported_vnet
 }
```

- Para o exercicio que segue, vamos ao ficheiro `import-exercise.tf` descomentar os blocos `import { ... }`
- Vai também ao ficheiro `outputs.tf` e descomenta o bloco referente ao exercício `3.2`.
- Não te esqueças de gravar as tuas alterações com `ctrl+s` ou se estiveres num mac `cmd+s`.

- O que estamos a fazer é a definir um bloco de `import` em que especificamos o recurso a importar e o seu destino.
- Temos no entanto de definir o destino do mesmo para que possamos alojar o recurso e passar a geri-lo por terraform, é essa a razão pela qual definimos um bloco de `resource` no `ìmport-exercise.tf`.

---

Vamos então correr o `plan`.

```bash
terraform plan
```

Por fim, o `apply` para executar a operação planeada:

```bash
terraform apply
```

Agora, se tentarmos agora fazer `plan` novamente, vamos verificar que o terraform indica que não tem alterações à infraestrutura, confirmando que os recursos foram importados som sucesso.

Testar o `plan`:

```bash
terraform plan
```

**E se não soubessemos a informação referente ao recurso que queriamos importar?**

Antes de efetuar a importação precisamos de obter o `id` do recurso a importar do lado de Azure tal como descrito nas instruções de importação para o recurso [`azurerm_virtual_network`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network#import).

Existem várias formas para obter o `id` dos recursos, neste exemplo usamos os comandos `azure`:

Obter o `id` para a `azurerm_virtual_network`:

```bash
az network vnet show -n=$(terraform output -raw my_identifier)-vnet -g=$(terraform output -raw my_identifier)-rg
```

</details>

---

### 3.3 Move

> **O [move](https://developer.hashicorp.com/terraform/cli/state/move) é usado em casos onde é importante preservar o objeto existente na infraestrutura, reorganizando a nossa configuração de Terraform, renomeando recursos, entre outros casos mais complexos como movendo recursos entre módulos.**

<details><summary>Clica para veres o exercício 3.3</summary>

Vamos agora supôr que queremos mudar o nome dum recurso em terraform. Se formos mudar o nome do recurso, o terraform irá considerar que estamos a destruir o recurso anterior e a querer criar um novo com as mesmas especificações.

Para evitar esse comportamento, uma vez que não queremos destruir o recurso, vamos usar o `move`.

- Criar um novo random.pet
- novo plan
- novo apply
- descomentar o move e trocar o nome do random.pet.

```bash
moved {
  from = <nome_do_recurso_a_mudar>
  to = <novo_nome_do_recurso>
}
```

Vamos mudar o nome do recurso `azurerm_virtual_network` para `my_imported_vnet_new` e descomentar o bloco de move.

Agora, o `terraform plan` em vez de destruir um recurso e criar um novo, deve apresentar o seguinte:

![alt text](/images/plan_moved_example.png)

Desta forma, conseguimos manter o mesmo objeto e mudar o seu nome, sem ter de o destruir!

</details>

---

## 4. Exercício

> **Neste exercicio o objectivo é aplicar alguns dos conhecimentos adquiridos nesta sessão sem que exista uma solução pronta para descomentarem 😉.**

<details><summary>Clica para veres o exercício 4</summary>

Prentende-se o seguinte:

- 👉 Criar uma Azure Assigned Identity com os seguintes requisitos:
  - `name` deverá ser prefixada com valor definido no recurso `random_pet.this.id` para evitar colisões de nomes
- 👉 Criar uma Azure Virtual Machine com os seguintes requisitos:
  - Nome da máquina deverá ser prefixado com valor definido no recurso `random_pet.this.id` para evitar colisões de nomes
  - Tipo de máquina: `Standard_B1s`
  - Zona: `westeurope`
  - Deverá conter uma tag (`project = terraform-part-1`)
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

💡 Uma subnet já existente poderá ser `data.azurerm_subnet.my_subnet.id`.

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
  name                            = "${random_pet.this.id}-vm-new"
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
    subnet_id                     = data.azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

data "azurerm_subnet" "my_subnet" {
  name                 = "${random_pet.this.id}-subnet"
  virtual_network_name = "tf-azure-workshop-vnet"
  resource_group_name  = "tf-azure-workshop-rg"
}
```

</details>

---

## 5. wrap-up & destroy

Destruir os conteúdos!

```bash
terraform destroy
```

🔚🏁 Chegámos ao fim 🏁🔚

## Possíveis Problemas

### Vault Deletion

<details>
  <summary>⚠️ Somente caso estejas a ter problemas a apagar recursos </summary>

Na eventualidade de o `terraform destroy` estar a demorar mais tempo do que o expectável é necessário vermos se não foi criado um `vault` – isto pode impedir a destruição de recursos de acontecer conforme planeado.

- Para garantirmos que tal não acontece temos de ir ao nosso `resource group`.

![alt text](/images/check_rg.png)

- Certifica-te que a subscrição em que estás a procurar é aquela em que criaste o teu `resource group`, quando o encontrares seleciona-o.

![alt text](/images/choose_rg.png)

- Na eventualidade deste recurso existir dentro do teu `resource-group` é necessário remove-lo para que possas prosseguir. Para tal, clica no recurso do `Vault`.

![alt text](/images/choose_vault.png)

- À esquerda, seleciona a opção de `settings` e a seguir `properties`.
Entre as opções procura pela opção `Soft Delete and security settings`, clica em update.

![alt text](/images/soft_delete.png)

- Uma vez na janela dos settings do `soft delete` retira o ☑️ destas opções – isto vai-te permitir fazer delete do recurso.

![alt text](/images/soft_settings.png)

- O resultado final há de ser algo semelhante a este exemplo. Não te esqueças de clicar no botão de update para confirmares as tuas alterações.

![alt text](/images/update_settings.png)

- Antes de o apagarmos temos de verificar se este `vault` tem backups armazenados para algum dos recursos que criámos. Regressa à tab de `overview`.

![alt text](/images/overview.png)

- Entra na opção de `backup`.

![alt text](/images/backup.png)

- Faz scroll até encontrares a informação relativa ao uso do recurso. Como podes ver, o `vault` está a assegurar o `backup` de 1 recurso – para veres em maior detalhe clica nessa opção.

![alt text](/images/backup_items.png)

- Neste caso, o `backup` diz respeito à `virtual machine` que criámos anteriormente. Clica nesse `backup`.

![alt text](/images/backup_items_count.png)

- Como podes ver, temos um `backup` dessa `virtual machine`, temos de clicar nas opções do recurso.

![alt text](/images/vault_options.png)

Clica na opção – stop `backup`.

![alt text](/images/vault_optionsx2.png)

- Aqui, altera a opção de `Stop backup level` para `Delete backup data`. Em caso de dúvida quanto ao nome do recurso podes comprovar o nome do mesmo no canto superior esquerdo – como na imagem. Quando tiveres pronto, clica em `Stop backup`.

![alt text](/images/stop_backup.png)

- Podes utilizar o botão de `refresh` para verificar que os recursos foram destruídos.

![alt text](/images/refresh.png)

- Regressa ao teu `resource group` e destrói o `vault`, para que possas prosseguir. Clica no nome do teu `resource group`.

![alt text](/images/back_to_rg.png)

- Seleciona o recurso do `Vault` existente e nas opções escolhe `delete`.

![alt text](/images/vault_delete.png)

Escreve `delete` e confirma a remoção do recurso.

![alt text](/images/delete_vault_resource.png)

Podes agora voltar à Cloud Shell e fazer o comando `terraform destroy` para continuares com a destruição dos restantes recursos.

</details>

<!-- markdownlint-disable-file MD013 -->
<!-- markdownlint-disable-file MD033 -->
