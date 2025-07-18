#!/bin/bash -ie
#Note - ensure that the -e flag is set to properly set the $? status if any command fails

# Copyright Elasticsearch B.V. and/or licensed to Elasticsearch B.V. under one
# or more contributor license agreements. Licensed under the Elastic License;
# you may not use this file except in compliance with the Elastic License.

# Since we are using the system jruby, we need to make sure our jvm process
# uses at least 1g of memory, If we don't do this we can get OOM issues when
# installing gems. See https://github.com/elastic/logstash/issues/5179
export JRUBY_OPTS="-J-Xmx1g"
export GRADLE_OPTS="-Xmx4g -Dorg.gradle.jvmargs=-Xmx4g -Dorg.gradle.daemon=false -Dorg.gradle.logging.level=info"
export CI=true

if [ -n "$BUILD_JAVA_HOME" ]; then
  GRADLE_OPTS="$GRADLE_OPTS -Dorg.gradle.java.home=$BUILD_JAVA_HOME"
  export LS_JAVA_HOME="$BUILD_JAVA_HOME"
fi

# Option for running in fedramp high mode
FEDRAMP_FLAG="${FEDRAMP_HIGH_MODE/#/-PfedrampHighMode=}"

./gradlew runXPackIntegrationTests $FEDRAMP_FLAG
