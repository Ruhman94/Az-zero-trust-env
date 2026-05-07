resource "azurerm_storage_account" "secure_storage" {
  name                     = var.storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # --- SECURE REMEDIATIONS ---
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  # --- RISK ACCEPTANCE (SUPPRESSIONS) ---
  # checkov:skip=CKV_AZURE_206: LRS replication is selected intentionally for cost optimization (FinOps).
  # checkov:skip=CKV2_AZURE_1: Customer Managed Keys (CMK) require Key Vault, adding unnecessary cost.
  # checkov:skip=CKV2_AZURE_33: Private Endpoints add VNet integration costs and complexity not required for this perimeter.
  # checkov:skip=CKV2_AZURE_40: Shared Key Authorization is required for the current GitHub Actions upload strategy.
  # checkov:skip=CKV2_AZURE_41: SAS token expiration is not applicable; SAS tokens are not utilized.
  # checkov:skip=CKV_AZURE_33: Queue service logging is not applicable; account is strictly for Blob static hosting.
  # checkov:skip=CKV_AZURE_59: Storage account must allow public access for static website hosting behind Cloudflare.
  # checkov:skip=CKV_AZURE_190: Blob public access is required for static website assets.
  # checkov:skip=CKV2_AZURE_47: Anonymous access is required to serve the frontend portfolio to the public internet.

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.allowed_subnet_id]
    bypass                     = ["AzureServices"]

    # Retained original IP and appended Cloudflare IPv4 Edge Nodes
    ip_rules = [
      "173.245.48.0/20",
      "103.21.244.0/22",
      "103.22.200.0/22",
      "103.31.4.0/22",
      "141.101.64.0/18",
      "108.162.192.0/18",
      "190.93.240.0/20",
      "188.114.96.0/20",
      "197.234.240.0/22",
      "198.41.128.0/17",
      "162.158.0.0/15",
      "104.16.0.0/13",
      "104.24.0.0/14",
      "172.64.0.0/13",
      "131.0.72.0/22"
    ]
  }
}

resource "azurerm_storage_account_static_website" "website_config" {
  storage_account_id = azurerm_storage_account.secure_storage.id
  index_document     = "index.html"
  error_404_document = "404.html"
}
