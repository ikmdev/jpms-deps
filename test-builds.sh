#!/usr/bin/env bash
set -euxo pipefail

## Script useful in testing order of releases

function exec_mvn_build() {
  cd $1
  mvn clean install -Dmaven.build.cache.enabled=false --batch-mode -e \
      -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn
  cd ..
}


# Required for activej-bytebuf
exec_mvn_build activej-common

exec_mvn_build activej-bytebuf
exec_mvn_build auto-service
exec_mvn_build bugsplat

exec_mvn_build directory-watcher

# Required for Eclipse collections
exec_mvn_build eclipse-collections-api
exec_mvn_build eclipse-collections

# Required for Guava and Hapi projects
exec_mvn_build jsr305

# Required by hapi-fhir-base
exec_mvn_build guava

# required by all hapi-fhir projects
exec_mvn_build hapi-fhir-base

# Required by hapi-fhir-structures-r4
exec_mvn_build hapi-fhir-utilities

# Required by hapi-fhir-structures-r4
exec_mvn_build hapi-fhir-r4

# Required by hapi-fhir-structures-r4
exec_mvn_build hapi-fhir-caching-api

exec_mvn_build hapi-fhir-structures-r4

# Required for httpmime
exec_mvn_build httpclient

exec_mvn_build httpcore
exec_mvn_build httpmime
exec_mvn_build javax-inject
exec_mvn_build jgit
exec_mvn_build jheaps

# Required for snorocket
exec_mvn_build ontology-model

exec_mvn_build protobuf-java
exec_mvn_build record-builder-core
exec_mvn_build roaringbitmap
exec_mvn_build snorocket

