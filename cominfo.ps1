Function ComInfo {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, HelpMessage='One or More Computer Names or IP address')]
        [Alias('Host')]
        [String[]]$computername,

        [ValidatePattern("\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b")]
        [String]$IPAddress,

        [Switch]$errorlog,
        [String]$logfile = 'c:\logs\errorlog.txt'
    )

    Begin {
        If ($errorlog) {
            Write-Verbose 'Error logging turned on'
        } else {
            Write-Verbose 'Error logging turned off'
        }
        # Create arrays to store the results
        $onlineResults = @()
        $offlineResults = @()
    }

    Process {
        Foreach ($c in $computername) {
            if (Test-Connection -ComputerName $c -Count 1 -Quiet) {
                Try {
                    $os = Get-WmiObject -ComputerName $c -Class Win32_OperatingSystem -ErrorAction Stop
                    $disk = Get-WmiObject -ComputerName $c -Class Win32_LogicalDisk -Filter "DeviceID='c:'" -ErrorAction Stop
                    $IP = (Get-WmiObject -ComputerName $c -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.DHCPEnabled -ne $null }).IPAddress | Select-Object -First 1

                    $prop = [ordered]@{
                        'computername' = $c
                        'OS Build' = $os.BuildNumber
                        'IP Address' = $IP
                        'FreeSpace(GB)' = $disk.FreeSpace / 1GB -as [int]
                        'OS Name' = $os.Caption
                    }

                    $obj = New-Object -TypeName PSObject -Property $prop
                    $onlineResults += $obj  # Add the object to the online results array
                }
                Catch {
                    Write-Host "Error occurred while retrieving information for Computer $c" -ForegroundColor Yellow
                }
            }
            else {
                Write-Host "Computer $c is NOTonline" -ForegroundColor Red
                $offlineResults += $c  # Add the computer name to the offline results array
            }
        }
    }

    End {
        # Format and display the online results if any
        if ($onlineResults.Count -gt 0) {
            Write-Host "`nOnline Computers:`n" -ForegroundColor Green
            $onlineResults | Format-Table -AutoSize
        }

        # Display the NOTonline computers if any
        if ($offlineResults.Count -gt 0) {
            Write-Host "`nNOTonline Computers:`n" -ForegroundColor Red
            $offlineResults
        }
    }
}
