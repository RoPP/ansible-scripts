#!/bin/sh

CRITICAL=$(apt-get upgrade --dry-run -q|grep Inst|grep Security|wc -l)
OUTDATED=$(apt-get upgrade --dry-run -q|grep Inst|grep -v Security|wc -l)

echo "pkg critical=$CRITICAL,outdated=$OUTDATED"
