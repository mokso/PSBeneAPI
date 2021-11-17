function ValidateUri($address) {
	$uri = $address -as [System.URI]
	return (($null -ne $uri.AbsoluteURI ) -and ($uri.Scheme -in "http","https"))
}

function Connect-BapiSession {
    [CmdLetBinding()]
    param(        
        #API user credentials. Passowrd is user password
        [pscredential]$UserCredential,
        #API secretkey credentials. Passwor is SecretKey
        [pscredential]$APICredential,
        #API Url. If given, discovery will not be done
        [String] $ApiUrl
    )

    #Figure out api username
    $BAPISession.UserName = if ($UserCredential) { 
        $UserCredential.UserName 
    }
    elseif ($APICredential) {
        $APICredential.UserName            
    }
    else {
        #env variable BENEAPI_SECRETKEY
        if ($env:BENEAPI_USERNAME) {
            $env:BENEAPI_USERNAME
        }
        else {
            Write-Warning "Cannot figure out username!"
            return
        }
        
    }

    #should do discovery or not?
    if ($APIUrl) {
        if (ValidateUri($APIUrl)) {
            Write-Verbose "using [$ApiUrl] not doing discovery"
            $BAPISession.ApiUrl = $ApiUrl -replace "/$",""
        }
        else {
            Write-Warning "Not valid Url [$ApiUrl]"
        }
    }
    else {
        Get-BapiUrl
    }

    #Should do userauth?
    if ($UserCredential) {
        Invoke-BapiAuthentication -Credential $UserCredential -Type UserPassword
    }
    elseif ($APICredential) {
        Invoke-BapiAuthentication -Credential $APICredential -Type SecretKey
    }
    else {
        if (-not $env:BENEAPI_SECRETKEY) {
            Write-Warning "no secretkey"
            return
        }
        else {
            Invoke-BapiAuthentication -UserName $env:BENEAPI_USERNAME -SecretKey $env:BENEAPI_SECRETKEY
        }
        #env variable BENEAPI_SECRETKEY
    }
}