#!/bin/bash
set -o pipefail
echo "##### Shared Resources: "
printf 'Branch: ' && git rev-parse --abbrev-ref HEAD && git log --pretty=format:'Commit: %s - %h ' -n 1
echo ""
echo "##### Core: "
cd ../AnylineCore && printf 'Branch: ' && git rev-parse --abbrev-ref HEAD && git log --pretty=format:'Commit: %s - %h ' -n 1
