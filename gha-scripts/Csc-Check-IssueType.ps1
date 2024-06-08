# Check issue type

param(
    [string]
    [Parameter(Mandatory=$false)]
    $eventtitle= "",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This checks the issue type from the event payload

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            [-eventtitle      <Issue event title>] ``

            [-Help]

    Options:
        -eventtitle:       Issue event title.

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

if (([string]::IsNullOrWhiteSpace($eventtitle))) {
    Write-Host "'you must write issue event title." -ForegroundColor Red
    Show-Usage
    Exit 0
}

$isCsc = $eventtitle.Contains("챌린지 코드") 
$isTeamTopic = $eventtitle.Contains("해커톤 주제 제출") #api body 다시 확인
$isTeamApp = $eventtitle.Contains("해커톤 앱 제출") #api body 다시 확인
$isTeamPitch = $eventtitle.Contains("해커톤 발표자료 제출") #api body 다시 확인

$result = @{
    isCsc=$isCsc
    isTeamTopic=$isTeamTopic
    isTeamApp=$isTeamApp
    isTeamPitch=$isTeamPitch
}

Write-Output $($result | ConvertTo-Json -Depth 100)

Remove-Variable isTeamPitch
Remove-Variable isTeamApp
Remove-Variable isTeamTopic
Remove-Variable isCsc

