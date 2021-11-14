function Connect-BAPISession {
    [CmdLetBinding()]
    param(        
        #API user credentials. Passowrd is user password
        [pscredential]$UserCredential,
        #API secretkey credentials. Passwor is SecretKey
        [pscredential]$APICredential,
        #API Url. If given, discovery will not be done
        [uri] $ApiUrl
    )

    #Figure out api username
    $BAPISession.UserName = if ($UserCredential) { 
        $UserCredential.UserName 
    }
    elseif ($APICredential) {
        $APICredential.UserName            
    }
    else {
        $env:BENEAPI_USERNAME
    }

    #should do discovery or not?
    if ($APIUrl) {
       Write-Verbose "using [$ApiUrl] not doing discovery"
        $BAPISession.ApiUrl = $ApiUrl
    }
    else {
        Get-BAPIUrl
    }

    #Should do userauth?
    if ($UserCredential) {
        Invoke-BAPIAuthentication $UserCredential -Type UserPassword
    }
    if ($APICredential) {
        Invoke-BAPIAuthentication $APICredential -Type SecretKey
    }
}