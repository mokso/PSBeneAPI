function Get-BapiUser {
    [CmdletBinding()]
    param (
        [String] $UserName,
        [String] $UserID
    )

    $url = "$($BAPISession.ApiUrl)/users/$UserId"
    $Users = Invoke-RestMethod $url -Method Get -Headers $BAPISession.Headers

    if ($UserName) {
        return $Users | Where-Object UserName -eq $UserName
    }

    return $Users

}