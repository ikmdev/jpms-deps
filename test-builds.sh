#!/usr/bin/env bash
set -euxo pipefail

## Script useful in testing order of releases

function exec_mvn_build() {
  cd $1
  mvn clean install
  cd ..
}


# Required for activej-bytebuf
exec_mvn_build activej-common

exec_mvn_build activej-bytebuf
exec_mvn_build auto-service
exec_mvn_build bugsplat

# TODO
exec_mvn_build chronicle-map

# Commons Required for hapi projects
exec_mvn_build commons-io
exec_mvn_build commons-lang3
exec_mvn_build commons-text

exec_mvn_build directory-watcher
exec_mvn_build eclipse-collections
exec_mvn_build eclipse-collections-api

# Required for Guava and Hapi projects
exec_mvn_build jsr305

# Required for mutiny and guava
exec_mvn_build smallrye-common-annotation

exec_mvn_build guava

# hapi fhir have to be built in this order
exec_mvn_build hapi-fhir-base
exec_mvn_build hapi-fhir-utilities
exec_mvn_build hapi-fhir-r4
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

exec_mvn_build mutiny
exec_mvn_build mvstore
exec_mvn_build protobuf-java
exec_mvn_build reactive-streams
exec_mvn_build record-builder-core
exec_mvn_build roaringbitmap
exec_mvn_build snorocket

