<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.82
	 Created on:   	7/31/2015 2:10 PM
	 Created by:   	bmo6
	 Organization: 	HSU
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
$ErrorActionPreference = 'SilentlyContinue'

$consoleKey = "HKCU:\Software\Microsoft\Microsoft Operations Manager\3.0\Console\ConnectionHistory"
$consoleKey1 = "HKCU:\Software\Microsoft\Microsoft Operations Manager\3.0\Console\ConnectionHistory\HSUSCOMMS1.AD.HUMBOLDT.EDU"
$consoleKey2 = "HKCU:\Software\Microsoft\Microsoft Operations Manager\3.0\Console\ConnectionHistory\HSUSCOMMS2.AD.HUMBOLDT.EDU"
$consoleConnection = "HKCU:\Software\Microsoft\Microsoft Operations Manager\3.0\User Settings"

if (!(Test-Path $consoleKey1))
{
	
	New-Item -path $consoleKey -Name "HSUSCOMMS1.AD.HUMBOLDT.EDU" -Force | out-null
	New-ItemProperty -Path $consoleKey1 -PropertyType string -Name ManagementGroupName -Value HUMBOLDT -Force | out-null
	New-ItemProperty -Path $consoleKey1 -PropertyType DWORD -Name ConnectionTime -Value 0 -Force | out-null
}

if (!(Test-Path $consoleKey2))
{
	
	New-Item -path $consoleKey -Name "HSUSCOMMS2.AD.HUMBOLDT.EDU" -Force | out-null
	New-ItemProperty -Path $consoleKey2 -PropertyType string -Name ManagementGroupName -Value HUMBOLDT -Force | out-null
	New-ItemProperty -Path $consoleKey2 -PropertyType DWORD -Name ConnectionTime -Value 0 -Force | out-null
}

Set-ItemProperty -Path $consoleKey1 -Name ConnectionTime -Value 0 -force | out-null
Set-ItemProperty -Path $consoleKey2 -Name ConnectionTime -Value 0 -force | out-null

$randomMS = Get-Random -input "HSUSCOMMS1.AD.HUMBOLDT.EDU", "HSUSCOMMS2.AD.HUMBOLDT.EDU"

Set-ItemProperty -Path $consoleConnection -Name SDKServiceMachine -Value $randomMS -Force

Start-Process "C:\Program Files\System Center Operations Manager 2012\Console\Microsoft.EnterpriseManagement.Monitoring.Console.exe"
