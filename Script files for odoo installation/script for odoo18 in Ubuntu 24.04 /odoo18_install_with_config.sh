#!/bin/bash

echo "🚀 Starting Full Odoo 18 Installer on Ubuntu..."

# STEP 0: Set variables
ODOO_DIR=~/odoo18
ODOO_SOURCE_DIR=$ODOO_DIR/odoo
VENV_DIR=$ODOO_DIR/odoo18-venv
CONFIG_FILE=$ODOO_SOURCE_DIR/odoo18.conf
LOGFILE=$ODOO_DIR/odoo.log
PORT=8018
DB_USER=odoo18
DB_PASSWORD=12345
ADMIN_PASSWD=admin@123

# STEP 1: Create folders
echo "📁 Creating folders..."
mkdir -p "$ODOO_DIR" "$ODOO_SOURCE_DIR/custom_addons"

# STEP 2: Install system dependencies
echo "📦 Installing system packages..."
sudo apt update && sudo apt install -y \
  git python3 python3-venv python3-dev \
  build-essential wget curl libpq-dev libxml2-dev libxslt1-dev \
  libjpeg-dev libldap2-dev libsasl2-dev libffi-dev libtiff5-dev \
  libopenjp2-7-dev libssl-dev zlib1g-dev liblcms2-dev \
  libfreetype-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev \
  libpng-dev libblas-dev libatlas-base-dev python3-pip postgresql

# STEP 3: Clone Odoo 18 source (remove old if exists)
if [ -d "$ODOO_SOURCE_DIR" ]; then
    echo "⚠️ Removing existing $ODOO_SOURCE_DIR folder for fresh clone..."
    rm -rf "$ODOO_SOURCE_DIR"
fi
echo "⬇️ Cloning Odoo 18 (branch 18.0) from GitHub..."
git clone --depth 1 --branch 18.0 https://github.com/odoo/odoo.git "$ODOO_SOURCE_DIR"

# STEP 4: Create PostgreSQL user (if not exists)
echo "🛠️ Creating PostgreSQL user '$DB_USER' (if not exists)..."
if sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'" | grep -q 1; then
    echo "User '$DB_USER' already exists, skipping creation."
else
    sudo -u postgres psql -c "CREATE ROLE $DB_USER WITH LOGIN PASSWORD '$DB_PASSWORD';"
    sudo -u postgres psql -c "ALTER ROLE $DB_USER CREATEDB;"
fi

# STEP 5: Create and activate virtual environment
echo "🐍 Creating Python virtual environment..."
python3 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"

# STEP 6: Install Python dependencies
REQ_FILE="$ODOO_SOURCE_DIR/requirements.txt"
if [ -f "$REQ_FILE" ]; then
    echo "📦 Installing Python dependencies from requirements.txt..."
    pip install --upgrade pip wheel setuptools
    pip install -r "$REQ_FILE"
else
    echo "⚠️ requirements.txt not found, installing default dependencies..."
    pip install --upgrade pip wheel setuptools
    pip install Babel decorator docutils ebaysdk gevent greenlet html2text Jinja2 libsass lxml Mako MarkupSafe num2words ofxparse passlib Pillow polib psutil psycopg2-binary pydot pyparsing PyPDF2 pyserial python-dateutil python-stdnum pytz PyYAML qrcode reportlab requests six vatnumber
fi

# STEP 7: Create config file
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
echo "✅ Odoo 18 installation complete!"
echo "👉 To run Odoo 18:"
echo "   cd $ODOO_DIR"
echo "   source odoo18-venv/bin/activate"
echo "   ./odoo/odoo-bin -c ./odoo/odoo18.conf"
mkdir -p "$ODOO_SOURCE_DIR/custom_addons"

wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb

sudo apt update
sudo dpkg -i wkhtmltox_0.12.6.1-3.jammy_amd64.deb
