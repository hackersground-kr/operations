# Assign the given members to the "Contributor" role to the given resource group
Param(
    [string]
    [Parameter(Mandatory=$false)]
    $Members = "",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This assigns the given members the 'Contributor' role to the subscription

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            [-Members <List of members>] ``

            [-Help]

    Options:
        -Members:       A comma-delimited list of member emails

        -Help:          Show this message.
"

    Exit 0
}

# Show usage
$needHelp = $Help -eq $true
if ($needHelp -eq $true) {
    Show-Usage
    Exit 0
}

$emails = $Members
if ([String]::IsNullOrWhiteSpace($emails) -eq $true) {
    $emails = $(Get-Content -Path ./emails.txt)
}

if ([String]::IsNullOrWhiteSpace($emails) -eq $true) {
    Write-Host "No members given" -ForegroundColor Red
    Show-Usage
    Exit 0
}

$emails = $(Get-Content -Path ./emails.txt)
$emails | ForEach-Object {
    $email = $_.Trim()
    $userId = $(az ad user list --query "[?mail == '$email'].id" -o tsv)
    $subscriptionId = $(az account show --query "id" -o tsv)
    $assigned = $(az role assignment create --role "Contributor" --assignee $userId --scope "/subscriptions/$subscriptionId")
}
