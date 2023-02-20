$user=read-host "Enter your VC username."
$passwd=read-host "Enter your VC password." -MaskInput
$server = "VC_IP" ### Change to your VC IP

echo " "
echo "--------------------"
echo "|Connecting Vcenter|"
echo "--------------------"
Connect-VIserver -Server $server -User $user -Password $passwd |Out-Null
echo "$server 已登入" 
echo " " 

echo "=== ESXi | CPU_taken | MEM_taken ==="
$vmhost=Get-VMHost
foreach ($a in $vmhost)
{
    ### 名稱轉換
    $name = $a |select Name |egrep -v "Name|----" 

    ### CPU總和
    $CPU_raw=Get-VMHost -name $a |Get-vm |Where-Object {$_.PowerState -eq 'PoweredOn'} |select NumCPU |Format-Table -AutoSize |egrep -v "NumCpu|------"
    $sum_CPU=0
    foreach ($one_CPU in $CPU_raw)
    {   
        $one_CPU = $one_CPU -as [int] ### 字串轉整數
        $sum_CPU = $sum_CPU + $one_CPU
    }   
    #echo $sum_CPU
    
    ### MEM總和
    $MEM_raw=Get-VMHost -name $a |Get-vm |Where-Object {$_.PowerState -eq 'PoweredOn' -and $_.Name -notlike 'vCLS-*'} |select MemoryGB |Format-Table -AutoSize |egrep -v "MemoryGB|------" ### vCLS的MEM太小可以不計
    $sum_MEM=0
    foreach ($one_MEM in $MEM_raw)
    {   
        $one_MEM = $one_MEM -as [int] ### 字串轉整數
        $sum_MEM = $sum_MEM + $one_MEM
    }
    #echo $sum_MEM

    echo "$name|$sum_CPU|$sum_MEM" |sed 's/[[:space:]]//g'
}

echo ""

### 登出VC
Disconnect-VIServer -Server $server -Confirm:$false |out-null
