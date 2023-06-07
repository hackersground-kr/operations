# Get the Microsoft Learn profile from the given text
Param(
    [string]
    [Parameter(Mandatory=$false)]
    $Text = "",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This returns the Microsoft Learn profile from the given text

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            [-Text <Text to search>] ``

            [-Help]

    Options:
        -Text:  Text to search the Microsoft Learn profile link

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

# Get the Microsoft Learn profile using regular expression
$result = $Text | `
    Select-String -Pattern "https:\/\/learn\.microsoft\.com\/[a-zA-Z]{2}-[a-zA-Z]{2}\/users\/[^\/]*\/?" -AllMatches | `
    Select-Object -ExpandProperty Matches | `
    Select-Object -ExpandProperty Value

# Output the Microsoft Learn profile
Write-Output $result
