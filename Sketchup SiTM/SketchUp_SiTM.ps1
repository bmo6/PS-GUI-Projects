<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.95
	 Created on:   	10/14/2015 2:54 PM
	 Created by:   	bmo6
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
if (!(Test-Path -path "C:\ProgramData\SketchUp\SketchUp 2015\liclog.txt"))
{
	
	$registered = $false
	
	Start-Process -FilePath "C:\Program Files\SketchUp\SketchUp 2015\SketchUp.exe" -WindowStyle Hidden
	$processObject = get-process | select * | where { $_.processname -match "sketchUp.exe" }
	
	Do
	{
		
		if (select-string -Pattern "Has roam license" -path "C:\ProgramData\SketchUp\SketchUp 2015\liclog.txt")
		{
			
			$processObject | stop-process
			$registered = $true
		}
		start-sleep -seconds 2
		
	}
	until ($registered -eq $true)
	
	Start-Process -FilePath "C:\Program Files\SketchUp\SketchUp 2015\SketchUp.exe"
}
else
{
	
	Start-Process -FilePath "C:\Program Files\SketchUp\SketchUp 2015\SketchUp.exe"
}