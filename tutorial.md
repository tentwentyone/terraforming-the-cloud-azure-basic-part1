# terraforming the cloud - part 1

![Terraforming the cloud architecture][tfc-arch]

## Temas abordados neste modulo

* Estrutura base de um projecto terraform: `main.tf`, `variables.tf`, `outputs.tf`
* Utilização de `variable`, `data`, `resource` e `output`.
* `terrafom.tfvars` é usado por defeito se tiver presente na mesma diretória.
* Os 4 principais comandos de terraform: `init`, `plan`, `apply` e `destroy`.
* Gestão de alterações: **simples**, **disruptivas** e **dependentes**.
* Importação de recursos existentes.
* Exercicio final.

**Tempo estimado**: Cerca de 2 horas

**Pré requsitos**: Antes de começares, é necessário verificares algumas coisas:

Certifica-te que tens a `azure-cloud-shell` devidamente configurada correndo este comando:

```bash
az account show
```

Na eventualidade da subscrição não ser <subscrição correcta> faz o seguinte comando:

```bash
az account set --subscription <subscription_name>
```

Para evitar que o terraform peça o nome do projeto a cada `apply`, podemos definir o nome do projeto por defeito:

* Abrir o ficheiro `terraform.tfvars`
* Descomentar a linha `subscription_id` e adicionar o id do projeto.

## 1. O primeiro contacto

Nesta secção iremos executar os 4 principais comandos de terraform: `init`, `plan`, `apply` e `destroy`.

### Comando `init`

> *[from docs:](https://www.terraform.io/docs/cli/commands/init.html) The `terraform init` command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.*

```bash
terraform init
```

### Comando `plan`

> *[from docs:](https://www.terraform.io/docs/cli/commands/plan.html) The `terraform plan` command creates an execution plan. By default, creating a plan consists of:*
>
> * *Reading the current state of any already-existing remote objects to make sure that the Terraform state is up-to-date.*
> * *Comparing the current configuration to the prior state and noting any differences.*
> * *Proposing a set of change actions that should, if applied, make the remote objects match the configuration.*

```bash
terraform plan -out plan.tfplan
```

### Comando `apply`

> *[from docs:](https://www.terraform.io/docs/cli/commands/apply.html) The `terraform apply` command executes the actions proposed in a Terraform plan.*

```bash
terraform apply plan.tfplan
```

Após o apply repara nos seguintes **outputs**

![alt text](/images/outputs.png)

Esta informação diz respeito aos recursos que criaste!

Para verificares que os recursos remotos foram criados utiliza os seguintes comandos:

Resource Group:

```bash
az group list | grep <my_generic_identifier_value>
```

Virtual Network:

```bash
az network vnet list | grep <my_generic_identifier_value>
```

### Comando `destroy`

> *[from docs:](https://www.terraform.io/docs/cli/commands/destroy.html) The `terraform destroy` command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.*
>
> *While you will typically not want to destroy long-lived objects in a production environment, Terraform is sometimes used to manage ephemeral infrastructure for development purposes, in which case you can use `terraform destroy` to conveniently clean up all of those temporary objects once you are finished with your work.*

```bash
terraform destroy
```

Para verificares que os recursos remotos foram destruídos:

Resource Group:

```bash
az group list | grep <my_generic_identifier_value>
```

Virtual Network:

```bash
az network vnet list | grep <my_generic_identifier_value>
```

## 2. Lidar com as alterações

Nesta secção iremos demonstrar a utilização de terraform perante varios tipos de alterações.

> *Assegurar que os recursos previamente criados foram devidamente destruidos: `terraform destroy`.`*

### Criar uma Máquina Virtual

* Abrir o ficheiro `main.tf`
* Descomentar o bloco referente ao `exercicio 2.`

### Assegurar a criação dos recursos (`plan` e `apply`)

```bash
terraform plan -out plan.tfplan
```

```bash
terraform apply plan.tfplan
```

### 2.1 Introduzindo alterações não-disruptivas

> **As alterações não disruptivas são pequenas alterações que possibilitam a re-configuração do recurso sem que este tenha que ser recriado, não afetando as suas dependências**

* Editar o ficheiro `main.tf`, localizar o recurso `azurerm_virtual_machine.my_virtual_machine` e descomentar o campo `tags` - define uma tag para a tua vm!

Executar `terraform plan -out plan.tfplan` e verificar que o Terraform irá efectuar um `update in-place` - isto é uma alteração simples.

```bash
terraform plan -out plan.tfplan
```

Executar `terraform apply plan.tfplan`.

```bash
terraform apply plan.tfplan
```

### 2.2 Introduzindo alterações disruptivas

> **As alterações disruptivas são provocadas por alterações de propriedades que provocam a recriação do recurso e consequentes dependencias**

* No ficheiro main.tf, localizar o recurso `azurerm_virtual_machine.tfworkshop` e alterar o campo `name` para o seguinte: `"${random_pet.this.id}-vm-new"`
* Executar `terraform plan -out plan.tfplan` e verificar que o Terraform irá efectuar um `replacement` - é uma alteração disruptiva.

```bash
terraform plan -out plan.tfplan
```

Aplicar o `plan`, verificar e acompanhar observando na execução do terraform que irá acontecer um `destroy` seguido de um `create`:

```bash
terraform apply plan.tfplan
```

Verificar que o SSH continua a ser possível, mesmo com a nova instância:

<sub>*o comando pode não funcionar logo...pode demorar até 1 minuto depois da VM ser criada.*</sub>

```bash
az ssh vm $(terraform output -raw vm_name) --subscription=$(terraform output -raw subscription_id) --location $(terraform output -raw vm_location)
```

### 2.3 Introduzindo alterações dependentes

> **As alterações também podem ser derivadas de dependêndencias, e quando isso acontece, todo o grafo de dependendencias é afetado.**

* Editar o ficheiro terraform.tfvars e alterar o valor da variavel `prefix` de `az` para `new`

Executar o `plan` e verificar todo o grafo de dependencias é afetado:

```bash
terraform plan -out plan.tfplan
```

Executar o `apply`:

```bash
terraform apply plan.tfplan
```

*Notem que apenas alterámos uma mera variável...*

>**NOTA: NÃO DESTRUIR OS RECURSOS pois vamos usa-los no próximo passo**

## 3. importar recursos já existentes

Disponível a partir do terraform `v1.5`. Toda a documentação deste capítulo está descrita [aqui](https://developer.hashicorp.com/terraform/tutorials/state/state-import).

> *[from docs:](https://developer.hashicorp.com/terraform/tutorials/state/state-import)Terraform supports bringing your existing infrastructure under its management. By importing resources into Terraform, you can consistently manage your infrastructure using a common workflow.*
>
> *This is a great way to slowly transition infrastructure to Terraform, or to be able to be confident that you can use Terraform in the future if it potentially doesn't support every feature you need today.*

Assegurar que não existem alterações pendentes:

```bash
terraform plan -out plan.tfplan
```

```bash
terraform apply plan.tfplan
```

### 3.1 Criar um recurso (`azurerm_virtual_network`) usando os comandos azure

Nesta parte vamos criar recursos recorrendo a uma ferramenta externa ao terraform por forma a criar um use-case de recursos que existem fora do `state` do terraform.

O objetivo é simular recursos que já existiam para que os possamos *terraformar*.

Criar uma Virtual Network:

```bash
az network vnet create $(terraform output -raw my_identifier)-vpc --subscription=$(terraform output -raw subscription_id)
```

### 3.2 Importar recursos existentes

O processo de importação de recursos consiste em duas partes:

* obtenção da informação do recurso na cloud
* criação de um bloco `import` que irá indicar ao terraform que o recurso já existe e que o mesmo deve ser gerido pelo terraform.

---

O primeiro passo da importação de recursos é [declarar a importação dos mesmos](https://developer.hashicorp.com/terraform/tutorials/state/state-import).

Para isto, [temos que definir o bloco `import`](https://developer.hashicorp.com/terraform/tutorials/state/state-import#define-import-block), que necessita de dois argumentos:

* `id`: o id do recurso a importar do lado de Azure
* `to`: o identificador terraform do recurso a importar

Exemplo de um bloco `import`:

```hcl
import {
  id = "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Network/virtualNetworks/vnet-name"
  to = azurerm_virtual_network.imported
}
```

Para o exercicio que segue, vamos ao ficheiro import-exercise.tf e descomentar os blocos `import { ... }`

Antes de efetuar a importação precisamos de obter o `id` do recurso a importar do lado de Azure tal como descrito nas instruções de importação para o recurso [`azurerm_virtual_network`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network#import).

Existem várias formas para obter o `id` dos recursos, neste exemplo usamos os comandos `azure`:

Obter o `id` para a `azurerm_virtual_network`:

```bash
az network vnet list -g sweet-doberman-rg | grep "$(terraform output -raw my_generic_identifier)"
```

Agora que temos o identificador dos recursos, temos que preencher o respetivo `id` no bloco `import`:

* Substituir o `id` do recurso `azurerm_virtual_network` no bloco `import` do ficheiro `import-exercise.tf`

---

Vamos então correr o `plan`, mas vamos usar a opção `-generate-config-out` para gerar o código dos recursos que vão ser importados para o ficheiro `imported-resources.tf`:

```bash
terraform plan -out plan.tfplan -generate-config-out imported-resources.tf
```

Podemos inspeccionar os conteudos do ficheiro imported-resources.tf.

Por fim, o `apply` para executar a operação planeada:

```bash
terraform apply plan.tfplan
```

Agora, se tentarmos agora fazer `plan` novamente, vamos verificar que o terraform indica que não tem alterações à infraestrutura, confirmando que os recursos foram importados som sucesso.

Testar o `plan`:

```bash
terraform plan -out plan.tfplan
```

## 4. Exercício

Neste exercicio o objectivo é aplicar alguns dos conhecimentos adquiridos nesta sessão sem que exista uma solução pronta para descomentarem 😉.

Prentende-se o seguinte:

* 👉 Devem fazer o exercicio no ficheiro final-exercise.tf"final-exercise.tf.
* 👉 Criar uma Azure Assigned Identity com os seguintes requisitos:
  * `name` deverá ser prefixada com valor definido no recurso `random_pet.this.id` para evitar colisões de nomes
* 👉 Criar uma Azure Virtual Machine com os seguintes requisitos:
  * Nome da máquina deverá ser prefixado com valor definido no recurso `random_pet.this.id` para evitar colisões de nomes
  * Tipo de máquina: `Standard_B1s`
  * Zona: `westeurope`
  * Deverá conter uma tag `allow-iap`
  * A rede (`subnetwork`) onde a VM vai correr fica ao vosso critério: podem criar uma nova, ou podem usar as já existentes.
  * A máquina deverá correr com a `azurerm_user_assigned_identity` previamente criada.
* 👉 Por fim, deverão testar o correto aprovisionamento fazendo `ssh` para a máquina que acabaram de criar.

### Ajudas😵

💡 Usem a pesquisa no terraform registry / azure para saberem mais informação acerca dos recursos que estão a usar:

* [`azurerm_user_assigned_identity`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity)
* [`azurerm_virtual_machine`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine)

💡 Uma subnet já existente poderá ser `data.azurerm_virtual_network.default.id`.

</details>

## 5. wrap-up & destroy

Destruir os conteúdos!

```bash
terraform destroy
```

🔚🏁 Chegámos ao fim 🏁🔚

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

<!-- markdownlint-disable-file MD013 -->
<!-- markdownlint-disable-file MD033 -->

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[tfc-arch]: https://github.com/nosportugal/terraforming-the-cloud-part1/raw/main/images/terraforming-the-cloud.png "Terraforming the cloud architecture"
