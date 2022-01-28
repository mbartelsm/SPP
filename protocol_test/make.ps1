function Build () {
    Write-Output "BUILDING"
    Write-Output "======================================"
    New-Item -ItemType Directory -Force -Path .\ebin\ | Out-Null  # Make directory if not found
    erl -make
}

function Run () {
    Build
    $Env:ERL_LEVEL="warn"
    Write-Output ""
    Write-Output "EXECUTING"
    Write-Output "======================================"
    erl -noinput -noshell -pa ./ebin/ -s main main
}

function Debug () {
    Build
    $Env:ERL_LEVEL="debug"
    Write-Output ""
    Write-Output "EXECUTING DEBUG"
    Write-Output "======================================"
    erl -noinput -noshell -pa ./ebin/ -s main main
}

if ($args[0] -eq "build") {
    Build
} elseif ($args[0] -eq "run") {
    Run
} elseif ($args[0] -eq "debug") {
    Debug
} else {
    Write-Output "USAGE: .\$($MyInvocation.MyCommand.Name) [ build | run | debug ]"
}
