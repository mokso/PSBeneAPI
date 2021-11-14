function Get-BAPIUrl {
    Param(
        #Username to discover
        [String] $UserName
    )
    Write-Verbose "Discovering API url for user [$UserName]..."
    if (-not $UserName) {
        $UserName = $BAPISession.UserName
    }

    try {
        $DiscoveryUrl = "https://discover.beneservices.com/api/user/?user=$UserName"
        $DiscoResult = Invoke-RestMethod $DiscoveryUrl -Method GET
        if ($DiscoResult) {
            Write-Verbose "Discovery result: $($DiscoResult | ConvertTo-Json)"
            $BAPISession.ApiUrl = $DiscoResult.apiEndpoint
        }
    }
    Catch {
        Write-Warning "Discovery failed for user [$UserName]`n$_"
    }
}