### login sepc
$user = 'USER'
$passwd = gc '/PATH/TO/YOUR/PASSWD'
$server = "VC_IP" ### Change to your VC IP
$list = gc '/home/jackeylin/powercli/ntp_list'
#$vmname = 'jackey_time_dalay.test'

echo ""
write-host "=== Disable VMware Tools timesync ===" -ForegroundColor Yellow

write-host "-) Connecting to $server"
Connect-VIServer $server -User $user -Password $passwd -Force |Out-null

foreach($vmname in $list)
{
    write-host "+) $vmname" -ForegroundColor Green
    write-host "Disable VMware Tools timesync"
    $vm = Get-VM -Name "$vmname"

    ### spec about VMtools
    $vmconfigspec = New-Object VMware.Vim.VirtualMachineConfigSpec
    $value1 = New-Object VMware.Vim.OptionValue
    $value1.Key = 'tools.syncTime'
    $value1.Value = 'FALSE'
    $vmconfigspec.ExtraConfig += $value1
    $value2 = New-Object VMware.Vim.OptionValue
    $value2.Key = 'time.synchronize.continue'
    $value2.Value = 'FALSE'
    $vmconfigspec.ExtraConfig += $value2
    $value3 = New-Object VMware.Vim.OptionValue
    $value3.Key = 'time.synchronize.restore'
    $value3.Value = 'FALSE'
    $vmconfigspec.ExtraConfig += $value3
    $value4 = New-Object VMware.Vim.OptionValue
    $value4.Key = 'time.synchronize.resume.disk'
    $value4.Value = 'FALSE'
    $vmconfigspec.ExtraConfig += $value4
    $value5 = New-Object VMware.Vim.OptionValue
    $value5.Key = 'time.synchronize.shrink'
    $value5.Value = 'FALSE'
    $vmconfigspec.ExtraConfig += $value5
    $value6 = New-Object VMware.Vim.OptionValue
    $value6.Key = 'time.synchronize.tools.startup'
    $value6.Value = 'FALSE'
    $vmconfigspec.ExtraConfig += $value6
    $value7 = New-Object VMware.Vim.OptionValue
    $value7.Key = 'time.synchronize.tools.enable'
    $value7.Value = 'FALSE'
    $vmconfigspec.ExtraConfig += $value7
    $value8 = New-Object VMware.Vim.OptionValue
    $value8.Key = 'time.synchronize.resume.host'
    $value8.Value = 'FALSE'
    $vmconfigspec.ExtraConfig += $value8

    ### unselect time_sync with ESXi
    write-host "Disable time_sync with ESXi"
    $vm.ExtensionData.ReconfigVM($vmconfigspec)
    $spectools = New-Object VMware.Vim.VirtualMachineConfigSpec
    $spectools.tools= New-Object VMware.Vim.ToolsConfigInfo
    #$spectools.tools.syncTimeWithHostAllowed=$false ### 7.0.1以上才有
    $spectools.tools.SyncTimeWithHost=$false
    $vm_id = Get-view -id $vm.Id
    $vm_id.ReconfigVM_task($spectools) |Out-null

    #write-host "-) Restarting $vmname" -ForegroundColor Red
    #Restart-VM -VM $vm -Confirm:$false |Out-null ### 待維護再重啟
    echo ""
}

### logout vCenter
write-host "=== Disconnect vCenter ===" -ForegroundColor Yellow
Disconnect-VIServer -Server $server -Confirm:$false |Out-null
echo ""
