param(
    [string]$Path = $null,
    [string]$Language = "en"
)
if ($Path -ne $null)
{
    Import-Module WhisperPS -DisableNameChecking
    $Model = Import-WhisperModel $env:USERPROFILE\.cache\whisper\whisper-medium-ggml-model.bin
    $Results = Get-ChildItem $Path | Transcribe-File -model $Model -language $Language
    foreach ( $i in $Results )
    { $txt = $i.SourceName + ".txt"; $i | Export-Text $txt; 
    }
}

# Set-Location C:\Temp\2remove\Whisper
# $Results = Get-ChildItem .\* -include *.wma, *.wav | Transcribe-File $Model
# foreach ( $i in $Results )
# { $txt = $i.SourceName + ".txt"; $i | Export-Text $txt; 
# }
# foreach ( $i in $Results )
# { $txt = $i.SourceName + ".ts.txt"; $i | Export-Text $txt -timestamps; 
# }
