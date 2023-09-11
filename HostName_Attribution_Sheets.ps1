# URL da planilha no Google Sheets (substitua pelo URL da sua planilha)
$planilhaURL = 'https://docs.google.com/spreadsheets/d/ID_DA_PLANILHA/export?format=csv'

# Defina o caminho do arquivo CSV em um diretório público
$csvFilePath = 'C:\Users\planilha.csv'

# Baixa a planilha como um arquivo CSV
Invoke-WebRequest -Uri $planilhaURL -OutFile $csvFilePath

# Lê o arquivo CSV
$csvData = Import-Csv -Path $csvFilePath

# Obtenha o número de série da máquina atual
$Serial = (Get-WmiObject -Class Win32_BIOS).SerialNumber

# Encontre o hostname correspondente com base no número de série
$Hostname = $csvData | Where-Object { $_.Serial -eq $Serial } | Select-Object -ExpandProperty Hostname

# Define o novo hostname
Rename-Computer -NewName $Hostname

# Remova o arquivo CSV temporário
Remove-Item -Path $csvFilePath -Force

Write-Host "O computador foi renomeado para: $Hostname"