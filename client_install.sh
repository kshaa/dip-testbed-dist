#!/usr/bin/env bash

# Hardcoded config
TARGET_ARCH="amd64" # Hardcoded
DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
DIP_BIN_DIR="${DATA_HOME}/dip_platform/bin"
DIP_CLIENT_BIN="${DIP_BIN_DIR}/dip_client"
DIP_LATEST_URL="https://github.com/kshaa/dip-testbed-dist/releases/latest/download/dip_client_${TARGET_ARCH}"
DEFAULT_TESTBED_STATIC_URL="http://testbed.veinbahs.lv"
DEFAULT_TESTBED_CONTROL_URL="ws://testbed.veinbahs.lv"

# Download binary
echo "Creating '${DIP_BIN_DIR}' to store DIP platform binaries"
mkdir -p "${DIP_BIN_DIR}"
echo "Downloading latest DIP binary from '${DIP_LATEST_URL}'"
curl -L "${DIP_LATEST_URL}" > "${DIP_CLIENT_BIN}"
chmod +x "${DIP_CLIENT_BIN}"

# Append binary to profile
PROFILE="${HOME}/.bashrc"
PROFILE_MARKER="DIPPLATFORM"
if grep -q "${PROFILE_MARKER}" "${PROFILE}"; then
    echo "DIP platform binaries already added to path, not adding again"
else
    echo "DIP platform binaries not added to path, adding to profile"
    echo "export PATH=\"${DIP_BIN_DIR}:\${PATH}\" # ${PROFILE_MARKER}" >> ${PROFILE}
    ${DIP_CLIENT_BIN} session-static-server -s "${DEFAULT_TESTBED_STATIC_URL}"
    ${DIP_CLIENT_BIN} session-control-server -c "${DEFAULT_TESTBED_CONTROL_URL}"
fi

# Starting a new shell w/ profile
echo "Restart your shell to use 'dip_client' by running the following:"
echo "bash"
