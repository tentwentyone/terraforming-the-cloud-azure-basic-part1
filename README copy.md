# terraforming the cloud - part 1

Temas abordados neste modulo:

* Os 4 principais comandos de terraform: `init`, `plan`, `apply` e `destroy`.
* Estrutura base de um projecto terraform: `main.tf`, `variables.tf`, `outputs.tf`
* Utilização de `variable`, `data`, `resource` e `output`.
* `terrafom.tfvars` é usado por defeito se tiver presente na mesma diretória.
* Gestão de alterações: **simples**, **disruptivas** e **dependentes**.
* Destruição seletiva de recursos.

## Inicio

Esta secção explica como preparar a Azure Cloud Shell para executarem os comandos.

### Configurar a cloud shell

Abrir o endereço <https://portal.azure.com/#cloudshell/> e autenticar.

Abrir a Cloud Shell:

![alt text](/doc-images/image.png)

Selecionar Bash:

![alt text](/doc-images/image-1.png)

Seleciona a subscrição <>

![alt text](/doc-images/image-2.png)

Clonar o projeto:

```bash
git clone https://github.com/tentwentyone/terraforming-the-cloud-azure-basic-part1.git && cd terraforming-the-cloud--azure-basic-part1
```

Mudar para o editor:

![alt text](/doc-images/image-3.png)

Confirmar a mudança:

![alt text](/doc-images/image-4.png)

Abrir o editor:

![alt text](/doc-images/image-5.png)

![alt text](/doc-images/image-6.png)

```bash
# obter a lista de machine-types
gcloud compute machine-types list --zones=europe-west1-b --sort-by CPUS

# listar a lista de regioes disponiveis
gcloud compute regions list

# listar as zonas disponiveis para uma dada regiao
gcloud compute zones list | grep europe-west1

# listar VMs para um dado projecto
gcloud compute instances list --project <project-id>

# ligar à VM usando o IAP
gcloud compute ssh <vm-name> --project=<project-id>1 --zone europe-west1-b

# obter o self-link de uma vpc a importar do lado do GCP
gcloud compute networks list --uri | grep "$(terraform output -raw my_identifier)"

# obter o self-link de uma subnet a importar do lado do GCP
gcloud compute networks subnets list --uri | grep "$(terraform output -raw my_identifier)"
```
<!-- markdownlint-disable-file MD013 -->

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)
