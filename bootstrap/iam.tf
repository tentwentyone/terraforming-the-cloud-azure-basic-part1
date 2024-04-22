locals {
  azure_role_assignments = [
    {
      principal_id = "${var.azure_trainer_group}"
      role_definition_name = [
        # "Contributor",
        # "Azure Kubernetes Service Cluster Admin Role"
      ]
    }
  ]

  azure_role_assignments_flattened = flatten([
    for key, item in local.azure_role_assignments : [
      for role_key, role in item.role_definition_name : {
        principal_id         = item.principal_id
        role_definition_name = role
      }
    ]
  ])
}

resource "azurerm_role_assignment" "this" {
  for_each             = { for role_assignment in local.azure_role_assignments_flattened : "${role_assignment.role_definition_name}|${role_assignment.principal_id}" => role_assignment }
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}
