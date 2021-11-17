function Get-BapiCallRecording {
    Param(
            #UserId of user, whose availability should be set. If not give, user username of credentials object
            [Parameter(Mandatory=$true)]
            [String] $RecordingId,
    
            [Parameter(Mandatory=$false)]
            [String] $Path
    )

    [BapiSession] $s = $BAPISession
    if (-not $s.ApiUrl) {
        Write-Warning "No API url"
        return
    }
    $url = "$($s.ApiUrl)/calls/recordings/$RecordingId"
    $recinfo = Invoke-RestMethod -Uri $url -Method Get -Headers $s.Headers
    Write-Verbose "recinfo:`n$($recinfo | Convertto-json)"
    
    $targetFile = "$RecordingId.mp3"
    if ($Path) {
        $targetFile = Join-Path $Path "$RecordingId.mp3"
    }
    if ($recinfo.URL -like "*?token=*") {
        #Save file to target path
        Write-Verbose "Saving recording to file [$targetFile]"
        $headers = @{
            Authorization = $s.Headers["Authorization"]
        }
        Invoke-WebRequest -Method Get -Uri "$($s.ApiUrl)/$($recinfo.URL)" -Headers $headers -OutFile $targetFile -Verbose
    }

}