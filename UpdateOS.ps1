<#

.SYNOPSIS
Update automation for operating systems.

.DESCRIPTION
Operational system : Windows , Mac, Linux

Linux Package Managers : "apt", "dnf", "yum", "zypper", "pacman", "emerge", "slackpkg", "apk"

.EXAMPLE
PS> .\UpdateOS.ps1

#>

try {
	
	if ($IsLinux) {

		
		function UpdatePackage {
			param(
				[string]$PackageManagerParameters
			)
		
			Write-Host "Updating the list of available packages."
			& sudo $PackageManagerParameters update
		
			Write-Host "Updating the system by installing/updating packages."
			& sudo $PackageManagerParameters upgrade -y
		
			Write-Host "Updating the system by removing/installing/updating packages."
			& sudo $PackageManagerParameters full-upgrade -y
		}
		
		
		$ListOfPackageManagers = @("apt", "dnf", "yum", "zypper", "pacman", "emerge", "slackpkg", "apk")

		# Checks each package manager in the PATH environment variable
		foreach ($PackageManager in $ListOfPackageManagers) {

			$ExecutablePath = Get-Command $PackageManager -ErrorAction SilentlyContinue

			if ($ExecutablePath) {

				Write-Host "Package manager: $PackageManager, found at: $($ExecutablePath.Path)"

				UpdatePackage $PackageManager
				break
				
			}
		}

		if (-not $ExecutablePath) {
			Write-Host "No package manager found."
			exit 0
		}

	}
	elseif ($IsMacOS) {

		Write-Host "Installing updates."
		& sudo softwareupdate -i -a
		

	}
	elseif ($IsWindows) {

		Write-Host "Showing and running available updates."
		& winget upgrade --all --include-unknown
	}

 else {
	
		Write-Host "No recognized OS."
		exit 0
	
	}

	"Installed updates."
	exit 0 

}
catch {

	"Line error $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1

}