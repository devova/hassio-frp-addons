#!/usr/bin/with-contenv bashio
set -e

bashio::log.debug "Building frpc.ini..."
configPath="/frpc.ini"
if bashio::fs.file_exists $configPath; then
  rm $configPath
fi
echo "[common]" >> $configPath
echo "server_addr = $(bashio::config 'server_addr')" >> $configPath
echo "server_port = $(bashio::config 'server_port')" >> $configPath
if bashio::var.has_value "$(bashio::config 'token')"; then
  echo "token = $(bashio::config 'token')" >> $configPath
fi
echo "tls_enable = true" >> $configPath
echo "pool_count = 3" >> $configPath
echo "admin_addr = 0.0.0.0" >> $configPath
echo "admin_port = 8099" >> $configPath
echo "admin_user = $(bashio::config 'admin_user')" >> $configPath
echo "admin_pwd = $(bashio::config 'admin_pwd')" >> $configPath

for id in $(bashio::config "tunnels|keys"); do
  name=$(bashio::config "tunnels[${id}].name")
  echo "[$name]" >> $configPath
  type=$(bashio::config "tunnels[${id}].type")
  echo "type = $type" >> $configPath
  local_ip=$(bashio::config "tunnels[${id}].local_ip")
  if bashio::var.has_value "$(dig +short ${local_ip})"; then
    echo "local_ip = $(dig +short ${local_ip})" >> $configPath
  else
    echo "local_ip = ${local_ip}" >> $configPath
  fi
  local_port=$(bashio::config "tunnels[${id}].local_port")
  echo "local_port = $local_port" >> $configPath
  subdomain=$(bashio::config "tunnels[${id}].subdomain")
  if bashio::var.has_value $subdomain; then
    echo "subdomain = ${subdomain}" >> $configPath
  fi
  echo "use_encryption = true" >> $configPath
  echo "use_compression = true" >> $configPath
done

bashio::log.info "Config file ${configPath} generated:"
cat $configPath
# echo "$(ls -la frp)"
bashio::log.info "Tunneling.."
nohup ./frp/frpc -c ${configPath} > nohup.out &
sleep 3
curl http://127.0.0.1:8099/api/status -u $(bashio::config 'admin_user'):$(bashio::config 'admin_pwd') | jq
tail -f nohup.out
