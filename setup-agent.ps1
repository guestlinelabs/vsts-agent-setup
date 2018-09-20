param([String]$pat)

# turn on TLS1.2
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

# Install Nuget
Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile nuget.exe
Copy-Item nuget.exe -Destination (New-Item $Env:ProgramFiles\nuget -Type container -Force) -Force
Remove-Item -Force nuget.exe
$env:Path += ";" + $Env:ProgramFiles + '\nuget'
[Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine )

# Install Web Plaform Installer (Wepicmd)
Invoke-WebRequest -Uri https://download.microsoft.com/download/C/F/F/CFF3A0B8-99D4-41A2-AE1A-496C08BEB904/WebPlatformInstaller_amd64_en-US.msi -OutFile WebPlatformInstaller_amd64_en-US.msi;
Start-Process WebPlatformInstaller_amd64_en-US.msi -ArgumentList '/quiet' -Wait ;
$env:Path += ";C:\Program Files\Microsoft\Web Platform Installer";
Remove-Item -Force WebPlatformInstaller_amd64_en-US.msi;
[Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine );

# Install Web Deploy
Start-Process 'C:\Program Files\Microsoft\Web Platform Installer\WebpiCmd.exe' -ArgumentList "/Install", "/Products:WDeploy36", "/AcceptEula" -Wait;

# Install silverlight 
Invoke-WebRequest http://download.microsoft.com/download/3/A/3/3A35179D-5C87-4D0A-91EB-BF5FEDC601A4/sdk/silverlight_sdk.exe -OutFile silverlight_sdk.exe;
Start-Process silverlight_sdk.exe -ArgumentList '/quiet', '/norestart' -Wait;

# Install Visual Studio Build Tools https://github.com/MicrosoftDocs/visualstudio-docs/blob/master/docs/install/workload-component-id-vs-build-tools.md
Invoke-WebRequest -Uri "https://download.visualstudio.microsoft.com/download/pr/10930955/e64d79b40219aea618ce2fe10ebd5f0d/vs_BuildTools.exe" -OutFile vs_BuildTools.exe;
Start-Process vs_BuildTools.exe -ArgumentList "--quiet", "--norestart", "--wait", "--add Microsoft.VisualStudio.Workload.AzureBuildTools", "--includeOptional" -Wait;
Start-Process vs_BuildTools.exe -ArgumentList "--quiet", "--norestart", "--wait", "--add Microsoft.VisualStudio.Workload.UniversalBuildTools", "--includeOptional" -Wait;

$env:Path += ";C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin\";
[Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine );

Remove-Item -Force vs_BuildTools.exe;

# setup vsts agentcon 
Invoke-WebRequest -Uri https://vstsagentpackage.azureedge.net/agent/2.140.0/vsts-agent-win-x64-2.140.0.zip -OutFile "$HOME\vsts-agent.zip"

mkdir c:\agent # deliberately here for access
cd c:\agent
Add-Type -AssemblyName System.IO.Compression.FileSystem 
[System.IO.Compression.ZipFile]::ExtractToDirectory("$HOME\vsts-agent.zip", "$pwd")

.\config.cmd --unattended --url https://guestlinelabs.visualstudio.com --auth pat --token $pat --pool default --agent (hostname) --acceptTeeEula  --runAsService
