#!/bin/sh

set -e

if ! ( ip address | grep -q 169.254.10.10 ) ; then
  sudo ip address add 169.254.10.10/16 broadcast + dev enp7s0u1u2
fi

HOST=169.254.100.3
#HOST=$(lanipof '3c:33:00:20:48:02')

echo "HOST=$HOST"

exec ssh -i /j/ident/azure_liminal_jeffrey jeffrey@$HOST
