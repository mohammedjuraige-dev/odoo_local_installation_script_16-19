#!/bin/bash

echo "🚀 Starting Full Odoo 16 Installer on Ubuntu 24.04 or lower..."

# STEP 0: Set variables
ODOO_DIR=~/odoo16
ODOO_SOURCE_DIR=$ODOO_DIR/odoo
VENV_DIR=$ODOO_DIR/odoo16-venv
CONFIG_FILE=$ODOO_SOURCE_DIR/odoo16.conf
LOGFILE=$ODOO_DIR/odoo.log
PORT=8016
DB_USER=odoo16
DB_PASSWORD=12345
ADMIN_PASSWD=admin@123

# STEP 1: Create main folder
echo "📁 Creating project structure..."
mkdir -p "$ODOO_DIR"
mkdir -p "$ODOO_SOURCE_DIR/custom_addons"

# STEP 2: Install system dependencies
echo "📦 Installing system packages..."
sudo apt update && sudo apt install -y \
  git python3.12 python3.12-venv python3.12-dev \
  build-essential wget libpq-dev libxml2-dev libxslt1-dev \
  libjpeg-dev libldap2-dev libsasl2-dev libffi-dev \
  libtiff5-dev libopenjp2-7-dev libssl-dev zlib1g-dev liblcms2-dev \
  libfreetype-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev \
  libpng-dev libblas-dev libatlas-base-dev python3-pip postgresql

# STEP 3: Clone Odoo 16 if needed
if [ -f "$ODOO_SOURCE_DIR/requirements.txt" ] && [ -d "$ODOO_SOURCE_DIR/.git" ]; then
  echo "✔️ Valid Odoo source already present. Skipping clone."
else
  echo "♻️ Existing folder is invalid or incomplete. Re-cloning Odoo 16..."
  rm -rf "$ODOO_SOURCE_DIR"
  git clone --depth 1 --branch 16.0 https://github.com/odoo/odoo.git "$ODOO_SOURCE_DIR"
fi

# STEP 4: Create PostgreSQL user
echo "🛠️ Creating PostgreSQL user '$DB_USER'..."
sudo -u postgres psql -c "DO \$\$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$DB_USER') THEN
    CREATE ROLE $DB_USER WITH LOGIN PASSWORD '$DB_PASSWORD';
  END IF;
END \$\$;"
sudo -u postgres psql -c "ALTER ROLE $DB_USER CREATEDB;"

# STEP 5: Create virtual environment
echo "🐍 Creating virtual environment using Python 3.12..."
python3.12 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"

# STEP 6: Install Python dependencies
if [ -f "$ODOO_SOURCE_DIR/requirements.txt" ]; then
  echo "📦 Installing Python requirements from requirements.txt..."
  pip install --upgrade pip wheel
  pip install -r "$ODOO_SOURCE_DIR/requirements.txt"
else
  echo "⚠️ requirements.txt not found. Skipping Python dependency install."
fi

# STEP 7: Create Odoo configuration file
echo "📝 Creating Odoo configuration file..."
cat <<EOF > "$CONFIG_FILE"
[options]
addons_path = $ODOO_SOURCE_DIR/addons,$ODOO_SOURCE_DIR/custom_addons
admin_passwd = $ADMIN_PASSWD
db_host = localhost
db_port = 5432
db_user = $DB_USER
db_password = $DB_PASSWORD
logfile = $LOGFILE
xmlrpc_port = $PORT
EOF

# STEP 8: Done
echo "✅ Odoo 16 installation complete!"
echo "👉 To run Odoo:"
echo "   cd $ODOO_DIR"
echo "   source odoo16-venv/bin/activate"
echo "   ./odoo/odoo-bin -c ./odoo/odoo16.conf"
mkdir -p "$ODOO_SOURCE_DIR/custom_addons"
