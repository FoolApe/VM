$user='hcl_system@vsphere.local'
$passwd=cat /home/sys-admin/scripts/nimaniuro
$server = "10.10.10.10" ### Change to your VC IP
$list = '/Path/To/YourList' ### VM list
$result = '/Path/To/YourOutput' ### output

### clear result
Clear-Content $result

echo " "
echo "--------------------"
echo "|Connecting Vcenter|"
echo "--------------------"
Connect-VIserver -Server $server -User $user -Password $passwd |Out-Null
echo ""
echo "$server 已登入"
echo " "
echo "=== 開始撈取 ==="

### 取得UUID
foreach ($a in gc $list)
{
    if ($a)
    {   
        $uuid=Get-VM -name $a | %{(Get-View $_.Id).config.uuid}
        echo "$a,$uuid" >> $result
    }
}

Disconnect-VIServer -Server $server -Confirm:$false
echo "==== DONE ===="   
