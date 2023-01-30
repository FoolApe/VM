### Made by	: SYS-Jarry
### Description : VM delete nic


Get-Module -ListAvailable PowerCLI* | Import-Module
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
$user='USER@DOMAIN'
$passwd=cat /PATH/TO/YOUR/PASS
$list='/PATH/TO/YOUR/LIST'

### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
### @@@ Remember to edit here @@@
### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@

$server='VC_IP'

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
	$VM = Get-VM -Name $vm
	$spec = New-Object VMware.Vim.VirtualMachineConfigSpec 
	$spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec[] (1) 
	$spec.deviceChange[0] = New-Object VMware.Vim.VirtualDeviceConfigSpec 
	$spec.deviceChange[0].operation = "remove" 
	$spec.deviceChange[0].device = $VM.ExtensionData.Config.Hardware.Device | Where-Object {$_.DeviceInfo.Summary -eq "vLan18_172.18"}
	$VM.ExtensionData.ReconfigVM_Task($spec)
}


Disconnect-VIServer -Server $server -Confirm:$false
echo "--------------"
echo "|Process done|"
echo "--------------"
echo " "

