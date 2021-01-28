#!/usr/bin/env bash

LEIN_SNAPSHOTS_IN_RELEASE=1 lein with-profiles +native-image "do" clean, uberjar

native-image \
    -jar target/*-standalone.jar \
    -H:Name=clojure-lsp \
    -J-Dclojure.compiler.direct-linking=true \
    -J-Dclojure.spec.skip-macros=true \
    -H:+ReportExceptionStackTraces \
    -H:Log=registerResource: \
    --verbose \
    -H:IncludeResources="db/.*|static/.*|templates/.*|.*.yml|.*.xml|.*/org/sqlite/.*|org/sqlite/.*" \
    -H:ReflectionConfigurationFiles=graalvm/reflection.json \
    -H:DynamicProxyConfigurationFiles=graalvm/proxy.json \
    --initialize-at-build-time  \
    --report-unsupported-elements-at-runtime \
    --allow-incomplete-classpath \
    --no-server \
    --no-fallback \
    # --static \
    # -J-Xmx3g

# GRAAL_VM_DOCKER_IMAGE=springci/graalvm-ce:21.0-dev-java11

# jar=$(ls target/clojure-lsp-*-standalone.jar)

# outfile="/clojure-lsp/$jar"

# args=( "-jar" "$outfile"
#               "-H:Name=/clojure-lsp/clojure-lsp"
#               "-H:+ReportExceptionStackTraces"
#               "-J-Dclojure.spec.skip-macros=true"
#               "-J-Dclojure.compiler.direct-linking=true"
#               "-H:ReflectionConfigurationFiles=/clojure-lsp/graalvm/reflection.json"
#               "-H:DynamicProxyConfigurationFiles=/clojure-lsp/graalvm/proxy.json"
#               "--initialize-at-build-time"
#               # "-H:TraceClassInitialization="
#               "-H:IncludeResources='db/.*|static/.*|templates/.*|.*.yml|.*.xml|.*/org/sqlite/.*|org/sqlite/.*'"
#               "--report-unsupported-elements-at-runtime"
#               "-H:Log=registerResource:"
#               "--initialize-at-run-time=io.netty.util.internal.logging.Log4JLogger"
#               "--allow-incomplete-classpath"
#               "--verbose"
#               "--no-fallback"
#               "--no-server"
#               "--static"
#               "-J-Xmx3g" )

# docker run --rm -v ${PWD}:/clojure-lsp $GRAAL_VM_DOCKER_IMAGE native-image "${args[@]}"
