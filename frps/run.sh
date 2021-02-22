#!/usr/bin/with-contenv bashio
set -e

bashio::log.info "(0.35.1-rc2) Building frps.ini..."
configPath="/frps.ini"
if bashio::fs.file_exists $configPath; then
  rm $configPath
fi
echo "[common]" >> $configPath
echo "dashboard_port = 7500" >> $configPath
echo "bind_port = 7000" >> $configPath
echo "bind_udp_port = 7001" >> $configPath
echo "vhost_http_port = 80" >> $configPath
echo "vhost_https_port = 443" >> $configPath
echo "token = $(bashio::config 'token')" >> $configPath
echo "subdomain_host = $(bashio::config 'subdomain_host')" >> $configPath
echo "max_pool_count = $(bashio::config 'max_pool_count')" >> $configPath

bashio::log.info "Config file ${configPath} generated:"
cat $configPath
bashio::log.info "Serving tunnels.."
./frp/frps -c ${configPath}