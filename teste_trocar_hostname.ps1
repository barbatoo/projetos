# URL da planilha no Google Sheets (substitua pelo URL da sua planilha)
$planilhaURL = 'https://docs.google.com/spreadsheets/d/ID_DA_PLANILHA/export?format=csv'

# Caminho para onde salvar o arquivo CSV temporário
$csvFilePath = 'C:\Windows\Temp\'

# Baixa a planilha como um arquivo CSV
Invoke-WebRequest -Uri $planilhaURL -OutFile $csvFilePath

# Lê o arquivo CSV
$csvData = Import-Csv -Path $csvFilePath

# Obtenha o número de série da máquina atual
$Serial = (Get-WmiObject -Class Win32_BIOS).SerialNumber

# Encontre o hostname correspondente com base no número de série
$Hostname = $csvData | Where-Object { $_.Serial -eq $Serial } | Select-Object -ExpandProperty Hostname

# Verifique se o hostname foi encontrado
if ($Hostname -ne $null) {
    # Define o novo hostname
    Rename-Computer -NewName $Hostname

    # Verifique se o novo hostname foi definido com sucesso
    if ((Get-ComputerInfo).CsDNSHostName -eq $Hostname) {
        Write-Host "O hostname foi definido como $Hostname"
    }
    else {
        Write-Host "Erro ao definir o hostname como $Hostname"
    }
}
else {
    Write-Host "O número de série não está na planilha"
}

# Remova o arquivo CSV temporário
Remove-Item -Path $csvFilePath -Force