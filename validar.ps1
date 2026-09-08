param()
$ErrorActionPreference = 'Stop'
$projects = @('calculadora_flutter', 'flutter_application_1', 'proyecto_productos', 'interfaz_adaptativa_y_sensores', 'temu_clone_flutter')
foreach ($project in $projects) {
    Write-Host "Validando $project"
    Push-Location (Join-Path $PSScriptRoot $project)
    try {
        flutter pub get
        if ($LASTEXITCODE -ne 0) { throw "Dependencias: $project" }
        dart format --output=none --set-exit-if-changed lib test
        if ($LASTEXITCODE -ne 0) { throw "Formato: $project" }
        flutter analyze --no-pub
        if ($LASTEXITCODE -ne 0) { throw "Analisis: $project" }
        flutter test --no-pub
        if ($LASTEXITCODE -ne 0) { throw "Pruebas: $project" }
    } finally {
        Pop-Location
    }
}
Write-Host 'Los cinco proyectos pasaron la validacion.'
