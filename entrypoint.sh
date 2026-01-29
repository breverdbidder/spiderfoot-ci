#!/bin/bash
set -e

# SpiderFoot CI Entrypoint Script
# Configures authentication and API keys from environment variables

CONFIG_DIR="/data/spiderfoot"
CONFIG_FILE="${CONFIG_DIR}/SpiderFoot.cfg"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Generate SpiderFoot config with API keys
cat > "$CONFIG_FILE" << EOF
[GlobalConfig]
# Database location
__database = ${CONFIG_DIR}/spiderfoot.db

# Authentication
__webauth_enabled = True
__webauth_username = ${SF_USERNAME:-admin}
__webauth_password = ${SF_PASSWORD:-changeme}

# API Keys - Free Tiers
[sfp_shodan]
api_key = ${SHODAN_API_KEY:-}

[sfp_censys]
api_id = ${CENSYS_API_ID:-}
api_secret = ${CENSYS_API_SECRET:-}

[sfp_virustotal]
api_key = ${VIRUSTOTAL_API_KEY:-}

[sfp_hunter]
api_key = ${HUNTER_API_KEY:-}

[sfp_securitytrails]
api_key = ${SECURITYTRAILS_API_KEY:-}

[sfp_haveibeenpwned]
api_key = ${HIBP_API_KEY:-}

[sfp_fullcontact]
api_key = ${FULLCONTACT_API_KEY:-}

[sfp_ipinfo]
api_key = ${IPINFO_API_KEY:-}

[sfp_greynoise]
api_key = ${GREYNOISE_API_KEY:-}

[sfp_binaryedge]
api_key = ${BINARYEDGE_API_KEY:-}
EOF

echo "SpiderFoot configuration generated at ${CONFIG_FILE}"
echo "Authentication: ${SF_USERNAME:-admin}"
echo "Starting SpiderFoot..."

# Start SpiderFoot
cd /opt/spiderfoot
exec python3 sf.py -l 0.0.0.0:5001 -c "${CONFIG_FILE}"
