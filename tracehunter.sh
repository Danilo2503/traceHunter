#!/bin/bash

# Verificação de Permissões
if [[ $EUID -ne 0 ]]; then
    echo -e "\e[31mErro: Este script deve ser executado como root!\e[0m"
    exit 1
fi

# Definição do diretório de coleta
COLLECTED_DIR="collected_files"
mkdir -p "$COLLECTED_DIR"

# Mensagem de Início
echo -e "\e[35;1mColetando arquivos do sistema...\e[0m"

# Coleta de Informações do Sistema
echo -e "\e[95mListando informações sobre discos e partições...\e[0m"
lsblk > "$COLLECTED_DIR/disk_info.txt"

# Coleta de Conexões de Rede
echo -e "\e[95mColetando informações de rede...\e[0m"
ss -tulnp > "$COLLECTED_DIR/active_connections.txt"
netstat -tuln > "$COLLECTED_DIR/open_ports.txt"

# Coleta de Processos
echo -e "\e[95mColetando lista de processos...\e[0m"
ps aux > "$COLLECTED_DIR/process_list.txt"

# Coleta de Registros do Sistema
echo -e "\e[95mColetando logs do sistema...\e[0m"
cp /var/log/syslog "$COLLECTED_DIR/syslog.log" 2>/dev/null
cp /var/log/auth.log "$COLLECTED_DIR/auth.log" 2>/dev/null
cp /var/log/dmesg "$COLLECTED_DIR/dmesg.log" 2>/dev/null

# Coleta de Arquivos de Configuração
echo -e "\e[95mColetando arquivos de configuração...\e[0m"
cp -r /etc "$COLLECTED_DIR/etc_backup" 2>/dev/null

# Coleta de Lista de Arquivos no Diretório Raiz
echo -e "\e[95mListando o diretório raiz...\e[0m"
ls -la / > "$COLLECTED_DIR/root_dir_list.txt"

# Compactação dos arquivos
HOSTNAME=$(hostname)
DATETIME=$(date +%Y%m%d_%H%M%S)
TAR_FILE="TraceHunter_${HOSTNAME}_${DATETIME}.tar.gz"
tar -czf "$TAR_FILE" "$COLLECTED_DIR"

# Mensagem de finalização
echo -e "\e[32mColeta concluída! Arquivo gerado: $TAR_FILE\e[0m"
