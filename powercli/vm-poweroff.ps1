$vcServer = "VC_IP"
$user = 'USERNAME'
$pass = 'PASSWORD'

# 連接到 vCenter Server
Connect-VIServer -Server $vcServer -User $user -Password $pass |out-null
Write-Host ""

# 指定要關閉客體系統的虛擬機清單
$vmList = '/PATH/TO/VM_LIST'

foreach ($vmName in $vmList) {
    $vm = Get-VM -Name $vmName

    if ($vm) {
        # 檢查虛擬機的電源狀態
        if ($vm.PowerState -eq "PoweredOn") {
            Write-Host "Shutting down guest OS for VM: $vmName"
            $vm | Shutdown-VMGuest -Confirm:$false
        } else {
            Write-Host "VM: $vmName is already powered off."
        }
    } else {
        Write-Host "VM: $vmName not found."
    }
    Write-Host "========================================"
    Write-Host ""
}
