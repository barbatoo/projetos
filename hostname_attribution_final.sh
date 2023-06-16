#!/bin/bash

## Created by Gabriel Barbato - https://github.com/barbatoo
## this script defines the hostname of the Macbook based on the spreadsheet you want, relating the second column with the first
## only working in Monterey and later, because in Ventura it only runs once, and then it shows an error to change LocalHostName, idk why

# download spreadsheet
curl -L 'https://docs.google.com/spreadsheets/d/ID_DA_PLANILHA/export?format=csv' -o /tmp/teste.csv

# spreadsheet
output=$(cat /tmp/teste.csv)

# indicators
SERIAL=$(ioreg -l | grep IOPlatformSerialNumber | awk -F\" '/IOPlatformSerialNumber/{print $4}')
HOSTNAME=$(echo "$output" | awk -F ',' -v col1="$SERIAL" '$1 == col1 {print $2}')

# check if the serial of the current Macbook is in the spreadsheet, and define his HostName based on it
# and defines if the hostname that was asked to be defined, matches the one defined
if [ -n "$HOSTNAME" ]; then
    sudo scutil --set HostName $HOSTNAME
    sleep 0.5
    if [ $(sudo scutil --get $1) == $HOSTNAME ]; then
        if [ $success ]; then
            success=true
        fi
    else
        echo "Erro ao definir $1"
        success=false
    fi
    sudo scutil --set ComputerName $HOSTNAME
    sleep 0.5
    if [ $(sudo scutil --get $1) == $HOSTNAME ]; then
        if [ $success ]; then
            success=true
        fi
    else
        echo "Erro ao definir $1"
        success=false
    fi
    sudo scutil --set LocalHostName $HOSTNAME
    sleep 0.5
    if [ $(sudo scutil --get $1) == $HOSTNAME ]; then
        if [ $success ]; then
            success=true
        fi
    else
        echo "Erro ao definir $1"
        success=false
    fi

    echo "O Host Name foi definido!"

    rm -rf /tmp/teste.csv
    exit 0
else
    # if the serial of the current Macbook is not in the spreadsheet, it shows this error message
    echo "Serial NÃO está na planilha"

    rm -rf /tmp/teste.csv
    exit 1
fi
