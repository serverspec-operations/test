#!/bin/bash

curl -s \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/serverspec-operations/test/pulls?per_page=100"

get_prs() {
  curl -s \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/serverspec-operations/test/pulls?per_page=100" |
    jq '.[] | .number'
}

while read -r pr_number; do
  echo "===> Upate pr/${pr_number} branch" >&2
  gh api -X PUT "repos/{owner}/{repo}/pulls/${pr_number}/update-branch"
done < <(get_prs)
