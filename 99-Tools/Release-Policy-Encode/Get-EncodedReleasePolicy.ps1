function Invoke-Base64UrlEncode {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [byte[]] $Argument
    )

    $output = [System.Convert]::ToBase64String($Argument)
    $output = $output.Split('=')[0]
    $output = $output.Replace('+', '–')
    $output = $output.Replace('/', '_')
    Write-Output $output
}

$inFile = Get-Content -Path .\skr-policy.json -Raw -Encoding UTF8 | ConvertFrom-Json
$jsonbytes = [System.Text.Encoding]::UTF8.GetBytes(($inFile | ConvertTo-Json -Depth 4)) 
Invoke-Base64UrlEncode -Argument $jsonbytes