# Windows PowerShell Customizado

# Aliases
Function Pss { # Invocar PS
	Start PowerShell;
}

# Customização
& { # Texto em geral
	If($Host.Name -eq "ConsoleHost") { # Customizado para PowerShell
		# Comando (1º palavra)
		Set-PSReadLineOption -colors @{ Command = "#FFFF00"}; # Amarelo
		
		# Texto comum
		Set-PSReadLineOption -colors @{ Default = "#FFFFFF"}; # Branco
		
		# Parametros de comandos (--texto)
		Set-PSReadLineOption -colors @{ Parameter = "#808080"}; # Cinza
		
		# Simbolo que indica comando de multiplas linhas (>>)
		Set-PSReadLineOption -colors @{ ContinuationPrompt = "#0094FF"}; # Azul
		
		# Texto entre aspas ("texto")
		Set-PSReadLineOption -colors @{ String = "#C45917"}; # Marrom
	}
}

# Prompt
$promptStart = "PS";
$promptEnd = ">";
$promptGit = "$";
Function Prompt { # Linha de prompt
	# UFT-8 para aceitar qualquer texto(Output de Invoke-Expression)
	[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding;
	
	# Caminho da pasta atual
	$currentFolderPath = Get-Location;
	# Nome da pasta atual
	$currentFolderName = ($currentFolderPath | Split-Path -Leaf);
	
	# Print prompt e titulo
	If($Host.Name -eq "ConsoleHost") { # Customizado para PowerShell
		# Nome da branch atual do Git
		$gitCommand = "git rev-parse --abbrev-ref HEAD";
		Invoke-Expression $gitCommand 2> $Null | Tee-Object -Variable gitBranchName | Out-Null;
		
		If($gitBranchName -And -Not $gitBranchName.StartsWith($gitCommand)) { # Com Git
			$gitBranchName_Print = ("(" + $gitBranchName + ")");
			
			# Caminho  da pasta raiz do Git
			$gitCommand = "git rev-parse --show-toplevel";
			Invoke-Expression $gitCommand 2> $Null | Tee-Object -Variable gitRootFolderPath | Out-Null;
			
			If($gitRootFolderPath -And -Not $gitRootFolderPath.StartsWith($gitCommand)) { # Git com pasta-raiz
				# Nome da pasta
				$gitRootFolderName = ($gitRootFolderPath | Split-Path -Leaf);
				# Caminho da pasta-pai da pasta-raiz do Git
				$indexOfGitRootFolderName = -1;
				Do { # Checar se a pasta tem .git(Se é )
					$indexOfGitRootFolderName = $currentFolderPath.ToString().IndexOf($gitRootFolderName, $indexOfGitRootFolderName + 1);
					$gitRootFolderParentPath_Print = $currentFolderPath.ToString().Substring(0, $indexOfGitRootFolderName);
					$gitFolder = (Join-Path -Path (Join-Path -Path $gitRootFolderParentPath_Print -ChildPath $gitRootFolderName) -ChildPath ".git");
				} Until((Test-Path $gitFolder) -Or ($indexOfGitRootFolderName -eq -1));
				If($indexOfGitRootFolderName -ne -1) { # Git com pasta-raiz(Com certeza)
					# Caminho da pasta atual em Git
					$gitCurrentFolderPath = $currentFolderPath.ToString().Substring($indexOfGitRootFolderName);
					
					# Titulo (Com Git e pasta-raiz)
					$Host.UI.RawUI.WindowTitle = ($gitRootFolderName + " " + $gitBranchName_Print + " - " + $currentFolderPath);
					# Prompt (Com Git e pasta-raiz)
					PrintGitFolder $gitRootFolderParentPath_Print $gitCurrentFolderPath $gitBranchName;
				} Else {
					# Titulo (Com Git e sem pasta-raiz)
					$Host.UI.RawUI.WindowTitle = ($currentFolderName + " " + $gitBranchName_Print + " - " + $currentFolderPath);
					# Prompt (Com Git e sem pasta-raiz)
					PrintGitFolder $currentFolderPath "" $gitBranchName;
				}
			} Else { # Git sem pasta-raiz
				# Titulo (Com Git e sem pasta-raiz)
				$Host.UI.RawUI.WindowTitle = ($currentFolderName + " " + $gitBranchName_Print + " - " + $currentFolderPath);
				# Prompt (Com Git e sem pasta-raiz)
				PrintGitFolder $currentFolderPath "" $gitBranchName;
			}
		} Else { # Sem Git
			# Titulo (Sem Git)
			$Host.ui.RawUI.WindowTitle = ($currentFolderName + " - " + $currentFolderPath);
			# Prompt (Sem Git)
			PrintCommonFolder $currentFolderPath;
		}
	} Else { # Padrão
		# Titulo (Padrão) é o padrão
		# Prompt (Padrão)
		PrintDefault $currentFolderPath;
	}
	Return " "
}
Function PrintGitFolder($currentFolderPath1, $currentFolderPath2, $gitBranchName) {
	$gitBranchName_Print = ("(" + $gitBranchName + ")");
	Write-Host $promptStart -NoNewline -ForegroundColor Blue;
	Write-Host " " -NoNewline;
	Write-Host $currentFolderPath1 -NoNewline -ForegroundColor Green;
	Write-Host $currentFolderPath2 -NoNewline -ForegroundColor Cyan;
	Write-Host $promptEnd -NoNewline -ForegroundColor Green;
	Write-Host " " -NoNewline
	Write-Host $gitBranchName_Print -ForegroundColor Cyan;
	Write-Host $promptGit -NoNewline -ForegroundColor Cyan;
}
Function PrintCommonFolder($currentFolderPath) {
	Write-Host $promptStart -NoNewline -ForegroundColor Blue;
	Write-Host " " -NoNewline;
	Write-Host $currentFolderPath -NoNewline -ForegroundColor Green;
	Write-Host $promptEnd -NoNewline -ForegroundColor Green;
}
Function PrintDefault($currentFolderPath) { # Prompt (Padrão)
	$prompt = ($promptStart + " " + $currentFolderPath + $promptEnd);
	Write-Host $prompt -NoNewline;
}
