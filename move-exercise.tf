














# ## 3.3 Descomentar apenas quando for pedido.

## 3.3.1
# resource "random_pet" "new_id" {
#   length    = 2
#   separator = "-"
#   prefix    = var.prefix
# }

## 3.3.2
## Descomentar após a criação do random_pet acima
# moved {
#   from = random_pet.new_id
#   to = random_pet.moved
# }
