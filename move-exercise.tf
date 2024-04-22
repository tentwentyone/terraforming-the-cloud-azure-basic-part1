# ## 3.3 Descomentar apenas quando for pedido.

## o bloco de import do 3.2 deve ser comentado/removido.

# resource "random_pet" "new_id" {
#   length    = 2
#   separator = "-"
#   prefix    = var.prefix
# }


# moved {
#   from = random_pet.new_id
#   to = random_pet.moved
# }