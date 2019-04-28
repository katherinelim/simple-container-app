# simple-container-app
[![Build Status](https://travis-ci.org/katherinelim/simple-container-app.svg?branch=master)](https://travis-ci.org/katherinelim/simple-container-app)

Simple-container-app provides a basic code repository for a containerised
application with a `/healthcheck` endpoint.

It's implemented in Ruby, Sinatra and uses Docker for a development environment.
Using Sinatra, web applications can be created in Ruby quickly.

## Usage

Clone this repository and use it to kick off your own project.

## What it provides

This repository provides code for a a containerised application with
a single `/healthcheck` endpoint and a pipeline configuration to test,
build and publish the application as a Docker image.

### The application

A simple Ruby application using Sinatra is provided in the file `server.rb`.

It has a `/healthcheck` endpoint which returns the following response:

```JSON
{
  "myapplication": [
    {
      "version": "1.0",
      "description": "Simple Container Application",
      "lastcommitsha": "e503e014bcbc8083714eca565930ba5843a11a6e"
    }
  ]
}
```

It has a `/` endpoint which returns the following message:

```JSON
{
  "message": "Hello World"
}
```

Any other endpoints will return the default Sinatra 404 page.

### Pipeline

The pipeline uses [Travis CI](https://travis-ci.com).

There are 4 stages:

1. Test code quality.
2. Run tests.
3. Build the project.
4. Publish the Docker image to Docker Hub.

## Docker Image

The Docker image is published at [Docker Hub](https://hub.docker.com) as
[`katdockero/simple-container-app`](https://hub.docker.com/r/katdockero/simple-container-app).

## Deployment Steps

To deploy the Docker image of this project to your own computer:

1. Ensure that Docker is installed.
2. Sign in to Docker Hub.
3. Pull the image - `docker pull katdockero/simple-container-app:latest`
4. Run the container - `docker run -it --rm -p 5000:5000 katdockero/simple-container-app:latest`
5. Check the output - browse to http://127.0.0.1:5000/healthcheck or run `curl -s http://127.0.0.1:5000/healthcheck` ( `|jq` for formatting)

This project could be deployed to a cloud service like Amazon ECS with CodePipeline.
The example at https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-cd-pipeline.html
describes the following steps to configure Continuous Deployment:

1. Add a Build Specification File to Your Source Repository.
2. Create Your Continuous Deployment Pipeline.
3. Add Amazon ECR Permissions to the CodeBuild Role.
4. Test Your Pipeline.

## Development Notes

`appmeta.yml`

YAML configuration file for `sinatra/config_file` to read in the values for `Version` and `Description`.

This file should be updated manually.

`SHA_HEAD.yml`

This is a temporary file which is used to store the output of `auto/save-sha-head`. It's in `.gitignore`.

`.rspec`

Configuration file for RSpec.

`app/server.rb`

A small REST micro service application written in Ruby with Sinatra.

`bin/run-server`

After running `auto/dev-environment`, run `bin/run-server` to start the web server.

`bin/run-image`

This is a convenient script to run the application's Docker container. The image must be supplied as a parameter, e.g., `bin/run-image 4ee5dbce45d3`

`auto/test`

Runs the code tests using RSpec in the `dev-environment`.

`auto/dev-environment`

Runs a Ruby Docker Container with the application code and starts on a shell prompt.

It uses `sinatra/reloader` so any saved code changes will reload the application in this environment.
There should be no need to restart the web server.

`auto/get-version`

Returns the `version:` value from `appmeta.yml`.

`auto/publish`

Uploads the Docker image to Docker Hub.

`auto/rake-test`

Runs `bundle exec rake`.

`auto/build`

Builds and tags the Docker image.

`auto/save-sha-head`

Saves the output of `git rev-parse HEAD` for the `lastcommitsha` value.

`Dockerfile`

Configuration file to assemble the Docker image.

`config.ru`

Configuration file for Rack which connects Ruby Frameworks (Sinatra) to a supported web server (Puma).

`spec/spec_helper.rb`

Helper code for RSpec.

`spec/server_spec.rb`

RSpec tests for the application server code.

`Rakefile`

Rake's version of a Makefile. Used to define RSpec tasks here.

`Gemfile`

Describes gem dependencies for Ruby programs.

`Gemfile.lock`

Where Bundler records the exact gem versions.

`docker-compose.yml`

Defines the services that make up this application so it can be run in an isolated environment.

It's used here to stand up the development environment.

`.travis.yml`

Configuration file for Travis CI.

## Limitations and Risks

There are some limitations and risks to this implementation which are discussed in this section.

The application is written in Ruby using the Sinatra framework.
Using Sinatra, we're able to create web applications in Ruby quickly.
It could be written in NodeJS or Golang but we're able to meet the requirements with Ruby, Sinatra (framework), Rubocop (linter) and Rspec (testing).
It follows the [Twelve Factor App Methodology](https://12factor.net/) where it is feasible.

There is no graceful error handling but all application events are logged to `stdout` - the console.
Cloud services like AWS will collect the console logs.
In further work, the logged events could be redirected as required, either to a file,
syslog or elsewhere using a data collector like [Fluentd](https://www.fluentd.org/).

Although HTTPS is supported by the Puma web server, it's out of scope for this implementation.
For secure connections to the application, it could be listening behind a load balancer or proxy which can handle secure connections.

No monitoring support is provided in this project.
There is scope for adding support for better health checks of the application in the code.
Services like New Relic or Sentry could be integrated.

Although Puma is a multi-threaded web server, the project would not be considered resilient enough for production use.
Further work would consist of deploying it behind a load balancer and adjusting the number of instances or tasks to serve the projected request volumes.

This project depends on GitHub to host the code, Travis CI for the pipeline and Docker Hub to host the built image - the artifact.
For a production deployment, the artifact should be stored in a private Docker container registry, which can be self-hosted or
provided as a service by some cloud providers, e.g., [Amazon ECR](https://aws.amazon.com/ecr/).
This is less of a risk as development, test and build can be accomplished on the developer's own computer with Ruby, Sinatra and Docker installed along with other expected software.
