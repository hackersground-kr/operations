# Assign the given members to the "Contributor" role to the given resource group
Param(
    [string]
    [Parameter(Mandatory=$false)]
    $Members = "",

    [string]
    [Parameter(Mandatory=$false)]
    $ResourceGroup = "",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This assigns the given members the 'Contributor' role to the given resource group

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            [-Members <List of members>] ``
            [-ResourceGroup <Resource group name>] ``

            [-Help]

    Options:
        -Members:       A comma-delimited list of member emails
        -ResourceGroup: The resource group name

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

if ([String]::IsNullOrWhiteSpace($ResourceGroup) -eq $true) {
    Write-Host "No resource group given" -ForegroundColor Red
    Show-Usage
    Exit 0
}

$emails = $Members -split "," | ForEach-Object { $_.Trim() } | Where-Object { [String]::IsNullOrWhiteSpace($_) -eq $false }
if ($emails.Length -eq 0) {
    $emails = $(Get-Content -Path ./emails.txt)
}

if ($emails.Length -eq 0) {
    Write-Host "No members given" -ForegroundColor Red
    Show-Usage
    Exit 0
}

$emails | ForEach-Object {
    $email = $_.Trim()
    $userId = $(az ad user list --query "[?mail == '$email'].id" -o tsv)
    $subscriptionId = $(az account show --query "id" -o tsv)
    $assigned = $(az role assignment create --role "Contributor" --assignee $userId --scope "/subscriptions/$subscriptionId/resourceGroups/$ResourceGroup")
}
