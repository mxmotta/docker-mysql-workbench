#!/bin/sh

eval "$(dbus-launch --sh-syntax)" && \
mkdir -p ~/.cache && \
mkdir -p ~/.local/share/keyrings && \
eval "$(printf '\n' | gnome-keyring-daemon --unlock)" && \
eval "$(printf '\n' | /usr/bin/gnome-keyring-daemon --start)"

if [ -n "${XDG_RUNTIME_DIR}" ]; then
  GNOME_KEYRING_CONTROL="${XDG_RUNTIME_DIR}/keyring/control"
  [ -z "${GNOME_KEYRING_CONTROL}" ] || export GNOME_KEYRING_CONTROL
fi
/usr/bin/mysql-workbench ${@}