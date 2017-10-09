<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.140
	 Created on:   	5/24/2017 1:30 PM
	 Created by:   	 
	 Organization: 	 
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

$arguments = "-Djava.security.policy=applet.policy -Xms512m -Xmx1024m -Djava.library.path=C:\Program Files\BlueSpray\STLibraries64 -jar BlueSpray.jar"
Start-Process $env:ProgramFiles\Java\Jre8\bin\java.exe -ArgumentList $arguments