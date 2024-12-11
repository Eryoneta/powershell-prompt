# Windows PowerShell

Customizes the default _PowerShell_ terminal prompt.

![Default terminal](./README/Exemplo%20-%20Default%20terminal.png)

Within a _Git_ repository, it also highlights the current branch, and the root directory.

![GitRepo terminal](./README/Exemplo%20-%20GitRepo%20terminal.png)

**Note**: Only the prompt is actually customized. The background color needs to be changed manually.

## Installation
Within a _PowerShell_ console, run:
```
    If(-Not (Test-Path $Profile)) {
    	New-Item -Path $Profile -Type File –Force;
    }
```
It checks for the file pointed by `$Profile`. If not found, it creates a new `Microsoft.PowerShell_profile.ps1` file.

Run `Echo $Profile` to find the location and then manually replace its contents.
