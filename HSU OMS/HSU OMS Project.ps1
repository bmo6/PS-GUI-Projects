<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.117
	 Created on:   	3/24/2016 4:29 PM
	 Created by:   	 
	 Organization: 	 
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>


$IE = New-Object -ComObject InternetExplorer.Application

Add-Type -AssemblyName System.Windows.Forms
$monitors = [System.Windows.Forms.Screen]::AllScreens


$IE.Navigate("https://login.live.com/login.srf?wa=wsignin1.0&wtrealm=urn%3afederation%3aMicrosoftOnline&wctx=estsredirect%3d2%26estsrequest%3drQIIAZ1RPW8UMRSUbyOkUBCEREFHcUkRyd6z1_sVlCLdRUikiFKi01vbe7E42yvbmwV-Rsr8hCsoUqH8BKqrKanoEDRQsgeiSof0NMXMk-bNvMOEEno0lQxmwGmFZwAC85xTXLGG4SajnImqllCW_snDxz-_uVcfDh_Nb_sXLzfq-80a5ZcxduEoTVUfyMottSXGBGK08C64NhLhTHrml6cyPddLe2oJhO7tR4Q2CH1FaD2ZzuqyYGXDMQAbvSvguBKjd5bzts3ZrC4E_TzZOzvp4yXbgvP6vfpyj_kx2W2dN4vOhXid7DnYqmSLwkl1nTx1nbJaCmetEpFoGd0bZW-S10OYaxuPMc2KvM5zVtPFvDeNW8mIzyNEhS-svlI-6PjuwKvYe3vhV8d_gu9nsM_acYZhuB985NfJ9F9DBiwslVF2q3lFBm2lGwKxKqa3yYNx3zh7l0wZlUVWZTWuqjbHvGQFhqyt8FgKBwpNQzl8Sp71QfmFNt14mLMQtbPP_ybc7KBfO-hu9_9e8xs1&id=&pcexp=&username=brianw1128%40yahoo.com&popupui=")
$IE.Visible = $true
$IE.Top = $true
$IE.Height = $monitors[0].workingarea.Height
$IE.Width = $monitors[0].workingarea.Width
$IE.Left = 0
$IE.Resizable = $true


while ($IE.Busy) { Start-Sleep -Milliseconds 500 }

($IE.document.getElementByID("i0118")).value = "BLAHBLAH"
($IE.document.getElementByID("idSIButton9")).Click()

while ($IE.Busy) { Start-Sleep -Milliseconds 1000 }
#start-sleep -Seconds 8

($IE.document.getElementByID("OverviewMyDashboardTile")).Click()
