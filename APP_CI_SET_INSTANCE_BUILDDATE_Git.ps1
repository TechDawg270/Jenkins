<#
# Author: Dane Butler
# Purpose: Use Git tags to auto version .NET web apps
           Developers should be tagging the apps with a <major>.<minor> Git annotated tag
           The version info, or "Instance" in the web.config file, will be of the form:
           <major>.<minor>.<jenkins_build_num> - Rev <git_short_rev_id>

# Called By: Jenkins upon app code check in (only executed for a successful build.. no reason to version failures)
#>
PARAM([string]$workingDirectory, [string]$jobName, [string]$buildNumber)

# write parameters to host for easier debugging (output will show in the console output for each given job run)
Write-Host "Job Name - $jobName";
Write-Host "Working Directory - $workingDirectory";
Write-Host "Build Number - $buildNumber";

# grab the latest tag and write it to host for debugging purposes (output will show in the console output for each given job run)
$latestTaggedVersion = [string] (git describe --tags $(git rev-list --tags --max-count=1));
Write-Host "Tagged Version - $latestTaggedVersion";

# grab the latest revision and write to host for debugging purposes
$latestRevision = [string] (git log --pretty=format:'%h' -n 1);
Write-Host "Revision - $latestRevision";

# set the display string to use for Configuration.appSettings.Instance in Web.config
$instanceDisplay = "Version $latestTaggedVersion.$buildNumber - Rev $latestRevision";
Write-Host "Display Footer String - $instanceDisplay";

# set build date (example output - "06-09-2016 10:53")
$buildDate =  [string] (Get-Date -format "MM-dd-yyyy HH:mm");

# find Web.config file... use first occurrence searching down the directory structure from the top level
$xmlFilePath = Get-ChildItem -Path $workingDirectory -Name web.config -Recurse -Force | Select-Object -First 1;
Write-Host "Config file path - $xmlFilePath";

# read in the config file
$xml = [xml] (Get-Content $xmlFilePath);

# set the instance value which displays in the page footer
$instance = $xml.SelectSingleNode("//appSettings/add[@key='Instance']");
$instance.value = $instanceDisplay;

# set the build date value
$date = $xml.SelectSingleNode("//appSettings/add[@key='BuildDate']");
$date.value = $buildDate;

# save the file
$xml.Save($xmlFilePath);
