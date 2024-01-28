$ErrorActionPreference = 'Stop'

function log
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$LogMessage
    )
    Write-Output ("[{0}] {1}" -f (Get-Date), $LogMessage)
}

$windowsToolchainsDir = "D:\AndroidStudio\AndroidSDK\ndk\26.1.10909125\toolchains\llvm\prebuilt\windows-x86_64\bin"
$clang = "${windowsToolchainsDir}/clang++.exe"
$target = "--target=aarch64-none-linux-android29"
$sysroot = "--sysroot=D:\AndroidStudio\AndroidSDK\ndk\26.1.10909125\toolchains\llvm\prebuilt\windows-x86_64\sysroot"
$cppFlags = "-std=c++20 -static -s -Ofast -Wall -Wextra -Wshadow -fno-exceptions -fno-rtti -DNDEBUG -fPIE"

log "Compiler..."
& $clang $target $sysroot $cppFlags.Split(' ') -I. main.cpp -o ./ARM64/freezeit

log "Done"