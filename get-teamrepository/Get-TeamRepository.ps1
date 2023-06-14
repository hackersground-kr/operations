# Get the the team repository name from the given text
Param(
    [string]
    [Parameter(Mandatory=$false)]
    $Text = "",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This returns the team repository name from the given text

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            [-Text <Text to search>] ``

            [-Help]

    Options:
        -Text:  Text to search the team repository name

        -Help:  Show this message.
"

    Exit 0
}

# Show usage
$needHelp = $Help -eq $true
if ($needHelp -eq $true) {
    Show-Usage
    Exit 0
}

if ([String]::IsNullOrWhiteSpace($Text) -eq $true) {
    Show-Usage
    Exit 0
}

# Get the team repository name using regular expression
$result = (($Text | `
    Select-String -Pattern "https:\/\/github\.com\/hackersground-kr\/[a-zA-Z0-9\-]+\/?" -AllMatches | `
    Select-Object -ExpandProperty Matches | `
    Select-Object -ExpandProperty Value) -replace "https://github.com/hackersground-kr/", "") -replace "/", ""

# Output the team repository name
Write-Output $result
