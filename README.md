# jpms-deps

jpms-deps is an internal JPMS-compliant library which makes non-JPMS compliant modules accessible to Komet and Tinkar Core.

### Team Ownership - Product Owner
Automation Team

## Getting Started

Follow the instructions below to set up the local environment for `jpms-deps`:

1. Download and install Open JDK Java 21

2. Download and install Apache Maven 3.9 or greater

3. Prior to building jpms-deps, this repository requires access to the Java parent artifact

4. This repository must be built in a specific order, so closely adhere to the instructions below to prevent errors

## Building and Running Tinkar Core

Follow the steps below to build and run `jpms-deps` on your local machine:

1. Clone the [jpms-deps repository](https://github.com/ikmdev/jpms-deps) from GitHub to your local machine

2. Change local directory to location to `jpms-deps`

3. Build each folder individually using the following command:

```bash
mvn -f [Folder Name] clean install
```

 Adhere to the following folder list for build order:

activej-common
activej-bytebuf
auto-service
caffeine
eclipse-collections-api
eclipse-collections
guava
javax-inject
jheaps
jsr305
lucene-core
lucene-memory
lucene-queries
lucene-highlighter
lucene-queryparser
lucene-sandbox
lucene-uber
reactive-streams
smallrye-common-annotation
mutiny
mvstore
ontology-model
protobuf-java
record-builder-core
roaringbitmap
snorocket
chronicle-map

## Issues and Contributions
Technical and non-technical issues can be reported to the [Issue Tracker](https://github.com/ikmdev/jpms-deps/issues).

Contributions can be submitted via pull requests. Please check the [contribution guide](doc/how-to-contribute.md) for more details.

