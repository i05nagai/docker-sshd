#!/bin/sh

set -x

readonly PATH_TO_HOME_BASE=/srv/volume/home
readonly PATH_TO_SUPERVISOR_BASE=/srv/volume/supervisor.d

# addusers <first uid> <shell> <github>:[shell]
addusers() {
  local FIRSTUID=$1
  shift
  local DEFAULT_SHELL=$1
  shift
  for u in "$@"; do
    USER=$(echo $u | cut -d : -f 1)
    USER_SHELL=$(echo $u | cut -d : -f 2)
    ADDUSER_ARGS=""
    UID=""
    GID=""

    # home directory for user is already exists
    if test -d "$PATH_TO_HOME_BASE/$USER"; then
      UID=$(/bin/ls -nld $PATH_TO_HOME_BASE/$USER | cut -d' ' -f3)
      GID=$(/bin/ls -nld $PATH_TO_HOME_BASE/$USER | cut -d' ' -f4)

      addgroup --gid $GID $USER
      ADDUSER_ARGS="--uid $UID --gid $GID"
    fi

    HOME=$PATH_TO_HOME_BASE/$USER

    adduser $USER --firstuid $FIRSTUID --shell ${USER_SHELL:-$DEFAULT_SHELL} --home $HOME $ADDUSER_ARGS < /dev/null

    if test "x$UID" = "x"; then
      UID=$(/bin/ls -nld $HOME | cut -d' ' -f3)
      GID=$(/bin/ls -nld $HOME | cut -d' ' -f4)
    fi

    # Adds ssh keys
    install -m 700 -o $UID -g $GID -d $HOME/.ssh/
    curl -o $HOME/.ssh/authorized_keys https://github.com/$USER.keys
    chown $UID:$GID $HOME/.ssh/authorized_keys
    chmod 600 $HOME/.ssh/authorized_keys

  done
}

# create logs
install -d /opt/sshd/log

addusers 1000 /bin/bash $HOME_USERS

cat >> /etc/profile.d/home.sh <<EOF
export DOCKER_HOST=$DOCKER_HOST
EOF

grep "^. /etc/bash_completion" /etc/bash.bashrc > /dev/null || cat >> /etc/bash.bashrc <<EOF
. /etc/bash_completion
EOF

for u in $HOME_SUDOERS; do
  cat >> /etc/sudoers.d/home <<EOF
$u ALL=(ALL:ALL) NOPASSWD:ALL
EOF
done

install -d $PATH_TO_SUPERVISOR_BASE

rmdir /home
ln -sfT $HOME_BASEDIR /home

if test "x$1" = "x"; then
  exec /bin/bash
else
  exec "$@"
fi
