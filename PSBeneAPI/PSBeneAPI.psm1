
$ScriptPath = $PSScriptRoot
$ModuleName = $ExecutionContext.SessionState.Module
Write-Verbose -Message "Loading module $ModuleName"

#load module variables
Write-Verbose -Message "Creating modules variables"
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$BAPISession = [ordered]@{
    ApiUrl      = $null
    UserName    = $null
    UserId      = $null
    CustomerId  = $null
    Headers     = @{}
}

#Dot source public and private function definition files, export publich functions
try {
    foreach ($Scope in 'Public','Private') {
        Get-ChildItem (Join-Path -Path $ScriptPath -ChildPath $Scope) -Filter *.ps1 | ForEach-Object {
            . $_.FullName
            if ($Scope -eq 'Public') {
                Export-ModuleMember -Function $_.BaseName -ErrorAction Stop
            }
        }
    }
}
catch {
    Write-Error ("{0}: {1}" -f $_.BaseName,$_.Exception.Message)
    exit 1
}