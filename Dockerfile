FROM ghcr.io/graalvm/native-image-community:21 AS builder

# Install tar and gzip to extract the Maven binaries
RUN microdnf install --nodocs \
    unzip \
    findutils \
 && microdnf clean all \
 && rm -rf /var/cache/yum

ENV GRADLE_VERSION=8.4

RUN curl -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o /tmp/gradle-${GRADLE_VERSION}-bin.zip \
    && unzip /tmp/gradle-${GRADLE_VERSION}-bin.zip -d /tmp \
    && mv /tmp/gradle-${GRADLE_VERSION} /opt/gradle \
    && rm /tmp/gradle-${GRADLE_VERSION}-bin.zip


ENV GRADLE_HOME=/opt/gradle/latest
ENV PATH=${GRADLE_HOME}/bin:${PATH}

WORKDIR /app

# Copy your application code into the container (if needed)
COPY . /app

# Build
RUN ./gradlew nativeCompile

RUN cp /app/build/native/nativeCompile/whiz_eureka /home/

RUN rm -rf /app

EXPOSE 8761
ENTRYPOINT ["/home/whiz_eureka"]
