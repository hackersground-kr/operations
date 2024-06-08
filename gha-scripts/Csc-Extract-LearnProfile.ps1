# Extracts the learn profile link from the issue body.

param(
    [string]
    [Parameter(Mandatory=$true)]
    $body= "",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This extracts the learn profile link from the issue body.

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            [-body  <issue body>] ``
            [-Help]

    Options:
        -body:       Issue body. 

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

if (([string]::IsNullOrWhiteSpace($body))) {
    Write-Host "'you must write issue body." -ForegroundColor Red
    Show-Usage
    Exit 0
}

$scriptUrl = "https://raw.githubusercontent.com/hackersground-kr/operations/main/get-learnprofile/Get-LearnProfile.ps1"
Invoke-RestMethod $scriptUrl | Out-File ~/Get-LearnProfile.ps1

$profileLink = $(~/Get-LearnProfile.ps1 -Text $(body))

Write-Output $profileLink

Remove-Variable scriptUrl
Remove-Variable profileLink

