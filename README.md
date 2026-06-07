# Odoo Local Installation Scripts (Odoo 16, 17, 18 & 19)

Automated Bash scripts for installing and configuring Odoo locally on Ubuntu 24.04 (and compatible Ubuntu-based distributions).

These scripts automate:

* System dependency installation
* PostgreSQL setup
* Odoo source code download
* Python virtual environment creation
* Python package installation
* Odoo configuration file generation
* Custom addons directory creation

---

# Supported Versions

| Odoo Version | Script                          |
| ------------ | ------------------------------- |
| Odoo 16      | `odoo16_install_with_config.sh` |
| Odoo 17      | `odoo17_install_with_config.sh` |
| Odoo 18      | `odoo18_install_with_config.sh` |
| Odoo 19      | `odoo19_install_with_config.sh` |

---

# Requirements

* Ubuntu 24.04 LTS
* Ubuntu 22.04 LTS
* Ubuntu-based Linux distributions
* Sudo privileges
* Internet connection

---

# Repository Structure

```text
Script files for odoo installation/
├── script for odoo16 in Ubuntu 24.04 and lower/
│   └── odoo16_install_with_config.sh
├── script for odoo17 in Ubuntu 24.04 and lower/
│   └── odoo17_install_with_config.sh
├── script for odoo18 in Ubuntu 24.04 and lower/
│   └── odoo18_install_with_config.sh
└── script for odoo19 in Ubuntu 24.04 and lower/
    └── odoo19_install_with_config.sh
```

---

# Installation

## 1. Clone Repository

```bash
git clone https://github.com/mohammedjuraige-dev/odoo_local_installation_script_16-19.git
cd odoo_local_installation_script_16-19
```

---

## 2. Make Script Executable

Example for Odoo 19:

```bash
chmod +x "Script files for odoo installation/script for odoo19 in Ubuntu 24.04 and lower/odoo19_install_with_config.sh"
```

---

## 3. Run Script

Example for Odoo 19:

```bash
./"Script files for odoo installation/script for odoo19 in Ubuntu 24.04 and lower/odoo19_install_with_config.sh"
```

Or:

```bash
bash "Script files for odoo installation/script for odoo19 in Ubuntu 24.04 and lower/odoo19_install_with_config.sh"
```

---

# Default Configuration

The scripts automatically create:

```text
~/odooXX/
```

Example:

```text
~/odoo19/
├── odoo/
├── custom_addons/
├── odoo.log
└── odoo19-venv/
```

Default values:

| Setting           | Example Value |
| ----------------- | ------------- |
| Database User     | `odoo19`      |
| Database Password | `12345`       |
| Admin Password    | `admin@123`   |
| Odoo Port         | `8019`        |

You can modify these values directly inside the script before running it.

---

# Starting Odoo

Activate the virtual environment:

```bash
cd ~/odoo19
source odoo19-venv/bin/activate
```

Start Odoo:

```bash
cd ~/odoo19/odoo
python3 odoo-bin -c odoo19.conf or ./odoo-bin -c odoo19.conf
```

---

# Access Odoo

Open your browser:

```text
http://localhost:8019
```

For remote servers:

```text
http://SERVER-IP:8019
```

---

# Troubleshooting

### PostgreSQL Connection Issues

Verify PostgreSQL is running:

```bash
sudo systemctl status postgresql
```

Restart PostgreSQL:

```bash
sudo systemctl restart postgresql
```

---

### Python Dependency Issues

Upgrade pip:

```bash
pip install --upgrade pip wheel setuptools
```

---

### Port Already In Use

Check:

```bash
sudo ss -tulpn | grep 8019
```

Change the port value in the script and rerun.

---

# Notes

* These scripts are intended for local development and testing environments.
* Review passwords and configuration values before deploying to production.
* Production deployments should use proper security hardening, backups, SSL, and dedicated service management.

---

# Author

**Mohammed Juraige**

GitHub: https://github.com/mohammedjuraige-dev




---


# Screenshot


<img width="1863" height="923" alt="11" src="https://github.com/user-attachments/assets/7858345f-7db6-479f-bf9a-d86f5cce1094" />
