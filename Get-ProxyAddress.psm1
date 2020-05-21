<#
.SYNOPSIS
 Get-ProxyAddress retrieves proxyaddresses for an AD User.
.DESCRIPTION
Get-ProxyAddress retrieves proxyaddresses for an AD User.
.PARAMETER User
 User is the AD User you are querying.
.PARAMETER Address
 Address is the type proxy addresses you are looking.
.PARAMETER DC
 FQDN of your domain controller
.Example
 Get-ProxyAddress  -User jdoe -Address all -DC DC1

 Finds all SMTP addresses for user jdoe
#>

function Get-ProxyAddress{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$True)]
        [string]$User,
        [Parameter(Mandatory=$True)]
        [string]$Address,
        [Parameter(Mandatory=$True)]
        [string]$DC
    )

    Enter-PSSession -ComputerName $DC

    $UserInfo = Invoke-Command -ComputerName $DC -ScriptBlock {Get-ADUser -Identity $Using:User -Properties proxyAddresses}

    if ($Address -like 'all'){
        $Addresses = $UserInfo.proxyaddresses -match 'SMTP:*' -replace '^smtp:'
        Write-Host "All the e-mail addresses for the user are:"
        $Addresses | Write-Host
    }

    elseif ($Address -like 'primary'){
        $Addresses = $UserInfo.proxyaddresses -cmatch 'SMTP:*' -replace '^SMTP:'
        Write-Host "The primary e-mail address for the user is:"
        $Addresses | Write-Host
    }

    elseif ($Address -like 'aliases'){
        $Addresses = $UserInfo.proxyaddresses -cmatch 'smtp:*' -replace '^smtp:'
        Write-Host "The e-mail address aliases for the user are:"
        $Addresses | Write-Host
    }

    else {
        Write-Host 'Invalid Address selection'
    }
    Exit-PSSession
    }