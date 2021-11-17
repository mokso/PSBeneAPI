function Get-BapiCalls {
    Param(
        [Parameter(Mandatory=$false)]
        [string] $UserId,

        [Parameter(Mandatory=$false)]
        [datetime] $TimeFrom,

        [Parameter(Mandatory=$false)]
        [datetime] $TimeTo,

        [hashtable] $Fillters
    )

    [BapiSession] $s =  $BAPISession
    if (-not $s.ApiUrl) {
        Write-Warning "No API url"
        return
    }
    
    if (-not $UserId) {
        $UserId = $s.UserId
    }
    if (-not $TimeFrom) {
        $TimeFrom = (Get-Date).Date
    }

    if (-not $TimeTo) {
        $TimeTo = Get-Date
    }

    $url = "$($s.ApiUrl)/calls/?StartTime=$($TimeFrom.ToUniversalTime().ToString("yyyy-MM-dd+HH':'mm':'ss"))&EndTime=$($TimeTo.ToUniversalTime().ToString("yyyy-MM-dd+HH':'mm':'ss"))&UserIDs=$UserId"

    Write-Verbose "Invoking url [$url]"

    $response = Invoke-RestMethod -Uri $url -Method Get -Headers $s.Headers
    Write-Output $response
}