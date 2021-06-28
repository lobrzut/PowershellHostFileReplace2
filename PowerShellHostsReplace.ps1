$ErrorActionPreference = 'silentlycontinue'
#$source=\\192.168.96.14\c$\Windows\System32\drivers\etc\hosts
#$Destination = "\Windows\System32\drivers\etc\"
$servers = Get-Content $PSScriptRoot\braki.txt
$collection = $() 
foreach ($server in $servers) 
{
    $status = @{ "Komputer" = $server; "Data" = (Get-Date -f s) }
    if (Test-Connection $server -Count 1 -ea 0 -Quiet)
    { 
       	copy-item -Path "c:\Windows\System32\drivers\etc\hosts" -destination "\\$server\C$\windows\System32\drivers\etc" -PassThru
    if (-not $?) {
    Write-Warning "Błąd kopiowania: $server"
     $status["Results"] = "Nie skopiowano"
        }
    #$status["Results"] = "Up"
    } 
    else 
    { 
        $status["Results"] = "Down"
    }
    New-Object -TypeName PSObject -Property $status -OutVariable serverStatus
   
    $collection += $serverStatus

}
$collection | Export-Csv $PSScriptRoot\down_or_up.csv -NoTypeInformation