FROM openjdk:11-jre-slim
LABEL version="gsi"
LABEL maintainer="Dania Rojas<dania.rojas@generalsoftwareinc.com>"


ARG ARTIFACT_VERSION=1.0.0

ENV SCHEMA_REGISTRY_HOME=/opt/schema-registry

RUN mvn dependency:get -DrepoUrl=https://maven.pkg.github.com/general-software-inc-open-projects/dataries-schema-registry-connector \
    -Dartifact=net.gsi.connectors:dataries-schema-registry-connector:${ARTIFACT_VERSION} \
    -DoutputDirectory=. 

RUN useradd -lrmU dataries

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        curl && \
    apt-get autoremove --yes && \
    apt-get clean

USER dataries

WORKDIR ${SCHEMA_REGISTRY_HOME}

COPY --chown=dataries:dataries dataries-schema-registry-connector-1.0.0.jar \
                               ${SCHEMA_REGISTRY_HOME}

COPY --chown=dataries:dataries healthcheck.sh entrypoint.sh /usr/bin/

ENTRYPOINT entrypoint.sh

HEALTHCHECK --interval=30s --timeout=15s --start-period=60s \
    CMD healthcheck.sh

EXPOSE 5000
