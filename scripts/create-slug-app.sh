#!/bin/sh
#
# https://devcenter.heroku.com/articles/platform-api-deploying-slugs
#
set -e

# work space
rm -rf slugs/
mkdir slugs
cd slugs

# download the slug from existing app
echo Downloading the slug from exiting app at heroku remote
heroku slugs:download

# create a new app
echo Creating a new app
slug_app=$(heroku create -n --json | jq -r .name)

# publish
echo Publishing the slug to the new app $slug_app
slug_info=$(mktemp)
curl -s -X POST \
-H 'Content-Type: application/json' \
-H 'Accept: application/vnd.heroku+json; version=3' \
-d '{"process_types":{"worker":"/bin/bash -l -c \"ruby wait.rb\""}}' \
-n https://api.heroku.com/apps/$slug_app/slugs > $slug_info
blob_url=$(jq -r .blob.url $slug_info)
slug_id=$(jq -r .id $slug_info)

slug=$(find . -name slug.tar.gz)
curl -X PUT -H "Content-Type:" --data-binary @$slug $blob_url

# release
echo Releasing the app $slug_app
curl -X POST \
-H "Accept: application/vnd.heroku+json; version=3" \
-H "Content-Type: application/json" \
-d '{"slug":"'$slug_id'"}' \
-n https://api.heroku.com/apps/$slug_app/releases

cd ..

echo
echo Created $slug_app and released the slug
