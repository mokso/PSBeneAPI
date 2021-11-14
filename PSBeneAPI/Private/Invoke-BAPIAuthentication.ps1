function Invoke-BAPIAuthentication {
    param(
        [pscredential] $Credential,
        # Parameter help description
        [ValidateSet("UserPassword","SecretKey")]
        [string] $Type
    )

    if (-not $BAPISession.ApiUrl) {
        Write-Verbose "ApiUrl not set"
        return
    }

    switch ($Type) {
        "UserPassword" {              
            try {                
                $url = "$($BAPISession.ApiUrl)authuser/$($Credential.UserName)/"
                $body =  @{
                    UserName = $Credential.UserName
                    Password = $Credential.GetNetworkCredential().Password
                } | ConvertTo-Json
                Write-Verbose "Invoking $url"
                $auth = Invoke-RestMethod $url -Method Post -Body $body -ContentType "application/json"
                if ($auth) {
                    $secretKey = $auth.SecretKey
                }
                Write-Verbose ($auth | ConvertTo-Json)         
            }
            catch {
                Write-Warning "Error while authentication to API`n$_"        
            }
        }
        "SecretKey" {
            $secretKey = $Credential.GetNetworkCredential().Password
        }        
        Default {}
    }

    if ($secretKey) {
        $base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($UserCredential.UserName):$secretKey"))    
        Write-Verbose "Adding to headers [Basic $base64]" 
        $BAPISession.Headers["Authorization"] = "Basic $base64"
    }
    else {
        Write-Warning "API Authentication failed"
    }
}