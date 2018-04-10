$ErrorActionPreference = "Stop"

#Clean
@(
    'output'
    'installer.msi'
    'directory.wxs'
) |
Where-Object { Test-Path $_ } |
ForEach-Object { Remove-Item $_ -Recurse -Force -ErrorAction Stop }

#create output dir
mkdir output

#Create a tmpdir
$tmp_dir = [io.path]::GetTempFileName()
Remove-Item $tmp_dir
mkdir $tmp_dir

#Copy excluding .git and installer
robocopy ..\ $tmp_dir /COPYALL /S /NFL /NDL /NS /NC /NJH /NJS /XD installer

#Generate the installer
$wix_dir="C:\Program Files (x86)\WiX Toolset v3.11\bin"

. "$wix_dir\heat.exe" dir $tmp_dir -srd -dr INSTALLDIR -cg MainComponentGroup -out directory.wxs -ke -sfrag -gg -var var.SourceDir -sreg -scom
. "$wix_dir\candle.exe" -arch x64 -dSourceDir="$tmp_dir" *.wxs -o output\
. "$wix_dir\light.exe" -o installer.msi output\*.wixobj -ext WixUIExtension

# Optional digital sign the certificate.
# You have to previously import it.
#. "C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Bin\signtool.exe" sign /n "Auth10" .\output\installer.msi

#Remove the temp
Remove-Item -Recurse -Force $tmp_dir
