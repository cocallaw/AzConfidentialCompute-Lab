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

# import content from json file and store in variable $content
$inFile = Get-Content -Path .\skr-policy.json -Raw -Encoding UTF8 | ConvertFrom-Json

# serialize json content in variable $content and store in variable $jsonstring
$jsonstring = ConvertTo-Json -InputObject $inFile

# convert $jsonstring to byte array and store in variable $jsonbytes
$jsonbytes = [System.Text.Encoding]::UTF8.GetBytes($jsonstring)

# convert $jsonbytes to base64 string and format for base64url
Invoke-Base64UrlEncode -Argument $jsonbytes