# JenkinsScripts

## APP_CI_SET_INSTANCE_BUILDDATE_Git.ps1
Automated versioning for .NET web apps using Git tags and Jenkins build number
Git tag format - <major>.<minor>
Footer Display - <major>.<minor>.<jenkins_build_num> - Rev <git_short_rev_id>

## DB_CI* Scripts
Automated updating of SQL Server instance based on migration scripts (lookup data), and change scripts (DML or DDL type changes)

## Groovy Scripts
A simple but helpful script to clear and reset build numbers. Had some trouble with build numbers when doing a server migration using thinBackup, and this script alleviated that issue
