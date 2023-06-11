# Sets a GitHub repository for a team and assign team members
Param(
    [string]
    [Parameter(Mandatory=$false)]
    $RepositoryName = "",

    [string]
    [Parameter(Mandatory=$false)]
    $TeamLeader = "",

    [string]
    [Parameter(Mandatory=$false)]
    $TeamMembers = "",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This create a team repository and assign team members

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            [-RepositoryName <GitHub repository name>] ``
            [-TeamLeader <GitHub ID for team leader>] ``
            [-TeamMembers <Comma-delimited GitHub IDs for team members>] ``

            [-Help]

    Options:
        -RepositoryName: The name of the GitHub repository to create
        -TeamLeader: a GitHub ID for the team leader
        -TeamMembers: A comma-delimited list of GitHub IDs for team members. Up to 3 members are supported.

        -Help:      Show this message.
"

    Exit 0
}

# Show usage
$needHelp = $Help -eq $true
if ($needHelp -eq $true) {
    Show-Usage
    Exit 0
}

if ([String]::IsNullOrWhiteSpace($RepositoryName) -eq $true) {
    Write-Host "Repository name is required.`r`n" -ForegroundColor Red
    Show-Usage
    Exit 0
}

if ([String]::IsNullOrWhiteSpace($TeamLeader) -eq $true) {
    Write-Host "Team leader is required.`r`n" -ForegroundColor Red
    Show-Usage
    Exit 0
}

if ([String]::IsNullOrWhiteSpace($TeamMembers) -eq $true) {
    Write-Host "Up to 3 team members are required.`r`n" -ForegroundColor Red
    Show-Usage
    Exit 0
}

$repository = (($RepositoryName.Trim() -replace ' ', '-') -replace '_', '-') -replace '[^a-zA-Z0-9\-]+', ''
$leader = $TeamLeader.Trim()
$members = $TeamMembers -split "[,]" | `
    Where-Object { [String]::IsNullOrWhiteSpace($_) -eq $false } | `
    ForEach-Object { $_.Trim() }
if ($members.Length -gt 3) {
    Write-Host "Up to 3 team members are required.`r`n" -ForegroundColor Red
    Show-Usage
    Exit 0
}

# Create a GitHub repository
gh repo create hackersground-kr/$repository --public --template hackersground-kr/team-template

# Add team leader
gh api -X PUT /repos/hackersground-kr/$repository/collaborators/$leader -f permission=maintain

# Add team members
foreach ($member in $members) {
    gh api -X PUT /repos/hackersground-kr/$repository/collaborators/$member -f permission=push
}
