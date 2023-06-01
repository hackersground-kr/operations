# Get a random assignee from a list of assignees
Param(
    [string]
    [Parameter(Mandatory=$false)]
    $Assignees = "",

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

if ([String]::IsNullOrWhiteSpace($Assignees) -eq $true) {
    Write-Host "No assignees provided. Exiting..."
    Exit 0
}

# Split the assignees into an array
$assigneesCollection = $Assignees -split "[,`r`n]" | `
    Where-Object { [String]::IsNullOrWhiteSpace($_) -eq $false } | `
    ForEach-Object { $_.Trim() }

# Get a random number
$random = Get-Random -Minimum 0 -Maximum $assigneesCollection.Length

# Get the random assignee
$randomAssignee = $assigneesCollection[$random]

# Output the random assignee
Write-Output $randomAssignee
