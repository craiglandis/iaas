function RemoveDevice([string]$DeviceID)
{
$RemoveDeviceSource = @"
using System;
using System.Runtime.InteropServices;
using System.Text;
namespace Microsoft.Windows.Diagnosis
{
public sealed class DeviceManagement_Remove
{
public const UInt32 ERROR_CLASS_MISMATCH = 0xE0000203;
[DllImport("setupapi.dll", SetLastError = true, EntryPoint = "SetupDiOpenDeviceInfo", CharSet = CharSet.Auto)]
static extern UInt32 SetupDiOpenDeviceInfo(IntPtr DeviceInfoSet, [MarshalAs(UnmanagedType.LPWStr)]string DeviceID, IntPtr Parent, UInt32 Flags, ref SP_DEVINFO_DATA DeviceInfoData);
[DllImport("setupapi.dll", SetLastError = true, EntryPoint = "SetupDiCreateDeviceInfoList", CharSet = CharSet.Unicode)]
static extern IntPtr SetupDiCreateDeviceInfoList(IntPtr ClassGuid, IntPtr Parent);
[DllImport("setupapi.dll", SetLastError = true, EntryPoint = "SetupDiDestroyDeviceInfoList", CharSet = CharSet.Unicode)]
static extern UInt32 SetupDiDestroyDeviceInfoList(IntPtr DevInfo);
[DllImport("setupapi.dll", SetLastError = true, EntryPoint = "SetupDiRemoveDevice", CharSet = CharSet.Auto)]
public static extern int SetupDiRemoveDevice(IntPtr DeviceInfoSet, ref SP_DEVINFO_DATA DeviceInfoData);
[StructLayout(LayoutKind.Sequential)]
public struct SP_DEVINFO_DATA
{
public UInt32 Size;
public Guid ClassGuid;
public UInt32 DevInst;
public IntPtr Reserved;
}
private DeviceManagement_Remove()
{
}
public static UInt32 GetDeviceInformation(string DeviceID, ref IntPtr DevInfoSet, ref SP_DEVINFO_DATA DevInfo)
{
DevInfoSet = SetupDiCreateDeviceInfoList(IntPtr.Zero, IntPtr.Zero);
if (DevInfoSet == IntPtr.Zero)
{
return (UInt32)Marshal.GetLastWin32Error();
}
DevInfo.Size = (UInt32)Marshal.SizeOf(DevInfo);
if(0 == SetupDiOpenDeviceInfo(DevInfoSet, DeviceID, IntPtr.Zero, 0, ref DevInfo))
{
SetupDiDestroyDeviceInfoList(DevInfoSet);
return ERROR_CLASS_MISMATCH;
}
return 0;
}
public static void ReleaseDeviceInfoSet(IntPtr DevInfoSet)
{
SetupDiDestroyDeviceInfoList(DevInfoSet);
}
public static UInt32 RemoveDevice(string DeviceID)
{
UInt32 ResultCode = 0;
IntPtr DevInfoSet = IntPtr.Zero;
SP_DEVINFO_DATA DevInfo = new SP_DEVINFO_DATA();
ResultCode = GetDeviceInformation(DeviceID, ref DevInfoSet, ref DevInfo);
if (0 == ResultCode)
{
if (1 != SetupDiRemoveDevice(DevInfoSet, ref DevInfo))
{
ResultCode = (UInt32)Marshal.GetLastWin32Error();
}
ReleaseDeviceInfoSet(DevInfoSet);
}
return ResultCode;
}
}
}
"@
 
    Add-Type -TypeDefinition $RemoveDeviceSource
 
    $DeviceManager = [Microsoft.Windows.Diagnosis.DeviceManagement_Remove]
    $ErrorCode = $DeviceManager::RemoveDevice($DeviceID)

    return $ErrorCode
}
 
If (!(Test-Path "$Env:SystemDrive\Temp"))
{
    New-Item "$Env:SystemDrive\Temp" -type directory
}
 
$LogFile = "$Env:SystemDrive\Temp\FixAzureVM-RemoveNICs.log"
" ####################" | Out-File $LogFile -Append
 
$Stamp = Get-Date
 
" Start time: $Stamp" | Out-File $LogFile -Append
 
" ####################" | Out-File $LogFile -Append
 
#list NICs
 
" Listing NICs on this system..." | Out-File $LogFile -Append
 
[array] $AllNICs = gwmi Win32_NetworkAdapter | Select NetConnectionId,PNPDeviceID | Where {$_.PNPDeviceID -like "VMBUS\{*}*"}
 
$AllNICs | Out-File $LogFile -Append
 
If ($AllNICs) { [array] $AllNICsSorted = $AllNICs| Sort-Object -Property NetConnectionId }
 
If ($AllNICsSorted) 
{
    ForEach ($NIC in $AllNICsSorted)
    {
        $NICName = $NIC.NetConnectionId
        $NICDevice = $NIC.PNPDeviceID
        " --------------------" | Out-File $LogFile -Append
 
        " Removing $NICName" | Out-File $LogFile -Append
 
        " Device: $NICDevice" | Out-File $LogFile -Append
 
        $RemoveResult = RemoveDevice $NICDevice
 
        $RemoveResult | Out-File $LogFile -Append
 
        " --------------------" | Out-File $LogFile -Append 
    }
}
 
" ####################" | Out-File $LogFile -Append
 
$Stamp = Get-Date
 
" End time: $Stamp" | Out-File $LogFile -Append
 
" ####################" | Out-File $LogFile -Append