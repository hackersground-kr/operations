# Checks the challenge code from the event payload
Param(
    [string]
    [Parameter(Mandatory=$false)]
    $IssueNumber = "",

    [psobject]
    [Parameter(Mandatory=$false)]
    $GitHubPayload = $null,

    [string]
    [Parameter(Mandatory=$false)]
    $GitHubAccessToken = "",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This checks the challenge code from the event payload

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            [-IssueNumber       <GitHub issue number>] ``
            [-GitHubPayload     <GitHub event payload>] ``
            [-GitHubAccessToken <GitHub access token>] ``

            [-Help]

    Options:
        -IssueNumber:       GitHub issue number. If the event is 'workflow_dispatch', it must be provided.
        -GitHubPayload:     GitHub event payload.
        -GitHubAccessToken: GitHub access token. If not provided, it will look for the 'GH_TOKEN' environment variable.

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

if ($GitHubPayload -eq $null) {
    Write-Host "'GitHubPayload' must be provided" -ForegroundColor Red
    Show-Usage
    Exit 0
}

$eventName = $GitHubPayload.event_name
if (($eventName -eq "workflow_dispatch") -and ([string]::IsNullOrWhiteSpace($IssueNumber))) {
    Write-Host "'IssueNumber' must be provided for the 'workflow_dispatch' event" -ForegroundColor Red
    Show-Usage
    Exit 0
}

$accessToken = [string]::IsNullOrWhiteSpace($GitHubAccessToken) ? $env:GH_TOKEN : $GitHubAccessToken
if (($eventName -eq "workflow_dispatch") -and ([string]::IsNullOrWhiteSpace($accessToken))) {
    Write-Host "'GitHubAccessToken' must be provided through either environment variable or parameter" -ForegroundColor Red
    Show-Usage
    Exit 0
}

$body = ""
if ($eventName -eq "workflow_dispatch") {
    $GitHubPayload = $(gh api /repos/$($GitHubPayload.repository)/issues/$IssueNumber | ConvertFrom-Json)
    $body = $GitHubPayload.body
} else {
    $body = $GitHubPayload.event.issue.body
}

$segments = $body.Split("###", [System.StringSplitOptions]::RemoveEmptyEntries)
$title = $segments[0].Trim()
$code = $title.Replace("챌린지 코드", "").Trim().ToLowerInvariant()
$codeUpper = $code.ToUpperInvariant()
$codes = @( "az-900", "ai-900" )
$isValidCode = $($codes.Contains($code)).ToString().ToLowerInvariant()

$result = @{
    code = $code;
    codeUpper = $codeUpper;
    isValidCode = $isValidCode;
}

Write-Output $($result | ConvertTo-Json -Depth 100)

Remove-Variable result
Remove-Variable isValidCode
Remove-Variable codes
Remove-Variable codeUpper
Remove-Variable code
Remove-Variable title
Remove-Variable segments
Remove-Variable body