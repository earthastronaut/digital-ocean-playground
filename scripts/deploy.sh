#!/bin/bash

# ---------------------------------------------------------------------------- #
# Parameters
# ---------------------------------------------------------------------------- #

# Directory of this script.
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Secrets which should not be stored in git
# {SECRETS_PATH}
# ├── ssh_remote_host.txt   <- Single line with the ssh <remote_ssh_name>
# └── ssh
#     ├── config            <- SSH config for defining github.com access
#     ├── id_rsa            <- Private github deploy key referenced in config
#     └── id_rsa.pub        <- Public key
SECRETS_PATH="${SCRIPT_PATH}/untracked_production"

# Remote user@host
REMOTE=$(cat ${SECRETS_PATH}/ssh_remote_host.txt)

# Location of the code on remote server
REMOTE_CODE_PATH='/usr/local/src/simple_server'

# ---------------------------------------------------------------------------- #
# Definitions
# ---------------------------------------------------------------------------- #

function run_remote_execute {
    ssh ${REMOTE} $@
}

function run_copy_to_remote {
    echo "scp -r $1 ${REMOTE}:$2"
    scp -r $1 ${REMOTE}:$2
}

function echo_section {
    echo '---------------------'
    echo $1
    echo '---------------------'
}

# ---------------------------------------------------------------------------- #
# Main
# ---------------------------------------------------------------------------- #

set -e

# -------------------------- #
echo_section 'Copy SSH keys'

TMP_SSH_CONFIG_FILE="${SCRIPT_PATH}/untracked_tmp_ssh_config"
cat << EOF > ${TMP_SSH_CONFIG_FILE}
HOST github.com
    AddKeysToAgent yes
    IdentityFile ~/.ssh/digital_ocean_github_deploy_key_rsa.priv
EOF
run_copy_to_remote "${TMP_SSH_CONFIG_FILE}" "~/.ssh/config"
run_copy_to_remote "${SECRETS_PATH}/digital_ocean_github_deploy_key_rsa.priv" "~/.ssh/"
rm ${TMP_SSH_CONFIG_FILE}

# -------------------------- #
echo_section 'Update git repository'

response=$(run_remote_execute "ls ${REMOTE_CODE_PATH}")
if [[ "$response" == "" ]]
then
    run_remote_execute "git clone git@github.com:earthastronaut/digital-ocean-playground.git ${REMOTE_CODE_PATH}"
else
    run_remote_execute "git -C ${REMOTE_CODE_PATH} pull origin master"
fi

# -------------------------- #
echo_section 'Docker-compose magic'

run_remote_execute "docker-compose -f ${REMOTE_CODE_PATH}/docker-compose.yml down"
run_remote_execute "docker-compose -f ${REMOTE_CODE_PATH}/docker-compose.yml up -d"
