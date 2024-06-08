# Check issue details

param(
    [string]
    [Parameter(Mandatory=$false)]
    $IssueNumber= "",

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
if ($null -eq $IssueNumber) {
    Write-Host "IssueNumber is null"
    return
}
if ($null -eq $GitHubPayload) {
    Write-Host "GitHubPayload is null"
    return
}

# Show usage
$needHelp = $Help -eq $true
if ($needHelp -eq $true) {
  Show-Usage
  Exit 0
}

#debug
if($GitHubPayload -eq $null) {
    Write-Host "'GitHubPayload' must be provided" -ForegroundColor Red
    Show-Usage
    Exit 0
}
else {
    Write-Host "$GitHubPayload'" -ForegroundColor Red
}
#debug

$eventName = $GitHubPayload.event_name
if (($eventName -eq "workflow_dispatch") -and ([string]::IsNullOrWhiteSpace($IssueNumber))) {
    Write-Host "'IssueNumber' must be provided for the 'workflow_dispatch' event" -ForegroundColor Red
    Show-Usage
    Exit 0
}

#debug
if($eventName -eq "") {
    Write-Host "'eventName' must be provided" -ForegroundColor Red
    Show-Usage
    Exit 0
}
else {
    Write-Host "$eventName" -ForegroundColor Red
}
#debug

if (($eventName -ne "workflow_dispatch")) {
    $IssueNumber = $GitHubPayload.event.issue.number
}

#debug
if($IssueNumber -eq "") {
    Write-Host "'issuenumber' must be provided" -ForegroundColor Red
    Show-Usage
    Exit 0
}
else {
    Write-Host "$IssueNumber" -ForegroundColor Red
}
#debug

$accessToken = [string]::IsNullOrWhiteSpace($GitHubAccessToken) ? $env:GH_TOKEN : $GitHubAccessToken
if (($eventName -eq "workflow_dispatch") -and ([string]::IsNullOrWhiteSpace($accessToken))) {
    Write-Host "'GitHubAccessToken' must be provided through either environment variable or parameter" -ForegroundColor Red
    Show-Usage
    Exit 0
}

#debug
if($accessToken -eq $null) {
    Write-Host "accesstoken must be provided" -ForegroundColor Red
    Show-Usage
    Exit 0
}
else {
    Write-Host "$accessToken" -ForegroundColor Red
}
#debug

$body = ""
if ($eventName -eq "workflow_dispatch") {
    $GitHubPayload = $(gh api /repos/$($GitHubPayload.repository)/issues/$IssueNumber) | ConvertFrom-Json
    $body = $GitHubPayload.body -replace "'", "''"
} else {
    $body = $GitHubPayload.event.issue.body
}

#debug
if($body -eq "") {
    Write-Host "body must be provided" -ForegroundColor Red
    Show-Usage
    Exit 0
}
else {
    Write-Host "$body" -ForegroundColor Red
}
#debug

$segments = $body.Split("###", [System.StringSplitOptions]::RemoveEmptyEntries)

$body=$segments.Trim() -replace '\n',' ' -replace "'", "''"
$title = $segments[0].Trim() -replace '\n',' ' -replace "'", "''"
Write-Host "$title" -ForegroundColor Red
$githubID=$GitHubPayload.user.login.ToString()
Write-Host "$githubID" -ForegroundColor Red
$created_at= $GitHubPayload.created_at
Write-Host "$created_at" -ForegroundColor Red
$created_at = $created_at.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
$assignee=$GitHubPayload.assignee
Write-Host "$assignee" -ForegroundColor Red
Write-Host "$IssueNumber" -ForegroundColor Red

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
