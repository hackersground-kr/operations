param(
    [string]
    [Parameter(Mandatory=$true)]
    $dateSubmittedInput= "",

    [string]
    [Parameter(Mandatory=$true)]
    $dateDueInput="",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This checks the date/time that made issue from the event payload

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            [-dateSubmittedInput      <Issue create_at>] ``
            [-dateDueInput     <Challenge due_date>] ``

            [-Help]

    Options:
        -dateSubmittedInput :       User create_at.
        -dateDueInput :          Challenge due date.

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

if (([string]::IsNullOrWhiteSpace($dateSubmittedInput)) -or ([string]::IsNullOrWhiteSpace($dateDueInput))) {
    Write-Host "'you must write issue created at and challenge due date." -ForegroundColor Red
    Show-Usage
    Exit 0
}

$tz = [TimeZoneInfo]::FindSystemTimeZoneById("Asia/Seoul")

$dateSubmitted = [DateTimeOffset]::Parse($dateSubmittedInput)
$offset = $tz.GetUtcOffset($dateSubmitted)
$dateSubmitted = $dateSubmitted.ToOffset($offset)

$dateDue = [DateTimeOffset]::Parse($dateDueInput)
$isOverdue = "$($dateSubmitted -gt $dateDue)".ToLowerInvariant()

$dateSubmittedValue = $dateSubmitted.ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
$dateDueValue = $dateDue.ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")

$result = @{
    isOverdue=$isOverdue
    dateSubmittedValue=$dateSubmittedValue
    dateDueValue=$dateDueValue
}

Write-Output $($result | ConvertTo-Json -Depth 100)

Remove-Variable dateDue
Remove-Variable dateSubmitted
Remove-Variable offset
Remove-Variable tz
