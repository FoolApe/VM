### Description: To vMotion multiple VMs.


$user='username@vsphere.local' ### Your VC account that has privileges to vMotion/create jobs.
$passwd=cat /Path/to/your/password
$server='Your_VC_IP'

echo " "
echo "---------------"
echo "|Connecting VC|"
echo "---------------"
Connect-VIServer -Server $server -User $user -Password $passwd
echo " "

### Set-up cluster spec
$spec = New-Object VMware.Vim.VirtualMachineRelocateSpec
$cluster=Get-Cluster -Name Cluster_name ### Destnation cluster
$rp=Get-ResourcePool -Location (Get-Cluster -Name $cluster) ### Destnation resource-pool
$spec.Pool = $rp.ExtensionData.MoRef


$VMlist = "/Path/to/your/vmotion_list" ### Use VM hostname as content(source).
'------------------------------- Starting Move VM -------------------------------'
Foreach($a in get-content $VMlist)
{
	### Set-up VM spec
	$vm = Get-VM -Name $a
	#$vm_ds=Get-VM -Name $a |Get-Datastore |awk '{print $1}' |egrep "C1|C2"
	$vm_ds=Get-VM -Name $a |Get-Datastore -Name "DS_name" ### VM source volume
	$ds=Get-Datastore -Location (Get-Datacenter -Name DC_nmae) -Name $vm_ds
	$ds_chk=echo $ds |awk -F \_ '{print $1}'
	$spec.Datastore = $ds.ExtensionData.MoRef

	$esx=Get-VMHost -Name Host_name ### Destination host
    $spec.Host = $esx.ExtensionData.MoRef

	echo "*** $a ***"
	$vm.ExtensionData.RelocateVM($spec,"defaultPriority") ### vMotion job
	echo ""
}


Disconnect-VIServer -Server $server -Confirm:$false
echo "--------------"
echo "|Process done|"
echo "--------------"
echo " "
