#!/bin/bash

# enable error reporting to the console
set -e

if [ $TRAVIS_TEST_RESULT = 1 ]; then
    echo "Build failed so exiting"
    exit 0
fi

PR=https://api.github.com/repos/$TRAVIS_REPO_SLUG/pulls/$TRAVIS_PULL_REQUEST
BRANCH=$(if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then echo $TRAVIS_BRANCH; else echo `curl -s $PR | jq -r .head.ref`; fi)

if [ "$BRANCH" = "master" ]; then
  # get the version from the version file
  VERSION_TAG="v`cat VERSION.txt`"

  # check to make sure the tag doesn't already exist
  if ! git rev-parse $VERSION_TAG >/dev/null 2>&1; then
    echo "Creating new tag: $VERSION_TAG"
    git config --global user.email "builds@travis-ci.org"
    git config --global user.name "Travis CI"
    git tag $VERSION_TAG
    git push --quiet https://$GITHUBKEY@github.com/$TRAVIS_REPO_SLUG $VERSION_TAG > /dev/null 2>&1

    curl -s -X POST \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -H "Travis-API-Version: 3" \
      -H "Authorization: token $TRAVISKEY" \
      -d '{ "request": { "branch":"master" }}' https://api.travis-ci.org/repo/lccgov%2Flcc_sharepoint_toolkit_npm/requests
  fi
fi