# Use the .NET SDK image to build the project
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the csproj file and restore any dependencies
COPY src/FindLongestArray/*.csproj ./src/FindLongestArray/
RUN dotnet restore ./src/FindLongestArray/FindLongestArray.csproj

# Copy the remaining source code
COPY test/FindLongestArray.Tests/*.csproj ./test/FindLongestArray.Tests/
RUN dotnet restore ./test/FindLongestArray.Tests/FindLongestArray.Tests.csproj

# Build the project
RUN dotnet build ./src/FindLongestArray/FindLongestArray.csproj -c Release
RUN dotnet build ./test/FindLongestArray.Tests/FindLongestArray.Tests.csproj

# Run tests
RUN dotnet test ./test/FindLongestArray.Tests/FindLongestArray.Tests.csproj

# Publish the project
RUN dotnet publish ./src/FindLongestArray/FindLongestArray.csproj -c Release -r linux-x64 --self-contained false -o /app/publish

# Use the AWS Lambda .NET runtime image
FROM public.ecr.aws/lambda/dotnet:6

# Copy the published application from the build stage
COPY --from=build /app/publish/ ${LAMBDA_TASK_ROOT}/

# Command to run the Lambda function
CMD ["FindLongestArray::FindLongestArray.Function::FunctionHandler"]
