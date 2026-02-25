"Corel Professional Photos Collection JPEG Converter"
"By Alex Miranda"
$util = Read-Host "Please enter full path for location of pcdtojpeg.exe"
cd $util
$disks = Read-Host "Please enter full path for folder containing the .iso Files"
$F = Read-Host "Please enter full path for folder to contain output.`r`n You will need over 65 GB free wherever this folder will be located."
if(-not(Test-Path -Path $F)){
New-Item -Path $F -Type Directory -Confirm
}else{
"Folder Already Exists, Files and folders won't be overwritten."
}
Get-ChildItem –Path $disks -Recurse |Foreach-Object {
$disk = $_
$message = "Mount: "
$message = $message + $disk
$message
try{
$mountResult = Mount-DiskImage -ImagePath $disk.FullName -ErrorAction Stop -PassThru
}
catch{
$message = "Mount Failed"
$message
Dismount-DiskImage -ImagePath $disk.FullName
Start-Sleep -Seconds 10
$message = "Trying Again"
$message
$mountResult = Mount-DiskImage -ImagePath $disk.FullName -PassThru
}finally{
$driveLetter = ($mountResult | Get-Volume).DriveLetter
$foldername = Split-Path $disk -leaf
$foldername = $foldername -replace "\.[^.]+$"
$C = $F + "\" + $foldername
if(-not(Test-Path -Path $C)){
New-Item -Path $C -Type Directory
}else{
"Folder Already Exists, Files and folders won't be overwritten."
}
}
Start-Sleep -Seconds 1
$first = Get-ChildItem -Path E:\Corel -Force -Recurse -File -Name | Select-Object -First 1
$last = Get-ChildItem -Path E:\Corel -Force -Recurse -File -Name | Select-Object -Last 1 -Skip 1
$first = $first -replace "\.[^.]+$"
$last = $last -replace "\.[^.]+$"
$A = $driveLetter + ":\COREL\"
$B = ".PCD"
$C = $C + "\"
$D = ".jpeg"
$i = 0
$Progress = @{
Activity = "Converting"
Status = "`r"
PercentComplete = ($i-[int]$first)+1
}
Write-Progress @Progress
for ($i = [int]$first; $i -le ([int]$first + 99); $i++){
$Progress = @{
Activity = "Converting"
Status = "`r"
PercentComplete = ($i-[int]$first)+1
}
$diskpath = $A + [string]$i + $B
$picpath = $C + [string]$i + $D
if(-not(Test-Path $picpath)){
.\pcdtojpeg.exe $diskpath $picpath
}else{
$message = "Pic Exists"
$message
}
Write-Progress @Progress
}
$last = Get-ChildItem -Path E:\Corel -Force -Recurse -File -Name | Select-Object -Last 1
$last = $last -replace "\.[^.]+$"
$diskpath = $A + $last + $B
$picpath = $C + $last + $D
if(-not(Test-Path $picpath)){
.\pcdtojpeg.exe $diskpath $picpath
}
$last = Get-ChildItem -Path E:\Corel -Force -Recurse -File -Name | Select-Object -Last 1 -Skip 1
$last = $last -replace "\.[^.]+$"
$diskpath = $A + $last + $B
$picpath = $C + $last + $D
if(-not(Test-Path $picpath)){
.\pcdtojpeg.exe $diskpath $picpath
}
$message = "Dismount: "
$message = $message + $disk
$message
Dismount-DiskImage -ImagePath $disk.FullName
Start-Sleep -Seconds 1
}
