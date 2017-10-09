<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.82
	 Created on:   	6/30/2015 10:23 AM
	 Created by:   	bmo6
	 Organization: 	HSU
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>


Add-Type -AssemblyName System.Windows.Forms

$monitors = [System.Windows.Forms.Screen]::AllScreens

if ($monitors.count -eq 1)
{
	
	& DisplaySwitch.exe /extend
}
elseif ($monitors.count -ge 2)
{
	
	& DisplaySwitch.exe /clone
	
}
