#!/bin/sh

set -e

if [ -z "$ETH_DEV" ]; then
  ETH_DEV=$(ip a | grep ': enp' | tail -1 | cut -d':' -f2 | tr -d '[:space:]')
fi
echo "ETH_DEV=$ETH_DEV"

if ! ( ip address | grep -q 169.254.10.10 ) ; then
  sudo ip address add 169.254.10.10/16 broadcast + dev $ETH_DEV
fi

HOST=169.254.100.3
#HOST=$(lanipof '3c:33:00:20:48:02')

echo "HOST=$HOST"

if ! command -v waypipe 2>&1 >/dev/null ; then
  echo "waypipe not found, running SSH directly"
  exec ssh -i /j/ident/azure_liminal_jeffrey jeffrey@$HOST
else
  exec waypipe ssh -i /j/ident/azure_liminal_jeffrey jeffrey@$HOST
fi
