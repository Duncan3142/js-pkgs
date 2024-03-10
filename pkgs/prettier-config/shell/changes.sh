#!/usr/bin/env bash

OUTPUT_FILE=$1
mkdir -p .tmp
STATUS_FILE=".tmp/$(cat /proc/sys/kernel/random/uuid)"
touch "${STATUS_FILE}"
npm exec changeset -- status --output="${STATUS_FILE}"
RAW_STATUS_JSON=$(cat "${STATUS_FILE}")
rm "${STATUS_FILE}"

read -r -d '' JQ_TRANSFORM << EOF
{
	name: .releases[0].name,
	type: .releases[0].type,
	oldVersion: .releases[0].oldVersion,
	newVersion: .releases[0].newVersion,
	changes: .changesets | map_values({summary: .summary, id: .id})
}
EOF

PENDING_CHANGES_COUNT=$(echo -E "${STATUS_JSON}" | jq -r '.changesets | length')

if [[ $PENDING_CHANGES_COUNT -gt 0 ]]; then
	STATUS_JSON=$(echo -E "${RAW_STATUS_JSON}" | jq "${JQ_TRANSFORM}")
	echo -E "${STATUS_JSON}" > "$OUTPUT_FILE"
	exit 0
else
	exit 1
fi
