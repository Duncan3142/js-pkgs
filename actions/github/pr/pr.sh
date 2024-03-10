#!/usr/bin/env bash

VERSION_UPDATED=false

git add .

HEAD_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if git commit -m "Semver \"${PKG_NAME}\""; then
	VERSION_UPDATED=true
	git push --force-with-lease "${REMOTE}" "${HEAD_BRANCH}"
fi

if ! PR_URL=$(gh pr create --base "${BASE_BRANCH}" --title "SemVer \"${PKG_NAME}\"" --body "This is an auto generated PR to semantically version \"${PKG_NAME}\"" --label bot --label semver); then
	PR_URL=$(gh pr list --base "${BASE_BRANCH}" --head "${HEAD_BRANCH}" --json url --jq '.[0].url')
	if [ -z "${PR_URL}" ]; then
		echo "Failed to find existing SemVer PR with base \"${BASE_BRANCH}\" and head \"${HEAD_BRANCH}\""
		exit 1
	fi
fi

# gh pr merge --auto --squash

export VERSION_UPDATED PR_URL
