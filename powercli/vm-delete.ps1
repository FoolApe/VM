### First version: 2022/12/02
### Create by: SI-SEP-Juro
### Description: To delete multiple VMs at once.

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!! THIS SCRIPT IS DANGEROUS AS FUCK !!!!
# !!!        PLEASE BE CAREFUL		   !!!!	
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


$user='username@vsphere.local' ### Your VC account that has privileges to delete/poweroff vms.
$passwd=cat /Path/to/your/password
$server='Your_vCenter_IP'


echo " "
echo "---------------"
echo "|Connecting VC|"
echo "---------------"
Connect-VIServer -Server $server -User $user -Password $passwd
echo " "

#$hostname = "/Path/to/your/VM/ip_list"
$log = '/Path/to/your/log'

' '
'------------------------------- Starting Shutdown VM -------------------------------'
echo "" >> $log
echo "===== SHUT =====" >> $log
Foreach($a in get-content $hostname)
{
	$name = echo $a |awk '{print $1}'
	$ip = echo $a |awk '{print $2}'
	
	### Check vm ip then power-off them.
	get-vm -name $name |where {$_.PowerState -match 'PoweredOn' -and  $_.guest.IPAddress[0] -eq "$ip"} |Stop-VM -Confirm:$False
	echo "$name,$ip 關機" >> $log 
}


### Wait for shutting down
Start-Sleep -Seconds 5

'------------------------------- Starting Delete VM -------------------------------'
echo "" >> $log
echo "===== DELE =====" >> $log
Foreach($b in get-content $hostname)
{
	$name = echo $b |awk '{print $1}'
    $ip = echo $b |awk '{print $2}'	

	### Delete VMs after they are power-off.
	get-vm -name $name |where {$_.PowerState -match 'PoweredOff'} |Remove-VM -Confirm:$False -DeletePermanently
	echo "$name,$ip 刪除" >> $log	
}
echo "======== DONE ========" >> $log
echo "" 
Disconnect-VIServer -Server $server -Confirm:$false
echo "--------------"
echo "|Process done|"
echo "--------------"
echo " "

