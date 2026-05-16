@echo off
title Exportador Access Nativo PowerShell 32-bits
echo Iniciando exportacao em lote (PowerShell 32-bit)...
echo.

:: Força a chamada do PowerShell de 32 bits (SysWOW64) bypassando restrições de execução
%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\exportar_nativo.ps1

echo.
echo Processo concluido!
pause