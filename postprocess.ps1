Set-Location (Split-Path $MyInvocation.MyCommand.Path)
$scriptdir = Split-Path $MyInvocation.MyCommand.Path
$streamurl = Read-Host -Prompt 'Stream URL'
$channel = youtube-dl --cookies $scriptdir\cookies.txt --write-description --skip-download -o "%(uploader)s" --get-filename $streamurl
$filename = youtube-dl --cookies $scriptdir\cookies.txt --write-description --skip-download -o "[%(uploader)s][%(upload_date)s] %(title)s (%(id)s)" --get-filename $streamurl
youtube-dl --cookies $scriptdir\cookies.txt --write-thumbnail --write-description --skip-download -o "..\Recordings\$channel\stream" $streamurl
Read-Host -Prompt 'Press [Enter] to continue. Make sure Streamlink has finished recording the stream.'
if (-not (Test-Path -LiteralPath ..\ProcessedStreams\$channel\)) {
    
    try {
        New-Item -Path "..\ProcessedStreams\$channel" -ItemType Directory -ErrorAction Stop | Out-Null #-Force
    }
    catch {
        Write-Error -Message "Unable to create directory '$channel'. Error was: $_" -ErrorAction Stop
    }
    "Successfully created directory '$channel'."

}
else {
    "Cannot create channel directory. Directory may already exist."
}
ffmpeg -v debug -i ..\Recordings\$channel\stream.ts -i ..\Recordings\$channel\stream.jpg -map 1 -map 0 -c copy -disposition:0 attached_pic "..\ProcessedStreams\$channel\$($filename + ".mp4")"
$remove = Read-Host -Prompt 'Do you want to remove the original recording, stream.jpg, and stream.description (Y/N)? Be sure that post processing is complete and that your output has no errors'
if (($remove -eq 'y') -or ($remove -eq 'Y') -or ($remove -eq 'yes') -or ($remove -eq 'Yes')){
		Remove-Item ..\Recordings\$channel\stream.jpg
		Remove-Item ..\Recordings\$channel\stream.description
		Remove-Item ..\Recordings\$channel\stream.ts
		Remove-Item ..\Recordings\$channel\
}
