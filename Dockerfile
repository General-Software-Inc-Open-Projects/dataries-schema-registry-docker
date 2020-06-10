FROM maven:3-jdk-11 as maven

ARG ARTIFACT_NAME=net.gsi.connectors:dataries-schema-registry-connector
ARG ARTIFACT_VERSION=1.0.0
ARG GITHUB_TOKEN

COPY settings.xml ./settings.xml
RUN ls -lt

RUN sed -i "s|GITHUB_TOKEN|$GITHUB_TOKEN|" settings.xml

RUN cat settings.xml

RUN mvn dependency:copy -Dartifact=${ARTIFACT_NAME}:${ARTIFACT_VERSION} \
                        -DoutputDirectory=. \
                        -gs settings.xml

FROM openjdk:11-jre-slim
LABEL version="gsi"
LABEL maintainer="Dania Rojas<dania.rojas@generalsoftwareinc.com>"


ENV SCHEMA_REGISTRY_HOME=/opt/schema-registry

RUN useradd -lrmU dataries

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        curl && \
    apt-get autoremove --yes && \
    apt-get clean

USER dataries

WORKDIR ${SCHEMA_REGISTRY_HOME}

COPY --chown=dataries:dataries --from=maven dataries-schema-registry-connector-1.0.0.jar \
                               ${SCHEMA_REGISTRY_HOME}

COPY --chown=dataries:dataries healthcheck.sh entrypoint.sh /usr/bin/

ENTRYPOINT entrypoint.sh

HEALTHCHECK --interval=30s --timeout=15s --start-period=60s \
    CMD healthcheck.sh

EXPOSE 5000
