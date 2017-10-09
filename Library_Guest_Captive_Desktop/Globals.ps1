#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------

$global:countDown = 7200
$global:minuteTrigger = 60
$global:pictureBox = $false
$global:killApp = $false
$global:singleError = $true
$global:valid = $true


$global:userName = $env:USERNAME
$global:serverInstance = "hsu-sqlcls01\mssql_2016"
$global:dataBase = "Library_Guest_Logoff"
$global:Table = "[dbo].[LIB_GUESTS]"

function Set-Location()
{
	# Declares monitor object and finds primary monitor
	$monitors = [System.Windows.Forms.Screen]::AllScreens
	$primaryMonitor = $monitors | Where-Object { $_.Primary -eq $true }
	
	# App Height and Width
	$appHeight = $mainForm.Size.Height
	$appWidth = $mainForm.Size.Width
	
	# Monitor's Height and Width
	$global:monitorWidth = $primaryMonitor.bounds.Width
	$global:monitorHeight = $primaryMonitor.bounds.Height
	
	# Gathers app location based off percentage of monitor resolution
	$appRight = $monitorWidth * .0075
	$appBottom = $monitorHeight * .05
	
	# Location on screen for form minus size of form and pixels
	$right = ($monitorWidth - $appWidth) - $appRight
	$bottom = ($monitorHeight - $appHeight) - $appBottom
	
	# Declares Point object and passes app pixel location to constructor
	$appPoint = New-Object System.Drawing.Point -argumentList ($right, $bottom)
	
	# Sets app location
	$MainForm.Location = $appPoint
	
}

function Make-DBConnection
{
	$global:job = Start-Job -Args $global:userName, $global:serverInstance, $global:dataBase, $global:Table -ScriptBlock {
		
		param ($global:userName,
			$global:serverInstance,
			$global:dataBase,
			$global:Table)
		
		$count = 0
		
		$global:conn = New-Object System.Data.SqlClient.SqlConnection
		$global:conn.ConnectionString = "Data Source=$global:serverInstance; Initial Catalog=$global:dataBase;"
		$Global:conn.Open() | Out-Null
		
		
		Do
		{
			
			if ($global:conn.State -eq "Closed")
			{
				
				$global:conn = New-Object System.Data.SqlClient.SqlConnection
				$global:conn.ConnectionString = "Data Source=$global:serverInstance; Initial Catalog=$global:dataBase;"
				$Global:conn.Open() | Out-Null
				
				$count++
				
				start-sleep -Seconds 1
				
			}
			else
			{
				
				$count = 4
				
			}
			
		}
		While ($count -le 3)
		
		
		#$global:conn = Receive-Job $job
		
		if ($global:conn.State -ne "OPEN")
		{
			$result = "linkdead"
			RETURN $result
		}
		
		$query = "SELECT Username, Valid, UserTime FROM [dbo].[LIB_GUESTS] WHERE username='$($global:userName)'"
		$Datatable = New-Object System.Data.DataTable
		
		
		
		$Command = New-Object System.Data.SQLClient.SQLCommand
		$Command.Connection = $global:conn
		$Command.CommandText = $query
		
		$Reader = $Command.ExecuteReader()
		$Datatable.Load($Reader)
		
		if ($Datatable.username)
		{
			if ($Datatable.Valid -match "True")
			{
				$conn.Close()
				RETURN $Datatable.UserTime
			}
			else
			{
				$global:conn.Close()
				$result = "Kill"
				Return $result
			}
			
			
			
		}
		else
		{
			
			$global:cmd = $global:conn.CreateCommand()
			
			$heartbeat = Get-Date
			
			$global:cmd.CommandText = "INSERT INTO $global:Table (UserName, UserTime, Valid, Workstation, heartbeat) VALUES (@UserName,@UserTime,@Valid,@Workstation,@Heartbeat)"
			
			$global:cmd.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@UserName", [Data.SQLDBType]::nvarchar, 10))) | Out-Null
			$global:cmd.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@UserTime", [Data.SQLDBType]::int))) | Out-Null
			$global:cmd.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Valid", [Data.SQLDBType]::bit))) | Out-Null
			$global:cmd.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Workstation", [Data.SQLDBType]::nvarchar, 15))) | Out-Null
			$global:cmd.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Heartbeat", [Data.SQLDBType]::time))) | Out-Null
			
			
			$global:cmd.Parameters[0].Value = $global:userName
			$global:cmd.Parameters[1].Value = 7200
			$global:cmd.Parameters[2].Value = 1
			$global:cmd.Parameters[3].Value = $env:COMPUTERNAME
			$global:cmd.Parameters[4].Value = '{0:HH:mm:ss}' -f $heartbeat
			
			#Execute Query
			$global:cmd.ExecuteNonQuery() | Out-Null
			
			$conn.Close()
			
			$returnValue = 7200
			return $returnValue
		}
		$global:timerTag2 = $global:job2
	}
	
	
	$global:timerTag = $global:job
	$global:timerStart = $true
	
	
}

function ForceLogoff()
{
	
		$arguments = "/l /f"
		Start-Process shutdown.exe -ArgumentList $arguments
		
}



function DetrimentMinute()
{
	$global:job2 = Start-Job -Args $global:userName, $global:serverInstance, $global:dataBase, $global:Table -ScriptBlock {
		
		param ($global:userName,
			$global:serverInstance,
			$global:dataBase,
			$global:Table)
		
		$count = 0
		
		$global:conn = New-Object System.Data.SqlClient.SqlConnection
		$global:conn.ConnectionString = "Data Source=$global:serverInstance; Initial Catalog=$global:dataBase;"
		$Global:conn.Open() | Out-Null
		
		
		
		Do
		{
			
			if ($global:conn.State -eq "Closed")
			{
				
				$global:conn = New-Object System.Data.SqlClient.SqlConnection
				$global:conn.ConnectionString = "Data Source=$global:serverInstance; Initial Catalog=$global:dataBase;"
				$Global:conn.Open() | Out-Null
				
				$count++
				
				start-sleep -Seconds 1
				
			}
			else
			{
				
				$count = 4
				
			}
			
		}
		While ($count -le 3)
		
		
		
		
		if ($global:conn.State -eq "Closed")
		{
			$result = "linkdead"
			
			RETURN $result
		}
		
		
		
		$query = "SELECT Username, Valid FROM [dbo].[LIB_GUESTS] WHERE username='$($global:userName)'"
		$Datatable = New-Object System.Data.DataTable
		
		
		
		$Command = New-Object System.Data.SQLClient.SQLCommand
		$Command.Connection = $global:conn
		$Command.CommandText = $query
		
		$Reader = $Command.ExecuteReader()
		$Datatable.Load($Reader)
		
		if ($Datatable.username)
		{
			$heartbeat = '{0:HH:mm:ss}' -f $(Get-Date)
			$workstation = $env:COMPUTERNAME
			
			$Command.CommandText = "UPDATE $global:Table SET UserTime = UserTime - 60, Workstation = '$($workstation)', Heartbeat = '$($heartbeat)' WHERE UserName='$global:userName'"
			$Command.ExecuteNonQuery()
			
			$conn.Close()
			
			return "good"
		}
		$conn.Close()
	}
	
	$global:timerTag2 = $global:job2
}


function Check-Resolution
{
	
	$monitors = [System.Windows.Forms.Screen]::AllScreens
	$primaryMonitor = $monitors | Where-Object { $_.Primary -eq $true }
	
	$width = $primaryMonitor.bounds.Width
	$height = $primaryMonitor.bounds.Height
	
	if (($width -ne $global:monitorWidth) -or ($height -ne $global:monitorHeight))
	{
		
		start-process D:\HSU\CIUTimeout\CIUTimeout.exe -passthru
		$global:killApp = $true
	}
	
}



function test-useraccount
{
	
	$libUsers = @()
	
	$Searcher = New-Object DirectoryServices.DirectorySearcher
	$Searcher.Filter = '(&(objectCategory=user))'
	$Searcher.SearchRoot = 'LDAP://OU=lib-guests-restricted,OU=users-lib,OU=grp-lib,OU=Managed-Groups,DC=AD,DC=HUMBOLDT,DC=EDU'
	$Searcher = $Searcher.FindAll()
	
	$Searcher = $Searcher.properties.name
	
	$libUsers += $Searcher
	
	$Searcher = New-Object DirectoryServices.DirectorySearcher
	$Searcher.Filter = '(&(objectCategory=user))'
	$Searcher.SearchRoot = 'LDAP://OU=lib-guests-open,OU=users-lib,OU=grp-lib,OU=Managed-Groups,DC=AD,DC=HUMBOLDT,DC=EDU'
	$Searcher = $Searcher.FindAll()
	
	$Searcher = $Searcher.properties.name
	
	$libUsers += $Searcher
	
	
	if ($libUsers -notcontains $global:userName)
	{
		$mainform.close()
		
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


