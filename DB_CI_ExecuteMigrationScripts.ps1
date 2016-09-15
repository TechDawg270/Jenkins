<#
# Author - Dane Butler
# Purpose - Execute migration scripts (lookup table inserts) for a given DB
						All scripts should be written in an idempotent manner
# Called By - Jenkins upon DB code check in
#>
Param( $gitRevision, $workingDirectory, $sqlServerInstance )

# Write output to host so it will be available in the "Console Output" in Jenkins
Write-Host "Git Revision - $gitRevision, Working Directory - $workingDirectory";

# Get DB version directory.. Pattern matching used because all DB's will not have the same version number
$versionDirectory = Get-ChildItem -Path $workingDirectory -Directory | Where-Object {$_.Name -match "v[1-9].[0-9]"};

# Set Migration Script directory
$migrationScriptDirectory = "$workingDirectory\$versionDirectory\MigrationScripts";
Write-Host "Migration Script directory - $migrationScriptDirectory";

if(Test-Path -Path $migrationScriptDirectory)
{
	$migrationScriptFiles = Get-ChildItem -Path $migrationScriptDirectory | where {$_.extension -eq ".sql"} | % {$_.FullName };
	if($file)
    {

		foreach($file in $migrationScriptFiles)
		{
			Write-Host "Executing Migration Script file - $file";

			try
			{
				Invoke-SqlCmd -ServerInstance $sqlServerInstance -Database "master" -InputFile $file;
			}
			catch
			{
				Write-Host $_.Exception.Message;
			}
		 }
	}
}
