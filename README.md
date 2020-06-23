# Description

This image was created with the intention of achieving an easier deployment of Schema Registry component on Docker.

# Quick reference

- Maintained by: [General Software Inc Open Projects](https://github.com/General-Software-Inc-Open-Projects/dataries-schema-registry-docker)
- Where to file issues: [GitHub Issues](https://github.com/General-Software-Inc-Open-Projects/dataries-schema-registry-docker/issues)

# What is Spring Cloud Schema Registry?
[Spring Cloud Schema Registry](https://cloud.spring.io/spring-cloud-static/spring-cloud-schema-registry/1.0.0.RC1/reference/html/index.html) is a tool of Spring Framework, that provides support for schema evolution so that the data can be evolved over time and still work with older or newer producers and consumers and vice versa.

# How to use this image

## Start a single node 

~~~bash
docker run -itd --name schema-registry -p 8080:8080 --restart on-failure gsiopen/schema-registry:1.0.0
~~~

## Connect to Schema Registry Server from the command line client

> This image is runned using a non root user `dataries` who owns the `/opt/schema-registry` folder.

~~~bash
docker exec -it schema-registry bash
~~~

## Check logs

By default, Schema Registry redirects stdout/stderr outputs to the console, so you can run the next command to find logs:

~~~bash
docker logs schema-registry
~~~

# Configuration

## Environment variables

The environment configuration is controlled via the following environment variable groups or PREFIX:
   
    SERVER_PORT: affects application-prod.yml
    DB_URI= affects application-prod.yml
    DB_USER= affects application-prod.yml
    DB_PASS= affects application-prod.yml
    
Set environment variables with the appropriated group in the form PREFIX_PROPERTY.

Due to restriction imposed by docker and docker-compose on environment variable names the following substitution are applied to PROPERTY names:

    _ => .
    __ => _
    ___ => -

Following are some illustratory examples:

     SERVER_PORT=5000: sets the server.port property in application-prod.yml
     DB_URI=jdbc:postgresql://postgresql-server:5432/schemas