#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------
$global:serverStatus
$global:currentDirectory
$global:mainMessage = @()
$global:endScript = $false
$global:externalDrive



#Sample function that provides the location of the script
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($hostinvocation -ne $null)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}

#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-ScriptDirectory

function Check-Lock($location)
{
	
	
	
	switch ($location)
	{
		
		
		firstDirectory {
			
			$result = Invoke-Command -ComputerName "CoralSea-Server" {
				
				
				$fileStatus = (get-childitem "C:\SCS*\Datalog40" -Recurse).FullName
				
				foreach ($file in $fileStatus)
				{
					
					try
					{
						$temp = (Get-ItemProperty $file).lastwritetime
						(Get-ItemProperty $file).lastwritetime = $temp
						$file = $null
					}
					catch
					{
						BREAK
					}
					
				}
				
				Return $file
			}
			
			
			if ($result)
			{
				$output = [System.Windows.Forms.MessageBox]::Show("Folder/File is Write Protected. `n `n $result `n `n Press `'OK`' to Cancel Backup", "Backup Check", 0)
			}
			
			switch ($output)
			{
				OK {
					
					$global:endScript = $True
					 }
			
			}
			
		}
		
		secondDirectory {
			
			$result = Invoke-Command -ComputerName "CoralSea-lab02W" {
				
				
				$fileStatus = (get-childitem "D:\TRDI Data" -Recurse).FullName
				
				foreach ($file in $fileStatus)
				{
					
					try
					{
						$temp = (Get-ItemProperty $file).lastwritetime
						(Get-ItemProperty $file).lastwritetime = $temp
						$file = $null
					}
					catch
					{
						BREAK
					}
					
				}
				
				Return $file
			}
			
			
			if ($result)
			{
				$output = [System.Windows.Forms.MessageBox]::Show("Folder/File is Write Protected. `n `n $result `n `n Press `'OK`' to Cancel Backup", "Backup Check", 0)
			}
			
			switch ($output)
			{
				OK {
					
					$global:endScript = $True
				}
				
			}
			
		}
		thirdDirectory {
				
				$result = Invoke-Command -ComputerName "Coralsea-lab03W" {
					
					
					$fileStatus = (get-childitem "C:\CTD_DATA" -Recurse).FullName
					
					foreach ($file in $fileStatus)
					{
						
						try
						{
							$temp = (Get-ItemProperty $file).lastwritetime
							(Get-ItemProperty $file).lastwritetime = $temp
							$file = $null
						}
						catch
						{
							BREAK
						}
						
					}
					
					Return $file
				}
				
				
				if ($result)
				{
					$output = [System.Windows.Forms.MessageBox]::Show("Folder/File is Write Protected. `n `n $result `n `n Press `'OK`' to Cancel Backup", "Backup Check", 0)
				}
				
				switch ($output)
				{
					OK {
						
						$global:endScript = $True
					}
					
				}
		}
		
		Thumb
		{
			try
			{
				$temp = (Get-ItemProperty "$($global:ExternalDrive):\CoralSea Backup").lastwritetime
				(Get-ItemProperty "$($global:ExternalDrive):\CoralSea Backup").lastwritetime = $temp
				$temp = $null
			}
			catch
			{
				[System.Windows.Forms.MessageBox]::Show("Please Close the `"CoralSea Backup`" Folder on the $($global:ExternalDrive) Drive. `n `n Press `'OK`' to Cancel Backup", "Backup Check", 0)
				$global:endScript = $True
				BREAK
			}
			Return 
		}
	}
	
	
}



