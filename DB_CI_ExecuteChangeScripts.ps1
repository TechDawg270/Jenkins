<#
# Author - Dane Butler
# Purpose - Execute change scripts for a given DB for DB CI/CD
# Called By: Jenkins upon DB code check in
#>
Param( $gitRevision, $workingDirectory, $sqlServerInstance )

# Write output to host so it will be available in the "Console Output" in Jenkins
Write-Host "Git Revision - $gitRevision, Working Directory - $workingDirectory";

# Get DB version directory.. Pattern matching used because all DB's will not have the same version number
$versionDirectory = Get-ChildItem -Path $workingDirectory -Directory | Where-Object {$_.Name -match "v[1-9].[0-9]"};

# Set change script directory
$changeScriptDirectory = "$workingDirectory\$versionDirectory\ChangeScripts";
Write-Host "Change Script directory - $changeScriptDirectory";

# ensure directory exists before attempting to grab file list for execution to avoid run time error
if(Test-Path -Path $changeScriptDirectory)
{
	$changeScriptFiles = Get-ChildItem -Path $changeScriptDirectory | where {$_.extension -eq ".sql"} | % {$_.FullName };
}

<#
	Import the SQLPS module
	This can be made available on the CI/Jenkins server instance by installing
	SQL Server Express
#>
Push-Location
Import-Module SQLPS -DisableNameChecking
Pop-Location

# execute the SQL scripts with error handling for better build failure error messages
foreach($file in $changeScriptFiles)
{
    Write-Host "Executing change script file - $file";

    try
    {
	<#
		this needs to be altered if the account executing the call does not
		have Windows auth and login privileges on the SQL Server target instance
	#>
	Invoke-SqlCmd -ServerInstance $sqlServerInstance -Database "master" -InputFile $file;
    }
    catch
    {
        Write-Host $_.Exception.Message;
    }
 }
