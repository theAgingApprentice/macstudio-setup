# macstudio-setup

This is a personal Mac Studio developer environment setup repo. Its purpose is to answer the question: **"If I get a new Mac tomorrow, how do I recreate my development environment and MitchellNET workflow tools?"** It is not a MitchellNET service repo and has no CI/CD pipeline — the environment is set up manually by cloning this repo and running `install.sh`.

---

## Quick start — fresh Mac Studio

1. Install Homebrew from https://brew.sh if not already installed.
2. Clone this repo to the expected path:
   ```bash
   git clone https://github.com/theAgingApprentice/macstudio-setup.git \
     ~/Documents/visualStudioCode/newProjectStructure/macstudio-setup
   ```
3. Run the bootstrap script:
   ```bash
   bash scripts/install.sh
   ```
4. Add the MitchellNET host alias to `/etc/hosts`:
   ```bash
   echo "192.168.2.10 mitchellnet.local" | sudo tee -a /etc/hosts
   ```
5. Clone the MitchellNET service repos into `~/Documents/visualStudioCode/newProjectStructure/` (see [MitchellNET repos](#mitchellnet-repos) below).
6. Trust the `mitchellnet.local` SSL certificate:
   ```bash
   mkcert -install
   ```

---

## Scripts

Scripts in `scripts/` are deployed to `/usr/local/bin` by `aaCopyScripts` so they are available on `$PATH`.

| Script | What it does | When to use it |
|---|---|---|
| `install.sh` | Full end-to-end Mac Studio bootstrap: installs Homebrew packages, deploys scripts, copies MOTD | First thing on a fresh machine |
| `aaCopyMotd` | Copies `motd/motd` from this repo to `/etc/motd` | After editing the MOTD file |
| `aaCopyScripts` | Installs all scripts in `scripts/` to `/usr/local/bin` | After adding or updating a script in this repo |
| `aaHelp` | Prints a help summary of all custom scripts and the current MOTD | Anytime you need a quick reminder of available tools |
| `aaGoMqtt` | Publishes or subscribes to MQTT topics on the MitchellNET broker (`192.168.2.10:1883`) | Quick MQTT debugging or testing from the terminal |

All scripts use the `aa` prefix so they sort together and tab-complete as a group.

---

## MitchellNET repos

Clone each repo into `~/Documents/visualStudioCode/newProjectStructure/` after running `install.sh`.

| Repo | GitHub URL | Local path | Purpose |
|---|---|---|---|
| mitchellnet-infra | https://github.com/theAgingApprentice/mitchellnet-infra | `newProjectStructure/mitchellnet-infra` | Docker Compose stacks, Traefik config, infrastructure runbook, workflow scripts |
| InternalWebServer | https://github.com/theAgingApprentice/InternalWebServer | `newProjectStructure/InternalWebServer` | Internal web server service |
| fitness-tracker | https://github.com/theAgingApprentice/fitness-tracker | `newProjectStructure/fitness-tracker` | Fitness tracking service |
| bench-instrument-service | https://github.com/theAgingApprentice/bench-instrument-service | `newProjectStructure/bench-instrument-service` | Bench instrument integration service |
| mitchellnet-monitoring | https://github.com/theAgingApprentice/mitchellnet-monitoring | `newProjectStructure/mitchellnet-monitoring` | Monitoring stack (Prometheus, Grafana, alerting) |
| mitchellnet-device-registry | https://github.com/theAgingApprentice/mitchellnet-device-registry | `newProjectStructure/mitchellnet-device-registry` | Device registry and inventory service |
| mitchellnet-iot | https://github.com/theAgingApprentice/mitchellnet-iot | `newProjectStructure/mitchellnet-iot` | IoT device management and MQTT integration |
| christmasTree | https://github.com/theAgingApprentice/christmasTree | `newProjectStructure/christmasTree` | Christmas tree light controller |

---

## MitchellNET workflow scripts

The MitchellNET developer workflow scripts — `aaGitPromote`, `aaGitCleanupBranches`, `aaRegisterRunner`, `aaInstall`, `aaNewService` — live in `mitchellnet-infra/scripts/`, **not** in this repo. To install them, run:

```bash
bash scripts/aaInstall
```

from the `mitchellnet-infra` repo root. Full developer workflow documentation is in `mitchellnet-infra/docs/runbook.md`.

---

## Directory structure

```
macstudio-setup/
├── motd/
│   └── motd                Plain-text message of the day, deployed to /etc/motd
├── scripts/
│   ├── install.sh          Full Mac Studio bootstrap — run this first on a fresh machine
│   ├── aaCopyMotd          Deploy motd/motd to /etc/motd
│   ├── aaCopyScripts       Install all scripts in scripts/ to /usr/local/bin
│   ├── aaGoMqtt            MQTT publish/subscribe CLI helper
│   └── aaHelp              Print help summary and current MOTD
├── .gitignore              Excludes .env, .pem, and .DS_Store files
├── LICENSE
└── README.md
```

---

## Notes

- This repo has no CI/CD pipeline and no branch protection rules — direct pushes to `main` are fine.
- No secrets or credentials should ever be committed here.
- The `.gitignore` excludes `.env` files, `.pem` files, and `.DS_Store`.

### Why this repo has no branch protection or CI/CD pipeline

MitchellNET service repos — `InternalWebServer`, `bench-instrument-service`, `fitness-tracker`, and others — have branch protection and automated deployment pipelines because a bad push to `main` could immediately break a live service running on the Ubuntu server. The protection rules exist to guard that automated path.

This repo and `mitchellnet-infra` are different: nothing is automatically deployed from them. They are used manually, only when setting up or rebuilding a machine. Branch protection would add friction (required PR, required review) with zero safety benefit, because there is no automated deployment that could go wrong as a result of a direct push.

The rule of thumb for MitchellNET is: **if the repo has a CI/CD pipeline that deploys to the server, it needs branch protection; if it is manual-use only, it does not.**
