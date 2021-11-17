function Send-BapiSMS {
param(

    [Parameter(Mandatory=$true)]
    [ValidatePattern("^\+?[1-9]\d{5,14}$")]
    [String] $ToNumber,
    [Parameter(Mandatory=$true)]
    [String] $Message,
    [Parameter(Mandatory=$false)]
    [ValidatePattern("^\+?[1-9]\d{5,14}$")]
    [String] $FromNumber
)

    [BapiSession] $s = $BAPISession
    if (-not $s.ApiUrl) {
        Write-Warning "No API url"
        return
    }

    $body = @{
        "TargetNumber" = $ToNumber
        "SmsText" = $Message
    }

    if ($FromNumber) {
        $body.SourceNumber = $FromNumber
    }

    $url = "$($s.ApiUrl)/users/$($s.UserId)/communication/sms/"

    $postData = [System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))
    try {        
        $result = Invoke-RestMethod -Method Post -Uri $url -Body $postData -Headers $s.Headers -ContentType "application/json; charset=utf-8"
        Write-Verbose "result:`n$($result | ConvertTo-Json)"
    }
    catch {
        Write-Warning "Error while sendin SMS`n$_"
    }
}