# Terraforming the Cloud - Part 1

## Temas abordados neste modulo:

* Os 4 principais comandos de terraform: `init`, `plan`, `apply` e `destroy`.
* Estrutura base de um projecto terraform: `main.tf`, `variables.tf`, `outputs.tf`
* Utilização de `variable`, `data`, `resource` e `output`.
* `terrafom.tfvars` é usado por defeito se tiver presente na mesma diretória.
* Gestão de alterações: **simples**, **disruptivas** e **dependentes**.
* Destruição seletiva de recursos.

## iniciar o tutorial

## setup do ambiente (manual)

Esta secção explica como preparar o IDE para poderem executar os comandos do tutorial.

Abaixo seguem dois guias para configuração em:

1. Azure Cloud Shell
2. Visual Studio Code

### configurar a cloud shell

### Clonar o projeto:

```bash
git clone https://github.com/tentwentyone/terraforming-the-cloud-azure-basic-part1.git && cd terraforming-the-cloud-azure-basic-part1
```

## configurar o vscode

> apenas válido para vscode em WSL (windows-subsystem-linux) - instalações em powershell não são suportadas

Caso decidam usar o `vscode`, é necessário garantirem que têm os seguintes binários instalados.
As instruções que seguem vão instalar as tools necessárias:

1. terraform
2. kubectl
3. gcloud

```bash
# instalar as tools necessárias (podem skipar se já têm instaladas)
sudo ./scripts/install-terraform.sh        # terraform
sudo ./scripts/install-kubectl.sh          # kubectl

# reinicializar a shell
exec -l $SHELL

# inicializar o cliente Azure CLI

```

Por fim, podemos clonar o projeto:

```bash
git clone https://github.com/tentwentyone/terraforming-the-cloud-azure-basic-part1.git && cd terraforming-the-cloud-azure-basic-part1
```

## Comandos úteis
