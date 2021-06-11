## HaProxy DDoS protection system PoC

The system provides functionality to protect certain (or all) resources on HaProxy from L7 DDoS attacks.

It works by requiring a user to have a specific cookie issued after successful captcha completion. If a user does not have the cookie, he gets redirected to a special captcha page.

It is by no means a cure for all ills, but should help you mitigate a moderate DDoS attack without disrupting the service.

#### How it works

![alternative text](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/mora9715/haproxy_ddos_protector/master/docs/interaction_diagram.txt)

#### How to test

- export hcaptcha sitekey and secret:
```bash
export HCAPTCHA_SITEKEY=xxxXXxxx
export HCAPTCHA_SECRET=xxxXXxxx
```
They can be obtained after creating a free account on https://www.hcaptcha.com/

- run docker compose:
```bash
docker compose up
```

- visit *http://127.0.0.1*

For demostration purposes DDoS-protection mode was enabled by default.


#### CLI
The system comes with CLI. It can be used to manage global and per-domain protection:
```bash
Usage: ./ddos-cli <command> [options]

Command line interface to manage per-domain and global DDoS protection.

optional arguments:
  -h, --help                         Show this help message and exit.

Commands:
  Global management:
  ./ddos-cli global status           Show status of global server ddos mode.
  ./ddos-cli global enable           Enable global ddos mode.
  ./ddos-cli global disable          Disable global ddos mode.

  Domain management:
  ./ddos-cli domain list             List all domains with ddos mode on.
  ./ddos-cli domain status <domain>  Get ddos mode status for a domain.
  ./ddos-cli domain add <domain>     Enable ddos mode for a domain.
  ./ddos-cli domain del <domain>     Disable ddos mode for a domain.
```
