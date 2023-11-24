import-Module VMware.PowerCLI
import-Module VMware.VimAutomation.Core
$vCenter = "VC_IP"
$dc = "Datacenter_name" 
$vm_list = $Env:Hostname
$PASSW=ConvertTo-SecureString -String $env:DomainUserPassword -AsPlainText -Force
$Cred=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:DomainUser, $PASSW
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Connect-VIServer -Server $vCenter -Credential $Cred -Force
foreach ($VM in $vm_list) {
Get-VM -Name $VM | Update-Tools -NoReboot
}
