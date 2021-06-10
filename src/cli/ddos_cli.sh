#!/usr/bin/env bash

_help() {
/bin/cat <<EOF
Usage: $0 <command> [options]

Show help screen and exit.

optional arguments:
  -h, --help                 show this help message and exit

Commands:
  Global management:
  $0 global status           Show status of global server ddos mode.
  $0 global enable           Enable global ddos mode.
  $0 global disable          Disable global ddos mode.

  Domain management:
  $0 domain list             List all domains with ddos mode on.
  $0 domain status <domain>  Get ddos mode status for a domain.
  $0 domain add <domain>     Enable ddos mode for a domain.
  $0 domain del <domain>     Disable ddos mode for a domain.
EOF
}
if ! [[ ${@} ]]; then
  _help
fi