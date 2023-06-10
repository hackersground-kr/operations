$emails = $(Get-Content -Path ./emails.txt)
$emails | ForEach-Object {
    $email = $_.Trim()
    $userId = $(az ad user list --query "[?mail == '$email'].id" -o tsv)
    $subscriptionId = $(az account show --query "id" -o tsv)
    $assigned = $(az role assignment create --role "Contributor" --assignee $userId --scope "/subscriptions/$subscriptionId")
}
