# Check issue details

param(
    [string]
    [Parameter(Mandatory=$false)]
    $Issuenumber= "",

    [string]
    [Parameter(Mandatory=$false)]
    $GitHubPayload=$null,

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This checks the challenge code from the event payload

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            [-IssueNumber       <GitHub issue number>] ``
            [-GitHubPayload     <GitHub event payload>] ``

            [-Help]

    Options:
        -IssueNumber:       GitHub issue number. If the event is 'workflow_dispatch', it must be provided.
        -GitHubPayload:     GitHub event payload.

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

if($null -eq $GitHubPayload) {
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
    $IssueNumber = "${github.event.issue.number}"
}

$GitHubPayload = $(gh api /repos/$repository/issues/$issue_number | ConvertFrom-Json)

$body = ""
if ($eventName -eq "workflow_dispatch") {
    $body = $GitHubPayload.body
} else {
    $body = $GitHubPayload.event.issue.body
}

$title = $GitHubPayload.title
$created_at=$GitHubPayload.created_at.ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
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