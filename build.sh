#!/bin/bash
#
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

# Cockroach Labs fork: build the release binaries with `go build` instead of
# Bazel, adding linux-s390x and linux-ppc64le, which upstream doesn't ship.
#
#   VERSION=v1.30.0-crl.1 ./build.sh
#
# Each binary gets a .sha256 file holding just the digest, as upstream's do.
VERSION=${VERSION:?set VERSION to the release tag}

rm -rf bazelisk bin
mkdir bin

for target in linux/amd64 linux/arm64 linux/s390x linux/ppc64le \
    darwin/amd64 darwin/arm64 windows/amd64 windows/arm64; do
  os=${target%/*}
  arch=${target#*/}
  name=bazelisk-$os-$arch
  if [ "$os" = windows ]; then
    name=$name.exe
  fi
  CGO_ENABLED=0 GOOS=$os GOARCH=$arch go build -trimpath \
    -ldflags "-X github.com/bazelbuild/bazelisk/core.BazeliskVersion=$VERSION" \
    -o "bin/$name"
  shasum -a 256 "bin/$name" | cut -d' ' -f1 > "bin/$name.sha256"
done

### Print some information about the generated binaries.
echo "== Bazelisk binaries are ready =="
ls -lh bin/*
file bin/*
echo
