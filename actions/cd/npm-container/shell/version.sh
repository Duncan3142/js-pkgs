#!/usr/bin/env bash

if [[ -z "${BASE_BRANCH}" ]]; then
	log_error "BASE_BRANCH is not set"
	exit 1
fi

if [[ -z "${SEMVER_BRANCH}" ]]; then
	log_error "SEMVER_BRANCH is not set"
	exit 1
fi

if [[ -z "${REMOTE}" ]]; then
	log_error "REMOTE is not set"
	exit 1
fi

if [[ -z "${CHANGES_FILE}" ]]; then
	log_error "CHANGES_FILE is not set"
	exit 1
fi

# Check if the HEAD is at the base branch
HEAD_SHA=$(git rev-parse HEAD)
BASE_SHA=$(git rev-parse "${BASE_BRANCH}")

if [[ "${HEAD_SHA}" != "${BASE_SHA}" ]]; then
	echo "HEAD is not at ${BASE_BRANCH}"
	echo "HEAD: ${HEAD_SHA}"
	echo "${BASE_BRANCH}: ${BASE_SHA}"
	exit 1
fi

unset HEAD_SHA BASE_SHA

# Checkout SemVer branch from base branch
git checkout -b "${SEMVER_BRANCH}"

make version

# Commit changes
VERSION_UPDATED=false

git add .

if git commit -m "Semver \"${PKG_NAME}\""; then
	VERSION_UPDATED=true
	git push --force-with-lease "${REMOTE}" "${SEMVER_BRANCH}"
fi

# Create PR

if ! PR_URL=$(gh pr create --base "${BASE_BRANCH}" --head "${SEMVER_BRANCH}" --title "SemVer \"${PKG_NAME}\"" --body "This is an auto generated PR to semantically version \"${PKG_NAME}\"" --label ci --label semver); then
	PR_URL=$(gh pr list --base "${BASE_BRANCH}" --head "${SEMVER_BRANCH}" --json url --jq '.[0].url')
	if [ -z "${PR_URL}" ]; then
		echo "Failed to find existing SemVer PR with base \"${BASE_BRANCH}\" and head \"${SEMVER_BRANCH}\""
		exit 1
	fi
fi

# gh pr merge --auto --squash

export VERSION_UPDATED PR_URL
