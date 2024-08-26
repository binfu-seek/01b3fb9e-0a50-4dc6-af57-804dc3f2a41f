# Find Longest Array

## Overview

This project has developed a function that takes one string input of any number of integers separated by single whitespace. The function then outputs the longest increasing subsequence (increased by any number) present in that sequence. If more than 1 sequence exists with the longest length, output the earliest one.

## Technical highlights
- The project is containerized, therefore we can run it through docker image.
- The solution contains a main project called `FindLongestArray` which implements the logic, and another project `FindLongestArray.Tests` to test the main project.
- Linting is added to the main project. Warnings will be generated if linting issues found during project build. We can also optionally enforce the linting rules by specifying "Warnings as errors" in FindLongestArray.csproj, but for now it is not turned on.
- Github Actions workflow has been added (deploy.yml). Upon code commit to the main branch, it triggers the pipeline run.
- If the build/test/linting steps pass, the pipeline then push the docker image to AWS ECR repository, and in turn update the AWS Lambda function which relys on that image.
- The secrets used in the Github Actions pipeline are configured in the repo secrets, such as `AWS_ACCOUNT_ID`, `AWS_ACCESS_KEY_ID`, etc.
- Code coverage report has not been added yet due to the time constraint. The common process for this is to use `Coverlet` and `dotnet-reportgenerator-globaltool` to collect code coverage data and generage code coverage reports.

## Environmental setup
Please make sure below tools/frameworks has been installed
- .Net SDK 6 or above
- AWS CLI
- Docker

## How to run and test locally
- Clone the project to your local folder;
- Open a terminal and navigate to the root folder of the repo, where Dockerfile resides;
- Run this command to build the docker image:
  ```
  docker build -t find-longest-array .
  ```
- Run this command to run the application:
  ```
  docker run -p 9000:8080 find-longest-array
  ```
- Open another terminal, and use curl to send POST request with desired data to test and verify result. For example:
  ```
  curl -X POST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '"6 2 4 6 1 5 9 2"'
  ```
- Alternatively, we can also use tools like Postman to perform the same task.
