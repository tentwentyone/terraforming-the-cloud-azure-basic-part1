# # iam
# locals {

#   iam_members = [
#     {
#       member = "group:${var.gcp_trainer_group}"
#       roles = [
#         "roles/editor",
#         "roles/iap.tunnelResourceAccessor",
#         "roles/container.admin"
#       ]
#     }
#   ]

#   iam_members_flattened = flatten([
#     for key, item in local.iam_members : [
#       for role_key, role in item.roles : {
#         member = item.member
#         role   = role
#       }
#     ]
#   ])
# }

# resource "google_project_iam_member" "this" {
#   for_each = { for iam_member in local.iam_members_flattened : "${iam_member.role}|${iam_member.member}" => iam_member }
#   project  = data.google_project.this.name
#   role     = each.value.role
#   member   = each.value.member

#   #Cloud Build creates the SA after enabling the API, so we need it to be enabled first
#   depends_on = [
#     google_project_service.this
#   ]
# }

## --------------------------- AZURE VERSION --------------------------- 

# iam
locals {
  azure_role_assignments = [
    {
      principal_id = "group:${var.azure_trainer_group}"
      role_definition_name = [
        "Contributor",
        "Azure Kubernetes Service Cluster Admin Role"
      ]
    }
  ]

  azure_role_assignments_flattened = flatten([
    for key, item in local.azure_role_assignments : [
      for role_key, role in item.role_definition_name : {
        principal_id = item.principal_id
        role_definition_name = role
      }
    ]
  ])
}

resource "azurerm_role_assignment" "this" {
  for_each = { for role_assignment in local.azure_role_assignments_flattened : "${role_assignment.role_definition_name}|${role_assignment.principal_id}" => role_assignment }
  scope                = var.subscription_id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}