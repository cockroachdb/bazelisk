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

### Build release artifacts using Bazel.
rm -rf bazelisk bin
mkdir bin

### Build release artifacts using `go build`.
GOOS=linux GOARCH=amd64 go build -o bin/bazelisk-linux-amd64
GOOS=linux GOARCH=arm64 go build -o bin/bazelisk-linux-arm64
GOOS=linux GOARCH=s390x go build -o bin/bazelisk-linux-s390x
GOOS=darwin GOARCH=amd64 go build -o bin/bazelisk-darwin-amd64
GOOS=darwin GOARCH=arm64 go build -o bin/bazelisk-darwin-arm64
GOOS=windows GOARCH=amd64 go build -o bin/bazelisk-windows-amd64.exe
GOOS=windows GOARCH=arm64 go build -o bin/bazelisk-windows-arm64.exe

### Print some information about the generated binaries.
echo "== Bazelisk binaries are ready =="
ls -lh bin/*
file bin/*
echo
