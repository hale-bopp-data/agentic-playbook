# Recipe: Set Up SSH Gateway

```bash
# 1. Generate SSH key
ssh-keygen -t ed25519 -f ~/.ssh/easyway-server -N ""

# 2. Copy to server
ssh-copy-id -i ~/.ssh/easyway-server.pub user@server

# 3. Create _common.sh
_GW_SSH="/usr/bin/ssh"
_GW_KEY="$HOME/.ssh/easyway-server"
_GW_HOST="user@server-ip"

# 4. Create connector script sourcing _common.sh
# 5. Test: bash my-connector.sh healthcheck
```
