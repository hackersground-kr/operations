# Check issue details
param(
    [string]
    [Parameter(Mandatory = $false)]
    $IssueNumber = "",

    [psobject]
    [Parameter(Mandatory = $false)]
    $GitHubPayload = $null,

    [string]
    [Parameter(Mandatory = $false)]
    $GitHubAccessToken = "",

    [string]
    [Parameter(Mandatory = $false)]
    $DueDate = "",

    [switch]
    [Parameter(Mandatory = $false)]
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
    $title = $GitHubPayload.title
    $githubID = $GitHubPayload.user.login
    $createdAt = $GitHubPayload.created_at.ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
    $assignee = $GitHubPayload.assignee
} else {
    $IssueNumber = $GitHubPayload.event.issue.number
    $body = $GitHubPayload.event.issue.body

    $title = $GitHubPayload.event.issue.title
    $githubID = $GitHubPayload.event.issue.user.login
    $createdAt = $GitHubPayload.event.issue.created_at.ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
    $assignee = $GitHubPayload.event.issue.assignee
}

# "body": "### 제목\n\n클라우드 스킬 챌린지\n\n### 챌린지 코드\n\nAZ-900\n\n### 깃헙 프로필\n\nhttps://github.com/hackersground-kr\n\n### Microsoft Learn 프로필\n\nhttps://learn.microsoft.com/ko-kr/users/hackersground-kr",
# "body": "### 제목\n\n팀 주제 제출\n\n### 팀 이름\n\nmy awesome team\n\n### 팀 리포지토리\n\nhttps://github.com/hackersground-kr/my-awesome-team",
# "body": "### 제목\n\n팀 앱 제출\n\n### 팀 이름\n\nmy awesome team\n\n### 팀 리포지토리\n\nhttps://github.com/hackersground-kr/my-awesome-team",
# "body": "### 제목\n\n팀 발표자료 제출\n\n### 팀 이름\n\nmy awesome team\n\n### 팀 리포지토리\n\nhttps://github.com/hackersground-kr/my-awesome-team",
$sections = $body.Split("###", [System.StringSplitOptions]::RemoveEmptyEntries)

$segments = $sections[0].Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries)

$issue = @{}
$issue.Add("title", $segments[1].Trim())
$sections | ForEach-Object {
    $segments = $_.Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries)
    if ($issue.title -eq "클라우드 스킬 챌린지") {
        switch ($segments[0].Trim()) {
            "챌린지 코드" {
                $issue.Add("challengeCode", $segments[1].Trim())
            }
            "깃헙 프로필" {
                $issue.Add("githubProfile", $segments[1].Trim())
            }
            "Microsoft Learn 프로필" {
                $issue.Add("microsoftLearnProfile", $segments[1].Trim())
            }
        }
    } else {
        switch ($segments[0].Trim()) {
            "팀 이름" {
                $issue.Add("teamName", $segments[1].Trim())
            }
            "팀 리포지토리" {
                $issue.Add("teamRepository", $segments[1].Trim())
            }
        }
    }
}

$issueType = switch ($issue.title) {
    "클라우드 스킬 챌린지" { "CSC" }
    "팀 주제 제출" { "TOPIC" }
    "팀 앱 제출" { "APP" }
    "팀 발표자료 제출" { "PITCH" }
    default { $null }
}

$isValidGitHubID = $githubID -eq $issue.githubProfile.Split("/")[-1]
$isValidChallengeCode = $title.Contains($issue.challengeCode)
$isValidTeamName = $title.Contains($issue.teamName)

$tz = [TimeZoneInfo]::FindSystemTimeZoneById("Asia/Seoul")

$dateSubmitted = [DateTimeOffset]::Parse($createdAt)
$offset = $tz.GetUtcOffset($dateSubmitted)
$dateSubmitted = $dateSubmitted.ToOffset($offset)

$dateDue = [DateTimeOffset]::Parse($DueDate)
$isOverdue = "$($dateSubmitted -gt $dateDue)".ToLowerInvariant()

$dateSubmittedValue = $dateSubmitted.ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
$dateDueValue = $dateDue.ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")

$result = @{
    issueNumber = $IssueNumber;
    issueType = $issueType;
    createdAt = $createdAt;
    assignee = $assignee;
    title = $issue.title;
    challengeCode = $issue.challengeCode;
    isValidChallengeCode = $isValidChallengeCode;
    githubProfile = $issue.githubProfile;
    githubID = $githubID;
    isValidGitHubID = $isValidGitHubID;
    microsoftLearnProfile = $issue.microsoftLearnProfile;
    teamName = $issue.teamName;
    isValidTeamName = $isValidTeamName;
    teamRepository = $issue.teamRepository;
    dateSubmitted = $dateSubmittedValue;
    dateDue = $dateDueValue;
    isOverdue = $isOverdue;
}

Write-Output $($result | ConvertTo-Json -Depth 100)

Remove-Variable result
Remove-Variable isOverdue
Remove-Variable dateDue
Remove-Variable dateSubmitted
Remove-Variable offset
Remove-Variable tz
Remove-Variable isValidTeamName
Remove-Variable teamRepository
Remove-Variable teamName
Remove-Variable microsoftLearnProfile
Remove-Variable isValidGitHubID
Remove-Variable githubID
Remove-Variable githubProfile
Remove-Variable isValidChallengeCode
Remove-Variable challengeCode
Remove-Variable title
Remove-Variable assignee
Remove-Variable createdAt
Remove-Variable issueType
Remove-Variable issue
Remove-Variable segments
Remove-Variable sections
Remove-Variable body
Remove-Variable eventName
Remove-Variable accessToken
Remove-Variable IssueNumber
Remove-Variable GitHubPayload
Remove-Variable GitHubAccessToken
Remove-Variable DueDate
Remove-Variable Help
