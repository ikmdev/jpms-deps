#!/usr/bin/env bash
set -euxo pipefail

## Script useful in testing order of releases

function exec_mvn_build() {
  cd $1
  ../mvnw clean install -Dmaven.build.cache.enabled=false --batch-mode -e \
      -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn

  size=$(find ./target -maxdepth 1 -type f -name '*[!-javadoc][!-sources].jar' -exec jar tf  {} \; | grep -c 'dev.ikm.jpms' | xargs )
  if [ "$size" -lt "2" ]; then
    echo "ERROR: jar does not contain ikmdev packages"
    exit 1
  fi
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

exec_mvn_build guava

# Required for httpmime
exec_mvn_build httpclient

exec_mvn_build httpcore
exec_mvn_build httpmime
exec_mvn_build javax-inject
exec_mvn_build jgit
exec_mvn_build jheaps
exec_mvn_build mvstore

# Required for snorocket
exec_mvn_build ontology-model

exec_mvn_build protobuf-java
exec_mvn_build record-builder-core
exec_mvn_build roaringbitmap
exec_mvn_build snorocket

