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
$id = Get-Content magisk/module.prop | Where-Object { $_ -match "id=" }
$id = $id.split('=')[1]
$version = Get-Content magisk/module.prop | Where-Object { $_ -match "version=" }
$version = $version.split('=')[1]
$versionCode = Get-Content magisk/module.prop | Where-Object { $_ -match "versionCode=" }
$versionCode = $versionCode.split('=')[1]
$zipFile = "${id}_v${version}.zip"

$windowsToolchainsDir = "D:\AndroidStudio\AndroidSDK\ndk\26.1.10909125\toolchains\llvm\prebuilt\windows-x86_64\bin"
$clang = "${windowsToolchainsDir}/clang++.exe"
$target = "--target=aarch64-none-linux-android29"
$sysroot = "--sysroot=D:\AndroidStudio\AndroidSDK\ndk\26.1.10909125\toolchains\llvm\prebuilt\windows-x86_64\sysroot"
$cppFlags = "-std=c++20 -static -s -Ofast -Wall -Wextra -Wshadow -fno-exceptions -fno-rtti -DNDEBUG -fPIE"

log "Compiler..."
& $clang $target $sysroot $cppFlags.Split(' ') -I. main.cpp -o magisk/${id}

Copy-Item changelog.md magisk -force


$releaseDir = "D:\freezeit\freezeitRelease"
if ((Test-Path $releaseDir) -ne "True")
{
    log "None Path: $releaseDir"
    exit
}

log "Packing... $zipFile"
& ./7za.exe a "${releaseDir}/${zipFile}" ./magisk/* | Out-Null
if (-not$?)
{
    log "Pack fail"
    exit
}

# https://github.com/jark006/freezeitRelease/raw/blob/main/$zipFile
# https://github.com/jark006/freezeitRelease/raw/blob/main/changelog.txt

# https://raw.githubusercontent.com/jark006/freezeitRelease/blob/main/$zipFile
# https://raw.githubusercontent.com/jark006/freezeitRelease/blob/main/changelog.txt
# https://raw.githubusercontent.com/jark006/freezeitRelease/blob/main/freezeit_v2.2.17.zip

# https://raw.fastgit.org/jark006/freezeitRelease/blob/main/$zipFile
# https://raw.fastgit.org/jark006/freezeitRelease/blob/main/changelog.txt

# https://cdn.jsdelivr.net/gh/jark006/freezeitRelease/$zipFile
# https://cdn.jsdelivr.net/gh/jark006/freezeitRelease/changelog.txt

# https://gitee.com/jark006/freezeit-release/releases/download/${version}/$zipFile

# https://ghproxy.com/https://raw.githubusercontent.com/jark006/freezeitRelease/blob/main/$zipFile
# https://ghproxy.com/https://raw.githubusercontent.com/jark006/freezeitRelease/blob/main/changelog.txt

log "Creating... update json"
$jsonContent = "{
    `"version`": `"$version`",
    `"versionCode`": $versionCode,
    `"zipUrl`": `"https://gitee.com/XShee/freezeit-release/raw/release/$zipFile`",
    `"changelog`": `"https://gitee.com/XShee/freezeit-release/raw/release/changelog.md`"`n}"
$jsonContent > ${releaseDir}/update.json

Copy-Item README.md  ${releaseDir}/README.md -force
Get-Content changelog.md >> ${releaseDir}/README.md
Copy-Item changelog.md ${releaseDir}/changelog.md -force
Copy-Item changelogFull.txt ${releaseDir}/changelogFull.txt -force

log "All done"
