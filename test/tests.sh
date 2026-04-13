#!/bin/sh
set -eu
EXPECT=hello

echo "====="
echo "Should support local port mapping out of the box"
ACTUAL=$(ssh -L 8080:app:5678 -N bastion@bastion-ootb -p 2222 && curl localhost:8080)
echo "Expect: ${EXPECT}"
echo "Actual: ${ACTUAL}"

echo "====="
echo "Should support socks proxy out of the box"
ACTUAL=$(ssh -D 1080 -N bastion@bastion-ootb -p 2222 && curl -x socks5h://localhost:1080 http://app:5678)
echo "Expect: ${EXPECT}"
echo "Actual: ${ACTUAL}"

echo "====="
echo "Should deny terminal access out of the box"
ACTUAL=$(ssh bastion@bastion-ootb -p 2222 echo failed || echo passed)
echo "Expect: passed"
echo "Actual: ${ACTUAL}"

echo "====="
echo "Should support hardening"
ACTUAL=$(ssh -L 8080:app:5678 -N bastion@bastion-hardened -p 2222 && curl localhost:8080)
echo "Expect: ${EXPECT}"
echo "Actual: ${ACTUAL}"
