# Get random assignee from the team members.

param(
    [string]
    [Parameter(Mandatory=$false)]
    $Assignees= "",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This gets random assignee from the team members.

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            [-Assignees  <checking members>] ``
            [-Help]

    Options:
        -Assignees:       checking members. 

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

if (([string]::IsNullOrWhiteSpace($Assignees))) {
    Write-Host "'you must write Assignees to get random assignee." -ForegroundColor Red
    Show-Usage
    Exit 0
}


$scriptUrl = "https://raw.githubusercontent.com/hackersground-kr/operations/main/get-randomassignee/Get-RandomAssignee.ps1"
Invoke-RestMethod $scriptUrl | Out-File ~/Get-RandomAssignee.ps1
$assignee = $(~/Get-RandomAssignee.ps1 -Assignees "$Assignees")

Write-Output $assignee

Remove-Variable scriptUrl
Remove-Variable assignee

