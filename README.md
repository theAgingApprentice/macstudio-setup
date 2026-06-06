# macstudio-setup

Personal Mac Studio developer environment setup repo. Answers the question:
**"If I get a new Mac tomorrow, how do I recreate my development environment and MitchellNET workflow tools?"**

---

## Quick start (fresh Mac)

```bash
git clone https://github.com/theAgingApprentice/macstudio-setup.git ~/Documents/visualStudioCode/macstudio-setup
cd ~/Documents/visualStudioCode/macstudio-setup
scripts/install.sh
```

`install.sh` handles the automated steps. After it finishes, follow the printed manual steps (clone service repos, add `/etc/hosts` entry, run `mkcert -install`).

---

## Scripts

| Script | Purpose |
|---|---|
| `install.sh` | Bootstrap a fresh Mac Studio end-to-end (run this first) |
| `aaCopyMotd` | Copy `motd/motd` from this repo to `/etc/motd` |
| `aaCopyScripts` | Install all scripts in `scripts/` to `/usr/local/bin` |
| `aaHelp` | Print a help summary of all custom scripts and the current MOTD |
| `aaGoMqtt` | Publish or subscribe to MQTT topics on the MitchellNET broker (192.168.2.10:1883) |

All scripts follow the `aa` prefix convention so they sort together and tab-complete easily.

---

## Directory structure

```
macstudio-setup/
├── motd/
│   └── motd            Plain-text message of the day for /etc/motd
├── scripts/
│   ├── install.sh      Full environment bootstrap
│   ├── aaCopyMotd      Deploy the MOTD file
│   ├── aaCopyScripts   Deploy scripts to /usr/local/bin
│   ├── aaGoMqtt        MQTT CLI helper
│   └── aaHelp          Help summary
└── README.md
```

---

## MitchellNET repos

Infrastructure and service repos live under [github.com/theAgingApprentice](https://github.com/theAgingApprentice).

| Repo | Purpose |
|---|---|
| [macstudio-setup](https://github.com/theAgingApprentice/macstudio-setup) | This repo — Mac Studio dev environment bootstrap |
| [mitchellnet-infra](https://github.com/theAgingApprentice/mitchellnet-infra) | Docker Compose stacks, Traefik config, full infrastructure runbook |
| [mitchellnet-hub](https://github.com/theAgingApprentice/mitchellnet-hub) | Home dashboard service |

> **Note:** Infrastructure scripts (Traefik, Portainer, Node-RED, Mosquitto management) live in
> `mitchellnet-infra/scripts/`, **not** here. This repo is Mac-workstation setup only.

---

## Manual steps not covered by install.sh

1. **Clone MitchellNET repos** into `~/Documents/visualStudioCode/`
2. **Add host alias** — `sudo sh -c 'echo "192.168.2.10 mitchellnet.local" >> /etc/hosts'`
3. **Trust local CA** — `mkcert -install && mkcert mitchellnet.local '*.mitchellnet.local' localhost`
4. **Install Anthropic Claude extension** in VS Code (Extensions → search "Claude" by Anthropic)
