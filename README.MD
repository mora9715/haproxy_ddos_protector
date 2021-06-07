## HaProxy DDoS protection system PoC

If there is an unusual HTTP requests flow to a specific domain, the system detects it and triggers DDoS protection mode.
Each new client will be first forced to complete hCaptcha, before proceeding to the website.


##### How to test

- export hcaptcha sitekey and secret:
```bash
export HCAPTCHA_SITEKEY=xxxXXxxx
export HCAPTCHA_SECRET=xxxXXxxx
```
- run docker compose:
```bash
docker compose up
```

- visit *http://127.0.0.1/captcha*