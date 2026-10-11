### ---------------------   ngrok   --------  #######

alias ngrokstart='docker run -d \
  --name ngrok-https \
  -e NGROK_AUTHTOKEN=NGROK_AUTHTOKEN \
  ngrok/ngrok:latest \
  http --domain=urchin-free-utterly.ngrok-free.app host.docker.internal:5678'


alias ngrok_start='ngrok http --domain=urchin-free-utterly.ngrok-free.app localhost:5678'

alias ngrok_start1='ngrok http --domain=summary-model-jaybird.ngrok-free.app localhost:5678'

### ---------------------   N8N   --------  #######

                        ### ---------------------   N8N  locally --------  #######

n8n_start() {
  export N8N_RUNNERS_ENABLED=true
  export N8N_TIMEZONE="Asia/Bangkok"
  export GENERIC_TIMEZONE=Asia/Bangkok
  export N8N_DEFAULT_LOCALE=th
  export N8N_FILES_DIR="/Users/krit/Downloads"
  export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
  export N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true
  export N8N_EDITOR_BASE_URL=https://urchin-free-utterly.ngrok-free.app
  export WEBHOOK_URL=https://urchin-free-utterly.ngrok-free.app
  export N8N_DEFAULT_BINARY_DATA_MODE=filesystem
  export N8N_BASIC_AUTH_ACTIVE=true
  export N8N_BASIC_AUTH_USER=admin
  export N8N_BASIC_AUTH_PASSWORD=password
  export N8N_MULTI_USER=false
  export N8N_ENCRYPTION_KEY="${N8N_ENCRYPTION_KEY}"
  n8n
}

n8n_start1() {
  export N8N_RUNNERS_ENABLED=true
  export N8N_TIMEZONE="Asia/Bangkok"
  export GENERIC_TIMEZONE=Asia/Bangkok
  export N8N_DEFAULT_LOCALE=th
  export N8N_FILES_DIR="/Users/krit/Downloads"
  export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
  export N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true
  export N8N_EDITOR_BASE_URL=https://summary-model-jaybird.ngrok-free.app
  export WEBHOOK_URL=https://summary-model-jaybird.ngrok-free.app
  export N8N_DEFAULT_BINARY_DATA_MODE=filesystem
  export N8N_BASIC_AUTH_ACTIVE=true
  export N8N_BASIC_AUTH_USER=admin
  export N8N_BASIC_AUTH_PASSWORD=password
  export N8N_MULTI_USER=false
  export N8N_ENCRYPTION_KEY="${N8N_ENCRYPTION_KEY}"
  n8n
}

# Check update  n8n  versions  :
alias n8ncheckversion='curl -s https://api.github.com/repos/n8n-io/n8n/releases/latest | jq -r .tag_name'
alias n8nversion='docker exec n8n n8n -v'
alias n8nupdateimage='docker pull n8nio/n8n:latest'



##  Create new Container in Docker
alias n8ncontainer='docker run -d --name n8n-https \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  -v /Users/krit/Downloads:/files \
  -e GENERIC_TIMEZONE=Asia/Bangkok \
  -e N8N_DEFAULT_LOCALE=th \
  -e N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true \
  -e N8N_EDITOR_BASE_URL=https://urchin-free-utterly.ngrok-free.app \
  -e WEBHOOK_URL=https://urchin-free-utterly.ngrok-free.app \
  -e N8N_DEFAULT_BINARY_DATA_MODE=filesystem \
  -e N8N_RUNNERS_ENABLED=true \
  -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=password \
  -e N8N_MULTI_USER=false \
  -e N8N_ENCRYPTION_KEY="${N8N_ENCRYPTION_KEY}"  \
  n8nio/n8n'


alias n8ntemplatecontainer='docker run -d --name n8n-template \
  -p 5678:5678 \
  -v n8n_data_template:/home/node/.n8n \
  -v /Users/krit/Downloads:/files \
  -e GENERIC_TIMEZONE=Asia/Bangkok \
  -e N8N_DEFAULT_LOCALE=th \
  -e N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true \
  -e N8N_EDITOR_BASE_URL=https://urchin-free-utterly.ngrok-free.app \
  -e WEBHOOK_URL=https://urchin-free-utterly.ngrok-free.app \
  -e N8N_DEFAULT_BINARY_DATA_MODE=filesystem \
  -e N8N_RUNNERS_ENABLED=true \
  -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=password \
  -e N8N_MULTI_USER=false \
  -e N8N_ENCRYPTION_KEY="${N8N_ENCRYPTION_KEY}" \
  n8nio/n8n'


