#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------

$global:greenPath = "C:\Program Files\HSU\Active-Wallpaper\green-rectangle-th.gif"
$global:yellowPath = "C:\Program Files\HSU\Active-Wallpaper\yellow-rectangle-lighter-th.gif"
$global:redPath = "C:\Program Files\HSU\Active-Wallpaper\red-rectangle-button-th.gif"

$global:dynamic_GPU_Name = (Get-Counter -ListSet * | where-object { $_.CounterSetName -match "NVIDIA" }).PathsWithInstances
$global:userProfile = $env:USERPROFILE

$global:totalRDSMEM = 22GB/1mb
$global:userProfile = $env:USERPROFILE



function Set-Location
{
	# Declares monitor object and finds primary monitor
	$monitors = [System.Windows.Forms.Screen]::AllScreens
	$primaryMonitor = $monitors | Where-Object { $_.Primary -eq $true }
	
	# App Height and Width
	
	#$form1.Size.Width = 50
	
	$appHeight = $form1.Size.Height
	$appWidth = $form1.Size.Width
	
	# Monitor's Height and Width
	$global:monitorWidth = $primaryMonitor.bounds.Width
	$global:monitorHeight = $primaryMonitor.bounds.Height
	
	# Gathers app location based off percentage of monitor resolution
	$appTop = $monitorHeight - $appHeight
	
	# Location on screen for form minus size of form and pixels
	$right = ($monitorWidth - $appWidth) - $appRight
	$bottom = ($monitorHeight - $appHeight) - $appTop
	
	# Declares Point object and passes app pixel location to constructor
	$global:appPoint = New-Object System.Drawing.Point -argumentList ($right, $bottom)
	
	# Sets app location
	$Form1.Location = $appPoint
	
	
}

function Update-Status
{
	
	$Label4.Text = $(query user).count - 1
	
	$CPULoad = [math]::Round(((Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples).CookedValue)
	
	
	if ($CPULoad -le 40)
	{
		
		$CPU_BUTTON.Image = [System.Drawing.Image]::FromFile($greenPath)
		
	}
	elseif (($CPULoad -gt 40) -and ($CPULoad -le 80))
	{
		
		$CPU_BUTTON.Image = [System.Drawing.Image]::FromFile($yellowPath)
		
	}
	else
	{
		$CPU_BUTTON.Image = [System.Drawing.Image]::FromFile($redPath)
	}
	
	
	
	$GPU_Usage = $(Get-Counter $global:dynamic_GPU_Name[10]).CounterSamples.CookedValue
	
	if ($GPU_Usage -le 40)
	{
		
		$GPU_BUTTON.Image = [System.Drawing.Image]::FromFile($global:greenPath)
	}
	elseif (($GPU_Usage -gt 40) -and ($GPU_Usage -le 80))
	{
		
		$GPU_BUTTON.Image = [System.Drawing.Image]::FromFile($global:yellowPath)
		
	}
	else
	{
		$GPU_BUTTON.Image = [System.Drawing.Image]::FromFile($global:redPath)
	}
	
	
	
	
	<#
	$UPD_Space = [math]::Round($(Get-Counter "\LogicalDisk($userProfile)\% Free Space").CounterSamples.CookedValue)
	
	if ($UPD_Space -le 10)
	{
		
		$DSK_BUTTON.Image = [System.Drawing.Image]::FromFile($redPath)
		
	}
	elseif (($UPD_SPACE -gt 10) -and ($UPD_SPACE -le 30))
	{
		
		$DSK_BUTTON.Image = [System.Drawing.Image]::FromFile($yellowPath)
		
	}
	else
	{
		$DSK_BUTTON.Image = [System.Drawing.Image]::FromFile($greenPath)
	}
	#>
	
	$UPD_Space = [math]::Round(((Get-Counter '\LogicalDisk(C:)\Avg. Disk Queue Length').CounterSamples).CookedValue)
	
	if ($UPD_Space -ge 3)
	{
		
		$DSK_BUTTON.Image = [System.Drawing.Image]::FromFile($redPath)
		
	}
	elseif ($UPD_SPACE -eq 2) 
	{
		
		$DSK_BUTTON.Image = [System.Drawing.Image]::FromFile($yellowPath)
		
	}
	else
	{
		$DSK_BUTTON.Image = [System.Drawing.Image]::FromFile($greenPath)
	}
	
	
	
	
	
	$ComputerSystem = Get-WmiObject -Class Win32_operatingsystem -Property FreePhysicalMemory, TotalVisibleMemorySize
	$FreeMEM = ([math]::Round(($ComputerSystem.FreePhysicalMemory) / (1mb))) * 1000
	$totalMEM = ([math]::Round(($ComputerSystem.TotalVisibleMemorySize) / (1mb))) * 1000
	
	$usedMEM = $totalMEM - $FreeMEM
	
	$totalFreeMEM = $totalRDSMEM - $usedMEM
	
	if ($totalFreeMEM -le 2000)
	{
		
		$MEM_BUTTON.Image = [System.Drawing.Image]::FromFile($redPath)
		
	}
	elseif (($totalFreeMEM -gt 2000) -and ($totalFreeMEM -le 6000))
	{
		
		$MEM_BUTTON.Image = [System.Drawing.Image]::FromFile($yellowPath)
		
	}
	else
	{
		$MEM_BUTTON.Image = [System.Drawing.Image]::FromFile($greenPath)
	}
	
	
}















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
	if ($null -ne $hostinvocation)
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


