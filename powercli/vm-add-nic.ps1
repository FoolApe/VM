### Made by	: SYS-Jarry
### Description : Add nic to VM


Get-Module -ListAvailable PowerCLI* | Import-Module
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
$user='USER@DOMAIN'
$passwd=cat /PATH/TO/YOUR/PASS
$list=/PATH/TO/YOUR/LIST

### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
### @@@ Remember to edit here @@@
### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@

$server='VC_IP'
$portgroup="PortgroupName"

### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
### @@@ Remember to edit here @@@
### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@


echo " "
echo "---------------"
echo "|Connecting VC|"
echo "---------------"
Connect-VIServer -Server $server -User $user -Password $passwd
echo " "

$directPath = $false
foreach($vm in get-content $list)
{
	echo "@@@ $vm @@@"
	echo " "
	New-NetworkAdapter -VM $vm -Type Vmxnet3 -NetworkName $portgroup -WakeOnLan:$true -StartConnected:$true -Confirm:$false
}


Disconnect-VIServer -Server $server -Confirm:$false
echo "--------------"
echo "|Process done|"
echo "--------------"
echo " "

