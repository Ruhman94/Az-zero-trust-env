# Configuration variables
$ResourceGroup = "rg-portfolio-prod"
$AccountName = "amsecuredstore001"

Write-Host "Fetching your current public IP..." -ForegroundColor Cyan
$CurrentIP = (Invoke-RestMethod -Uri "https://ifconfig.me")

if ([string]::IsNullOrWhiteSpace($CurrentIP)) {
    Write-Host "Error: Could not retrieve public IP. Check your internet connection." -ForegroundColor Red
    exit 1
}

Write-Host "Current IP detected as: $CurrentIP" -ForegroundColor Green
Write-Host "Opening Azure Storage firewall for your IP..." -ForegroundColor Cyan

# Add the IP to the firewall
az storage account network-rule add `
  --resource-group $ResourceGroup `
  --account-name $AccountName `
  --ip-address $CurrentIP `
  --output none

Write-Host ""
Write-Host "=================================================" -ForegroundColor Yellow
Write-Host "✅ FIREWALL OPEN." -ForegroundColor Green
Write-Host "You can now perform your administrative tasks."
Write-Host "DO NOT CLOSE THIS TERMINAL." -ForegroundColor Red
Write-Host "=================================================" -ForegroundColor Yellow
Write-Host ""

# Pause the script and wait for the user
Read-Host "Press [ENTER] when you are finished to revoke access and lock the firewall..."

Write-Host "Closing Azure Storage firewall..." -ForegroundColor Cyan

# Remove the IP from the firewall
az storage account network-rule remove `
  --resource-group $ResourceGroup `
  --account-name $AccountName `
  --ip-address $CurrentIP `
  --output none

Write-Host "🔒 FIREWALL CLOSED. Zero Trust perimeter restored." -ForegroundColor Green

# run the script with the following command in PowerShell: 
# .\scripts\local_access.ps1