$sourceDir = ".\src"
$zipFile = ".\angular-src.zip"

# Eliminar el archivo ZIP anterior si ya existe
if (Test-Path $zipFile) { Remove-Item $zipFile }

# Crear una carpeta temporal limpia para copiar solo lo que necesitamos
$tempDir = ".\temp_src_zip"
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir | Out-Null

# Copiar archivos de src excluyendo lo innecesario
Get-ChildItem -Path $sourceDir -Recurse -File | Where-Object {
    $_.Name -ne 'Thumbs.db' -and 
    $_.Name -ne '.DS_Store' -and 
    $_.Extension -ne '.log' -and
    $_.FullName -notmatch '\\(\.angular|coverage)\\'
} | ForEach-Object {
    # Calcular la ruta relativa para replicar la estructura
    $relPath = $_.FullName.Substring((Get-Item $sourceDir).FullName.Length + 1)
    $destPath = Join-Path $tempDir $relPath
    $destParent = Split-Path $destPath -Parent
    
    if (!(Test-Path $destParent)) {
        New-Item -ItemType Directory -Path $destParent | Out-Null
    }
    Copy-Item $_.FullName -Destination $destPath
}

# Comprimir la carpeta temporal resultante
Compress-Archive -Path "$tempDir\*" -DestinationPath $zipFile -CompressionLevel Optimal

# Limpiar la carpeta temporal
Remove-Item $tempDir -Recurse -Force

Write-Host "¡Archivo ZIP creado con éxito: $zipFile!" -ForegroundColor Green