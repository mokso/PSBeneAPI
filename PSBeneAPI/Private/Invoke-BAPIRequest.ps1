function Invoke-BAPIRequest {
    param(
        [String] $Endpoint,
        [ValidateSet("Get","Post","Put","Delete","Patch")]
        [String] $Method = "Get",
        [HashTable] $Parameters,
        [string] $Body
    )

    if (-not $BAPISession.ApiUrl) {
        Write-Verbose "ApiUrl not set"
        return
    }

    



}