#!/usr/bin/env bash

# 1. GET /repos/:owner/:repo/keys
# 2. Check if title=... key exists
# 3. If exists, exit 0
# 4. Else, POST /repos/:owner/:repo/keys
        # curl https://api.github.com/...
        # -H "Accept: application/vnd.github.v3+json"
        # -u "{github name}:{cat secret-password.txt}"
        # parse response with 'jr'
                # curl ... | jr '.[0] | .title" << gets you the title of the first object in the array response
