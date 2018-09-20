# vsts-agent-setup

```
$pat = "<Personal access token for VSTS>"
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls";
iwr -useb https://raw.githubusercontent.com/guestlinelabs/vsts-agent-setup/master/setup-agent.ps1
.\setup-agent.ps1 -pat $pat
```
