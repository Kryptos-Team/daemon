#!/usr/bin/env bash

echo -e "================================="
echo -e "Travis CI Tests"
echo -e "================================="
echo -e ""
echo -e "================================="
echo -e "Bash Analysis Tests"
echo -e "Using: Shellcheck"
echo -e "Testing Branch: $TRAVIS_BRANCH"
echo -e "================================="
echo -e ""
scissues=$(find . -type f  \( -name "*.sh" -o -name "*.cfg" \) -not -path "./shunit2-2.1.6/*" -exec shellcheck --shell=bash --exclude=SC2154,SC2034 {} \; | grep -F -c "^--")
echo -e "Found issues: ${scissues}"
echo -e "================================="
find . -type f  \( -name "*.sh" -o -name "*.cfg" \) -not -path "./shunit2-2.1.6/*" -exec shellcheck --shell=bash --exclude=SC2154,SC2034 {} \;
echo -e ""
echo -e "================================="
echo -e "Bash Analysis Tests - Complete!"
echo -e "Using: Shellcheck"
echo -e "================================="