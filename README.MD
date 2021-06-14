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

#### Installation
Before installing the tool, ensure that HaProxy is built with Lua support.

- Copy [scripts](src/scripts) to a folder accessible for HaProxy
- Copy haproxy config and make sure that `lua-load` directive contains absolute path to [register.lua](src/scripts/register.lua)
- Copy [libs](src/libs) to a path where Lua looks for modules.
- Copy [ddos-cli](src/cli/ddos-cli) to any convenient path.
- Create `/usr/local/etc/haproxy/domains_under_ddos.txt` with write permissions for HaProxy (feel free to change the map file path, update the HaProxy config correspondingly)

#### CLI
The system comes with CLI. It can be used to manage global and per-domain protection.
Ensure that stat socket is configured in HaProxy for CLI support.
```bash
Usage: ddos-cli <command> [options]

Command line interface to manage per-domain and global DDoS protection.

optional arguments:
  -h, --help                         Show this help message and exit.

Commands:
 Global management:
  ddos-cli global status             Show status of global server ddos mode.
  ddos-cli global enable             Enable global ddos mode.
  ddos-cli global disable            Disable global ddos mode.

 Domain management:
  ddos-cli domain list               List all domains with ddos mode on.
  ddos-cli domain status <domain>    Get ddos mode status for a domain.
  ddos-cli domain enable <domain>    Enable ddos mode for a domain.
  ddos-cli domain disable <domain>   Disable ddos mode for a domain.

```


#### TO DO
- [x] Add CLI
- [x] Organize lua dependencies
- [x] Make per-user cookie secrets
- [ ] Add logging to CLI
