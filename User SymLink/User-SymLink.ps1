<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.143
	 Created on:   	8/25/2017 2:25 PM
	 Created by:   	 
	 Organization: 	 
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

param ($user)

	
	new-item -ItemType SymbolicLink -Name $user -Target C:\users\$user\Desktop -Path C:\ -Force
	
	
	
	
	
