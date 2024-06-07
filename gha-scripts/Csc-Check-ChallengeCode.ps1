# Check Challenge Code

param(
    [string]
    [Parameter(Mandatory=$false)]
    $eventtitle= "",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This checks the challenge code from the event payload

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

$code = $title.Contains("]") ? $title.Substring(0, $title.IndexOf(']')).Replace("[", "").Replace("]", "").Trim().ToLowerInvariant() : ""
$codeUpper = ($code -ne "") ? $code.ToUpperInvariant() : ""
$codes = @("az-900", "ai-900")
$isValidCode = ($code -ne "") ? $($codes.Contains($code)).ToString().ToLowerInvariant() : $false

$result = @{
    code=$code
    codeUpper=$codeUpper
    isValidCode=$isValidCode
}

Write-Output $($result | ConvertTo-Json -Depth 100)

Remove-Variable isValidCode
Remove-Variable codes
Remove-Variable codeUpper
Remove-Variable code

