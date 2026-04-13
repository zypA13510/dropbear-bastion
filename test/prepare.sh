#!/bin/sh
# This script prepares the test environment before running the tests.
UID_DEFAULT=102222
UID_CUSTOM=12345

# Dropbear requires host_key and authorized_keys to only be readable by user.
chown -R ${UID_DEFAULT} config/
chmod -R u=rwX,go= config/
# Hardened instance uses custom UID. Also removes write access to be immutable.
chown -R ${UID_CUSTOM} config2/
chmod -R u=rX,go= config2/
chmod 644 passwd

# Use the command below to start the tests
# docker compose up --exit-code-from test-runner
