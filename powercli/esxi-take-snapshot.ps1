### Made by SYS-Juro
### First version : 2021/12/23
### Description : 建立快照

$user='USER@DOMAIN'
$passwd=cat /PATH/TO/YOUR/PASS
$server="VC_IP"
$list='/PATH/TO/YOUR/list'

echo " "
echo "--------------------"
echo "|Connecting Vcenter|"
echo "--------------------"
Connect-VIserver -Server $server -User $user -Password $passwd |Out-Null
echo ""
echo "$server 已登入"
echo " "

### 執行無記憶體快照

echo "=== 開始執行無記憶體快照 ==="

foreach($vms in gc $list)
{
    New-Snapshot -VM $vms -Name "快照名稱" -Memory:$false 
    echo "$vms"
    echo " "
}

echo "=== 新增完成 ==="

Disconnect-VIServer -Server $server -Confirm:$false
echo "--------------"
echo "|Process done|"
echo "--------------"
echo " "
