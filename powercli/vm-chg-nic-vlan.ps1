### Made by		: SI-Kane
### Description : Change VM nic portgroup 


Get-Module -ListAvailable PowerCLI* | Import-Module
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
$user='USER@DOMAIN'
$passwd=cat /PATH/TO/YOURPASS


### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
### @@@ Remember to edit here @@@
### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@

$server='VC_IP'
$portgroup1="PORTGROUP1"
$portgroup2="PORTGROUP2"
$portgroup3="PORTGROUP3"

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
foreach($vm in get-content "/PATH/TO/YOUR/LIST")
{
	echo "@@@ $vm @@@"
	echo " "
	$NIC1 = Get-NetworkAdapter -VM $vm | Where-Object {$_.Name -match "Network adapter 1"}
	$NIC2 = Get-NetworkAdapter -VM $vm | Where-Object {$_.Name -match "Network adapter 2"}
	$NIC3 = Get-NetworkAdapter -VM $vm | Where-Object {$_.Name -match "Network adapter 4"}

    Set-NetworkAdapter -NetworkAdapter $NIC1 -NetworkName $portgroup2 -Confirm:$false
    Set-NetworkAdapter -NetworkAdapter $NIC2 -NetworkName $portgroup3 -Confirm:$false
    Set-NetworkAdapter -NetworkAdapter $NIC3 -NetworkName $portgroup1 -Confirm:$false

}



Disconnect-VIServer -Server $server -Confirm:$false
echo "--------------"
echo "|Process done|"
echo "--------------"
echo " "

