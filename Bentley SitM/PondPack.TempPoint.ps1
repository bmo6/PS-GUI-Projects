<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.82
	 Created on:   	7/27/2015 1:43 PM
	 Created by:   	bmo6
	 Organization: 	HSU
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>


$arguments = "checkout /productid:1233 /productfeatures:`"acad=no | mstn=yes | pond=unlimited`" /productversion:8.11.01.56 /checkoutperiod:1"
Start-Process $(${env:ProgramFiles(x86)})\Bentley\PondPack8\licensetoolcmd.exe -ArgumentList $arguments -Wait