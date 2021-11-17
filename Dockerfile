FROM maven:3.6.0-jdk-11-slim AS base
WORKDIR /app

COPY ./ ./

FROM base AS test
RUN mvn test

FROM base AS build
RUN mvn package

FROM openjdk:11-jre-slim AS prod
EXPOSE 8080

COPY --from=build /app/target/spring-petclinic-*.jar /app.jar

CMD ["java","-jar","/app.jar"]