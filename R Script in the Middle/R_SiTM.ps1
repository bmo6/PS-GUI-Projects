<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.128
	 Created on:   	9/6/2016 11:39 AM
	 Created by:   	Brent Oparowski
	 Organization: 	HSU
	 Filename:     	R_SitM.ps1
	 Version:		1.0.0.0
	===========================================================================
	.DESCRIPTION
		SitM executable used to preseve R packages on one's U: drive.
#>

function Initialization
{
	
	[pscustomobject]$global:errors = @()
	[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | out-null
	$global:useFolders = $true
	
	if (([environment]::GetEnvironmentVariable("R_LIBS_User", "User")))
	{
		
		[Environment]::SetEnvironmentVariable("R_LIBS_USER", "", "User")
		
	}
	
}



function TestFolders
{
	
	if (!(Test-Path -Path "U:\"))
	{
		$global:errors += [pscustomobject]@{
			LogName = "HSU"
			Source = "HSU GPO"
			EntryType = "Error"
			EventID = "1061"
			Message = "Missing U: Drive"
			
			
		}
		
		WriteEvents
	}
}


function CheckQuota
{
	
	$freeSpace = (Get-WmiObject -Namespace "ROOT\cimv2" -Query "SELECT FreeSpace FROM Win32_LogicalDisk WHERE DeviceID='U:'").FreeSpace
	
	if ($freeSpace -lt 104857600)
	{
		$global:useFolders = $false
		
		
		[System.Windows.Forms.MessageBox]::Show("There is less than 100 Megabytes available on your U: Drive. Please delete any unnecessary files and then relaunch 'R'.", "Warning")
		
		$global:errors += [pscustomobject]@{
			LogName = "HSU"
			Source = "HSU GPO"
			EntryType = "Error"
			EventID = "1062"
			Message = "U: Drive Quota Warning"
			
		}
		
	}
}



function CreateFolder
{
	if ($global:useFolders)
	{
		if (!(Test-Path -Path "U:\Rpackages"))
		{
			
			New-Item -ItemType directory -Path "U:\" -Name "Rpackages" | Out-Null
			
			$path = "U:\Rpackages"
			$acl = (Get-Item $path).GetAccessControl('Access')
			$inheritance = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
			$propagation = [System.Security.AccessControl.PropagationFlags]::"None"
			$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$env:USERNAME", "FullControl", $inheritance, $propagation, "Allow")
			$acl.SetAccessRule($rule)
			
		}
	}
}


function CreateEnviroVariable
{
	
	if ($global:useFolders)
	{
		[Environment]::SetEnvironmentVariable("R_LIBS_USER", "U:\Rpackages", "User")
		$env:R_LIBS_USER = "U:\Rpackages"
	}
	
	$installLocation = (get-childitem -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach-object { get-itemproperty $_.pspath } | Where-Object { $_.displayname -match "R for Windows" }).InstallLocation
	
	$arguments = "$installLocation$('bin\x64')"
	Start-Process -FilePath "$arguments\Rgui.exe"
	
}


function WriteEvents
{
	
	foreach ($errorMsg in $global:errors)
	{
		
		Write-EventLog –LogName $errorMsg.LogName -source $errorMsg.Source –EntryType $errorMsg.EntryType –EventID $errorMsg.EventID –Message $errorMsg.Message
		
	}
	
	EXIT
}


try
{
	# Main Program Execution
	Initialization
	TestFolders
	CheckQuota
	CreateFolder
	CreateEnviroVariable
	WriteEvents
}
catch
{
	foreach ($errorMSG in $global:errors)
	{
		
		$errorDescription = $errorMsg.ToString() + $errorMsg.InvocationInfo.PositionMessage
		
		Write-EventLog –LogName HSU -source "HSU GPO" –EntryType Error –EventID 2000 –Message $errorDescription
	}
	
	
}