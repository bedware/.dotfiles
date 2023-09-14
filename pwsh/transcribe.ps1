param(
    [string]$Language = "en"
)
Import-Module WhisperPS -DisableNameChecking
$Model = Import-WhisperModel $env:USERPROFILE\.cache\whisper\whisper-medium-ggml-model.bin
$Path = Read-Host "Enter filename here"
while ($Path -ne '') {
    $Results = Get-ChildItem $Path | Transcribe-File -model $Model -language $Language
    foreach ( $i in $Results )
    { $txt = $i.SourceName + ".txt"; $i | Export-Text $txt; 
    }
    $Path = Read-Host "Enter filename here"
}
$Model = $null

# Set-Location C:\Temp\2remove\Whisper
# $Results = Get-ChildItem .\* -include *.wma, *.wav | Transcribe-File $Model
# foreach ( $i in $Results )
# { $txt = $i.SourceName + ".txt"; $i | Export-Text $txt; 
# }
# foreach ( $i in $Results )
# { $txt = $i.SourceName + ".ts.txt"; $i | Export-Text $txt -timestamps; 
# }
