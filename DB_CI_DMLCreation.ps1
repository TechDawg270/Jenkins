<#
# Author - Dane Butler
# Purpose - Create a DML object creation script from Red Gate SQL Source Control
            directory structure
            Split the DDL and DML as a workaround for a few cross DB dependencies
            that need to eventually be phased out
#>
Param( $gitRevision, $workingDirectory )

# Get DB version directory.. Pattern matching used because all DB's will not have the same version number
$versionDirectory = Get-ChildItem -Path $workingDirectory -Directory | Where-Object {$_.Name -match "v[1-9].[0-9]"};

# Setup output file name and location
$outFile = "$workingDirectory\$versionDirectory\02_create_dml_" + "$gitRevision.sql";

Write-Host "Git Revision - $gitRevision, Working Directory - $workingDirectory, Output File - $outFile";

# Red Gate SQL Source DML directories
$targetDirectories = ("Functions", "Views", "Stored Procedures");

foreach($dir in $targetDirectories)
{
    # check to see if path exists before execution to avoid run-time errors for edge cases
    if(Test-Path -Path "$workingDirectory\$dir")
    {
        # grab all .sql files
        $dml += @(Get-ChildItem -Path "$workingDirectory\$dir\*" -Include '*.sql' | % {$_.FullName});
    }
}

if($dml)
{
    Get-Content $dml -Encoding UTF8 | Out-File $outFile UTF8;
}
