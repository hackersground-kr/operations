$tz = [TimeZoneInfo]::FindSystemTimeZoneById("Asia/Seoul")
$dateSubmitted = [DateTimeOffset]::Parse("${{ steps.issue.outputs.created_at }}")
$offset = $tz.GetUtcOffset($dateSubmitted)

$dateSubmitted = $dateSubmitted.ToOffset($offset)
$dateDue = $([DateTimeOffset]::Parse("${{ vars.CSC_DUE_DATE }}"))
$isOverdue = "$($dateSubmitted -gt $dateDue)".ToLowerInvariant()

$dateSubmittedValue = $dateSubmitted.ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
$dateDueValue = $dateDue.ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")

echo "dateSubmitted=$dateSubmittedValue" | Out-File -FilePath $env:GITHUB_OUTPUT -Encoding utf-8 -Append
echo "dateDue=$dateDueValue" | Out-File -FilePath $env:GITHUB_OUTPUT -Encoding utf-8 -Append
echo "isOverdue=$isOverdue" | Out-File -FilePath $env:GITHUB_OUTPUT -Encoding utf-8 -Append