# Setup Fuzzy Finder
$FdExcludeDirs = @('.git', '.npm')
$FdDefaultOptions = "--path-separator / --strip-cwd-prefix --follow --hidden " + @($FdExcludeDirs | ForEach-Object {"--exclude $_"}) -join " "

$FD_FIND_FILE_COMMAND = "fd --type f --ignore-file $env:HOME/.config/git/.gitignore $FdDefaultOptions"
$FD_GLOBAL_FIND_FILE_COMMAND = "fd --type f --no-ignore $FdDefaultOptions"
$FD_FIND_DIRECTORY_COMMAND = "fd --type d --ignore-file $env:HOME/.config/git/.gitignore $FdDefaultOptions"
$FD_GLOBAL_FIND_DIRECTORY_COMMAND = "fd --type d --no-ignore $FdDefaultOptions"
$FILES_IN_GIT_COMMAND = "git ls-files"

function Put-VarToEnv($envVarName, $envVarValue) {
    $regPathSystem = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    $regPathUser = "HKCU:\Environment"

    # Убедиться, что $envVarName является строкой
    $envVarName = [string]$envVarName
    $envVarValue = [string]$envVarValue

    # Добавление переменной в пользовательские переменные
    if (-not (Test-Path -Path "$regPathUser\$envVarName")) {
        Set-ItemProperty -Path $regPathUser -Name $envVarName -Value $envVarValue
        Write-Output "Пользовательская переменная $envVarName была добавлена с значением $envVarValue."
    } else {
        Write-Output "Пользовательская переменная $envVarName уже существует."
    }
}

# Пример вызова функции с корректными значениями
Put-VarToEnv "FD_FIND_FILE_COMMAND" $FD_FIND_FILE_COMMAND
Put-VarToEnv "FD_GLOBAL_FIND_FILE_COMMAND" $FD_GLOBAL_FIND_FILE_COMMAND
Put-VarToEnv "FD_FIND_DIRECTORY_COMMAND" $FD_FIND_DIRECTORY_COMMAND
Put-VarToEnv "FD_GLOBAL_FIND_DIRECTORY_COMMAND" $FD_GLOBAL_FIND_DIRECTORY_COMMAND
Put-VarToEnv "FILES_IN_GIT_COMMAND" $FILES_IN_GIT_COMMAND

