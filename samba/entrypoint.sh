#!/bin/bash

echo "Running entrypoint script for Samba..."

BASE_DIR=${BASE_DIR:-/mount/shares} # Default to /mount/shares if not set
CREATE_USER_SHARES=${CREATE_USER_SHARES:-true} # Default to true if not set

# General "dateiablage" share configuration (for all users)
cat >> /etc/samba/smb.conf <<EOL

[dateiablage]
   path = $BASE_DIR/dateiablage
   writable = yes
   browseable = yes
   guest ok = no
   create mask = 0777
   directory mask = 0777
EOL

mkdir -p $BASE_DIR/dateiablage
chmod -R 0777 $BASE_DIR/dateiablage
chown -R nobody:nogroup $BASE_DIR/dateiablage

# Decode JSON and add users accordingly
echo "$SAMBA_USERS" | jq -c '.[]' | while read -r i; do
    user=$(echo "$i" | jq -r '.username')
    password=$(echo "$i" | jq -r '.password')

    if ! id "$user" &>/dev/null; then
        adduser --disabled-password --no-create-home --gecos "" "$user"
        echo "$user:$password" | chpasswd
    fi

    (echo "$password"; echo "$password") | smbpasswd -a "$user"
    smbpasswd -e "$user"

    # Check if user homes should be created
    if [ "$CREATE_USER_SHARES" = "true" ]; then
        mkdir -p $BASE_DIR/homes/"$user"
        chmod 0700 $BASE_DIR/homes/"$user"
        chown "$user":"$user" $BASE_DIR/homes/"$user"

        cat >> /etc/samba/smb.conf <<EOL

[$user]
   path = $BASE_DIR/homes/$user
   writable = yes
   valid users = $user
   browseable = no
EOL
    fi

done

# Reload the Samba service to apply changes
service smbd reload

exec "$@"
