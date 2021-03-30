Set-Location (Split-Path $MyInvocation.MyCommand.Path)
$scriptdir = Split-Path $MyInvocation.MyCommand.Path
$streamurl = Read-Host -Prompt 'Stream URL'
$channel = youtube-dl --cookies $scriptdir\cookies.txt --write-description --skip-download -o "%(uploader)s"
$filename = youtube-dl --cookies $scriptdir\cookies.txt --write-description --skip-download -o "[%(uploader)s][%(upload_date)s] %(title)s (%(id)s)" --get-filename $streamurl
youtube-dl --cookies $scriptdir\cookies.txt --write-thumbnail --write-description --skip-download -o stream $streamurl
Read-Host -Prompt 'Press [Enter] to continue. Make sure Streamlink has finished recording the stream.'
$description = Get-Content stream.description -Raw
ffmpeg -i $scriptdir\stream.mp4 -i stream.jpg -map 1 -map 0 -c copy -disposition:0 attached_pic -metadata comment=$description ..\ProcessedStreams\$channel\$($filename + ".mp4")
$remove = Read-Host -Prompt 'Do you want to remove the original recording, stream.jpg, and stream.description (Y/N)? Be sure that post processing is complete and that your output has no errors'
if ($remove -eq 'y' -or 'Y' -or 'Yes' -or 'yes'){
Remove-Item ..\stream.mp4
Remove-Item .\stream.description
Remove-Item .\stream.jpg
}else{exit}
