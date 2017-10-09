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


$arguments = "checkout /productid:1244 /productfeatures:`"acad=yes|agis=yes|mstn=yes|pipe=2000`" /productversion:08.11.05.58 /checkoutperiod:1"
Start-Process "$(${env:ProgramFiles(x86)})\Bentley\SewerGEMS8\licensetoolcmd.exe" -ArgumentList $arguments -Wait

Start-Process "$(${env:ProgramFiles(x86)})\Bentley\SewerGEMS8\SewerGEMS.exe" 