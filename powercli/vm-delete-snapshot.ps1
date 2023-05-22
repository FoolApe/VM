$vcServer = "VC_IP"
$user = 'USERNAME'
$pass = 'PASSWORD'

# 連接到 vCenter Server
Connect-VIServer -Server $vcServer -User $user -Password $pass |out-null
Write-Host ""

# 取得VM清單
$vmlist = Get-VM | Where-Object {$_.PowerState -eq 'PoweredOn'} ### 僅指定開機者

foreach ($vm_node in $vmlist) {
    $vmName = $vm_node.Name
    $snapshotList = Get-VM -Name $vmName | Get-Snapshot | Sort-Object -Property Created

    # 檢查是否有快照
    if ($snapshotList.Count -eq 0) {
        continue
    }

    Write-Host "VMhost: $vmName"

    # 刪除快照 (從最舊的開始刪除)
    foreach ($snapshot in $snapshotList) {
        $snapshotName = $snapshot.Name
        Write-Host "Deleting snapshot: $snapshotName"
        #Remove-Snapshot -Snapshot ${snapshot} -Confirm:$false
    } 

    Write-Host "===================================================="
    Write-Host ""
}

# 斷開與 vCenter Server 的連線
Disconnect-VIServer -Server * -Confirm:$false
