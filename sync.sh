#!/bin/bash

set -e 

if [[ -z $AWS_ACCESS_KEY_ID ]]; then
	echo "AWS creds not set"
	exit 1
fi

if [[ -z $AWS_SECRET_ACCESS_KEY ]]; then
	echo "AWS creds not set"
	exit 1
fi

DISTRIBUTION_ID=E3UDIOR6NZKLQV
BUCKET_NAME=mendydrinks.com-cdn

# Build
hugo -v

# Sync
aws s3 sync --acl "public-read" --sse "AES256" public/ s3://$BUCKET_NAME --exclude 'post'

# Invalidate
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths /index.html / /page/*
