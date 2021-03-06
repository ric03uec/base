#!/bin/bash -e

_validate_state() {
  local state=$(cat $STATE_FILE | jq '.')

  local release=$(echo $state | jq '.release')
  if [ -z "$release" ]; then
    echo "Invalid state.json, missing field: release"
    exit 1
  fi
}

_update_state() {
  local updated_state="$1"
  local state_backup="$USR_DIR/state.json.backup"

  cp $STATE_FILE $state_backup

  local updated_state_pretty=$(echo $updated_state | jq '.' | tee $STATE_FILE)

  _validate_state
}

_update_release() {
  local release="$1"
  local update=$(cat $STATE_FILE \
    | jq '.release="'$release'"')
  _update_state "$update"
}
