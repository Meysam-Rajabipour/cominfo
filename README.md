# cominfo
Get computer some Information such as Computername, OS Build, IP Address,  "Drive C:" FreeSpace(GB), OS Name

# PowerShell Function: ComInfo

## Description

ComInfo is a PowerShell function that retrieves information from remote computers, including OS build number, IP address, free space on the 'C:' drive, and OS name. It distinguishes between online and offline computers and displays the results accordingly.

## Requirements

- Windows PowerShell 3.0 or later.
- Administrative privileges on the remote computers.

## Parameters

- **computername**: One or more computer names to retrieve information from (mandatory).
- **IPAddress**: An optional parameter to specify a specific IP address to query (validate IP pattern).
- **errorlog**: A switch parameter to enable error logging (verbose mode).
- **logfile**: An optional parameter to specify the error log file path.

## Usage

```powershell
# Example usage:
cominfo -computername 'Computer1', 'Computer2', 'Computer3'


cominfo -computername Host, dc
Error occurred while retrieving information for Computer dc

Online Computers:


computername OS Build IP Address  FreeSpace(GB)    OS Name                        
------------ -------- ----------  -------------    -------                        
host    19045    192.168.x.x           31          Microsoft Windows 10 Enterprise

