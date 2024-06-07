# Check issue details

param(
    [string]
    [Parameter(Mandatory=$false)]
    $Issuenumber= "",

    [psobject]
    [Parameter(Mandatory=$false)]
    $GitHubPayload=$null,

    [string]
    [Parameter(Mandatory=$false)]
    $GitHubAccessToken = "",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This checks the issue details from the event payload

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

if($GitHubPayload -eq $null) {
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

if ($eventName -ne "workflow_dispatch") {
    $IssueNumber = $GitHubPayload.event.issue.number
}

$accessToken = [string]::IsNullOrWhiteSpace($GitHubAccessToken) ? $env:GH_TOKEN : $GitHubAccessToken
if (($eventName -eq "workflow_dispatch") -and ([string]::IsNullOrWhiteSpace($accessToken))) {
    Write-Host "'GitHubAccessToken' must be provided through either environment variable or parameter" -ForegroundColor Red
    Show-Usage
    Exit 0
}

$body = ""
if ($eventName -eq "workflow_dispatch") {
    $GitHubPayload = $(gh api /repos/$repository/issues/$IssueNumber | ConvertFrom-Json)
    $body = $GitHubPayload.body
} else {
    $body = $GitHubPayload.event.issue.body
}

$title = $GitHubPayload.title
if ($GitHubPayload.event.repository.created_at -ne $null) {
    $created_at=$($GitHubPayload.event.repository.created_at).ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
} else {
    $created_at = $null
}
$githubID=$GitHubPayload.user.login
$assignee=$GitHubPayload.assignee

$result = @{
    IssueNumber = $IssueNumber;
    title = $title;
    body = $body;
    created_at = $created_at;
    githubID = $githubID;
    assignee = $assignee;
}

Write-Output $($result | ConvertTo-Json -Depth 100)

Remove-Variable result
Remove-Variable assignee
Remove-Variable githubID
Remove-Variable created_at
Remove-Variable body
Remove-Variable title