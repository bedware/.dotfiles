# Setup Fuzzy Finder
$FdExcludeDirs = @('.git', '.npm')
$FdDefaultOptions = "--path-separator / --strip-cwd-prefix --follow --hidden " + @($FdExcludeDirs | ForEach-Object {"--exclude $_"}) -join " "

$FD_FIND_FILE_COMMAND = "fd --type f --ignore-file $env:HOME/.config/git/.gitignore $FdDefaultOptions"
$FD_GLOBAL_FIND_FILE_COMMAND = "fd --type f --no-ignore $FdDefaultOptions"
$FD_FIND_DIRECTORY_COMMAND = "fd --type d --ignore-file $env:HOME/.config/git/.gitignore $FdDefaultOptions"
$FD_GLOBAL_FIND_DIRECTORY_COMMAND = "fd --type d --no-ignore $FdDefaultOptions"
$FILES_IN_GIT_COMMAND = "git ls-files"

function Put-VarToEnv($envVarName, $envVarValue) {
    if ($IsWindows) {
        $regPathUser = "HKCU:\Environment"

        $envVarName = [string]$envVarName
        $envVarValue = [string]$envVarValue

        if (-not (Test-Path -Path "$regPathUser\$envVarName")) {
            Set-ItemProperty -Path $regPathUser -Name $envVarName -Value $envVarValue
            Write-Output "Пользовательская переменная $envVarName была добавлена с значением $envVarValue."
        } else {
            Write-Output "Пользовательская переменная $envVarName уже существует в $regPathUser."
        }
    } elseif ($IsLinux) {
        $etcEnvPath = "/etc/profile.d/custom_env_vars.sh"

        if (-not (Select-String -Path $etcEnvPath -Pattern "export $envVarName=")) {
            Add-Content -Path $etcEnvPath -Value "export $envVarName='$envVarValue'"
            Write-Output "Переменная $envVarName была добавлена в $etcEnvPath с значением $envVarValue."
        } else {
            Write-Output "Переменная $envVarName уже существует в $etcEnvPath."
        }
    } else {
        Write-Output "Неизвестная платформа. Скрипт поддерживает только Windows и Linux."
    }
}

# Пример вызова функции с корректными значениями
Put-VarToEnv "FD_FIND_FILE_COMMAND" $FD_FIND_FILE_COMMAND
Put-VarToEnv "FD_GLOBAL_FIND_FILE_COMMAND" $FD_GLOBAL_FIND_FILE_COMMAND
Put-VarToEnv "FD_FIND_DIRECTORY_COMMAND" $FD_FIND_DIRECTORY_COMMAND
Put-VarToEnv "FD_GLOBAL_FIND_DIRECTORY_COMMAND" $FD_GLOBAL_FIND_DIRECTORY_COMMAND
Put-VarToEnv "FILES_IN_GIT_COMMAND" $FILES_IN_GIT_COMMAND

