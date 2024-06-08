# Check issue date time

param(
    [string]
    [Parameter(Mandatory=$false)]
    $dateInput= "",

    [string]
    [Parameter(Mandatory=$false)]
    $dateDueInput="",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This checks the date/time that made issue from the event payload

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            [-dataSubmittedInput      <Issue create_at>] ``
            [-dateDueInput     <Challenge due_date>] ``

            [-Help]

    Options:
        -dataSubmittedInput :       User create_at.
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

if (([string]::IsNullOrWhiteSpace($dateInput)) -or ([string]::IsNullOrWhiteSpace($dateDueInput))) {
    Write-Host "'you must write issue created at and challenge due date." -ForegroundColor Red
    Show-Usage
    Exit 0
}

$tz = [TimeZoneInfo]::FindSystemTimeZoneById("Asia/Seoul")

$dateSubmitted = [DateTimeOffset]::Parse("$(dateInput)")
$offset = $tz.GetUtcOffset($dateSubmitted)
$dateSubmitted = $dateSubmitted.ToOffset($offset)

$dateDue = $([DateTimeOffset]::Parse("$(dateDueInput)"))
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

