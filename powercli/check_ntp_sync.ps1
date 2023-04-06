### login sepc
$user = 'USER'
$passwd = gc '/PATH/TO/YOUR/PASS'
$server = "VC_IP" ### Change to your VC IP
$list = gc '/home/jackeylin/powercli/ntp_list'

echo ""
write-host "=== Check VMware Tools timesync ===" -ForegroundColor Yellow

write-host "-) Connecting to $server"
Connect-VIServer $server -User $user -Password $passwd -Force |Out-null

foreach($vmname in $list)
{
    $vm = Get-VM -Name "$vmname"
    Get-View -ViewType virtualmachine | Select name,@{N='ToolSyncTimeWithHost';E={$_.Config.Tools.syncTimeWithHost } } |where {$_.Name -like "$vmname*"} |Format-Table -AutoSize
}

### logout vCenter
write-host "=== Disconnect vCenter ===" -ForegroundColor Yellow
Disconnect-VIServer -Server $server -Confirm:$false |Out-null
echo ""
