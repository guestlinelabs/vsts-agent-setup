# vsts-agent-setup

```
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"; . { iwr -useb https://raw.githubusercontent.com/guestlinelabs/vsts-agent-setup/master/setup-agent.ps1 } | iex; setup-agent
```
