#!/bin/sh
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
set -x

# Tear down
docker rm -f aac-tests || true

# Set up
docker run -id --name aac-tests alpine 
docker exec -i aac-tests apk add curl jq
docker cp . aac-tests:/root

# First time token
docker exec -e APIGEE_USER -e APIGEE_PASS -i aac-tests sh /root/token

# Second time token
docker exec -e APIGEE_USER -e APIGEE_PASS -i aac-tests sh /root/token

# Expired access token
docker exec -e APIGEE_USER -e APIGEE_PASS -i aac-tests sh /root/test/inject-expired-token.sh access
docker exec -e APIGEE_USER -e APIGEE_PASS -i aac-tests sh /root/token

echo "Tests passed"
