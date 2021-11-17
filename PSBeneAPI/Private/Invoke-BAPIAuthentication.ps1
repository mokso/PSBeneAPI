function Invoke-BapiAuthentication {
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "Cred")]
        [pscredential] $Credential,

        # Parameter help description
        [Parameter(Mandatory = $true, ParameterSetName = "Cred")]
        [ValidateSet("UserPassword","SecretKey")]
        [string] $Type,

        [Parameter(Mandatory = $true, ParameterSetName = "Plain")]
        [string] $UserName,

        [Parameter(Mandatory = $true, ParameterSetName = "Plain")]
        [string] $SecretKey

    )

    if (-not $BAPISession.ApiUrl) {
        Write-Verbose "ApiUrl not set"
        return
    }

    if ($Credential){
        Write-Verbose "Authentication by credential"
        $UserName = $Credential.UserName
        switch ($Type) {
            "UserPassword" {              
                try {                
                    $url = "$($BAPISession.ApiUrl)/authuser/$($Credential.UserName)/"
                    $body =  @{
                        UserName = $Credential.UserName
                        Password = $Credential.GetNetworkCredential().Password
                    } | ConvertTo-Json
                    Write-Verbose "Invoking $url"
                    $auth = Invoke-RestMethod $url -Method Post -Body $body -ContentType "application/json"
                    if ($auth) {
                        $SecretKey = $auth.SecretKey
                        $BAPISession.UserId = $auth.UserId
    
                    }
                    Write-Verbose ($auth | ConvertTo-Json)         
                }
                catch {
                    Write-Warning "Error while authentication to API`n$_"        
                }
            }
            "SecretKey" {
                $SecretKey = $Credential.GetNetworkCredential().Password
            }        
            Default {}
        }
    }

    if ($SecretKey) {
        $base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$UserName`:$SecretKey"))    
        Write-Verbose "Adding to headers [Basic $base64]" 
        $BAPISession.Headers["Authorization"] = "Basic $base64"
    }
    else {
        Write-Warning "API Authentication failed"
        return
    }

    # try to get UserId if using secretkey auth
    if (-not $BAPISession.UserId) {
        Write-Verbose "Getting userid for [$UserName]"
        $user = Get-BapiUser -UserId "me"
        if ($user) {
            Write-Verbose "UserId [$($user.Id)]"
            $BAPISession.UserId = $user.Id
        }
    }
}