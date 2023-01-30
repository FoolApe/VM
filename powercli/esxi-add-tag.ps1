### Made by SYS-Juro
### First version : 2021/12/23
### Description : 建立Tag

$user='hcl_system@vsphere.local'
$passwd=cat /juro_lin/nimajuro
$server = "10.249.34.35"

echo " "
echo "--------------------"
echo "|Connecting Vcenter|"
echo "--------------------"
Connect-VIserver -Server $server -User $user -Password $passwd |Out-Null
echo ""
echo "$server 已登入"
echo " "

### 指派Tag

echo "=== 開始新增Tag ==="

foreach($cluster in gc /usr/local/ESXI-update/HCL/host_lists/TPE_list)
{
	New-Tag -server $server -Name "$cluster" -Category TPE
}

echo "=== 新增完成 ==="
