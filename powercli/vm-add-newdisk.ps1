### Made by SYS-Juro
### First version : 2021/12/23
### Description   : VM新增硬碟

$user='USER@DOMAIN'
$passwd=cat /PATH/TO/YOUR/PASS
$server="VC_IP"
$list='/PATH/TO/YOUR_LIST'

echo " "
echo "--------------------"
echo "|Connecting Vcenter|"
echo "--------------------"
Connect-VIserver -Server $server -User $user -Password $passwd |Out-Null
echo ""
echo "$server 已登入"
echo " "

### 執行新增硬碟

echo "=== 開始執行新增硬碟 ==="

foreach($vms in gc $list)
{
    echo "$vms"
    Get-VM -Name $vms | New-HardDisk -CapacityGB 500 -Persistence Persistent -StorageFormat Thin | format-table -autosize
    echo " "
}

echo "=== 新增完成 ==="

Disconnect-VIServer -Server $server -Confirm:$false
echo "--------------"
echo "|Process done|"
echo "--------------"
echo " "
