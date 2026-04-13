#!/bin/sh
set -eu
EXPECT=hello

# The OOTB example uses host key generation at runtime, thus we need to skip host key checking.
# This is not required in actual usage, as the user can simply save the host key in known_hosts on first connection.
ssh_ootb() {
	echo "ssh -o 'StrictHostKeyChecking=no' -o 'UserKnownHostsFile=/dev/null' bastion@bastion-ootb -p 2222 $1"
}

# Run ssh command in background and kill it after test
run_ssh_test() {
	SSH_CMD="$1"
	TEST_CMD="$2"

    eval "$SSH_CMD -N &"
    SSH_PID=$!
    trap "kill $SSH_PID" EXIT
    sleep 2

    eval "$TEST_CMD"

    kill $SSH_PID
    trap - EXIT
}

echo "====="
echo "Should support local port mapping out of the box"
ACTUAL=$(run_ssh_test "$(ssh_ootb "-L 8080:app:5678")" "curl http://localhost:8080")
echo "Expect: ${EXPECT}"
echo "Actual: ${ACTUAL}"
[ "${ACTUAL}" = "${EXPECT}" ]

echo "====="
echo "Should support socks proxy out of the box"
ACTUAL=$(run_ssh_test "$(ssh_ootb "-D 1080")" "curl -x socks5h://localhost:1080 http://app:5678")
echo "Expect: ${EXPECT}"
echo "Actual: ${ACTUAL}"
[ "${ACTUAL}" = "${EXPECT}" ]

echo "====="
echo "Should deny terminal access out of the box"
ACTUAL=$(eval "$(ssh_ootb "echo failed")" || echo passed)
echo "Expect: passed"
echo "Actual: ${ACTUAL}"
[ "${ACTUAL}" = "passed" ]

echo "====="
echo "Should support hardening"
ACTUAL=$(run_ssh_test "ssh -L 8080:app:5678 bastion@bastion-hardened -p 2222" "curl http://localhost:8080")
echo "Expect: ${EXPECT}"
echo "Actual: ${ACTUAL}"
[ "${ACTUAL}" = "${EXPECT}" ]
