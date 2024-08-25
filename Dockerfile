# Use the .NET SDK image to build the project
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the csproj file and restore any dependencies (via `dotnet restore`)
COPY src/FindLongestArray/*.csproj ./src/FindLongestArray/
RUN dotnet restore ./src/FindLongestArray/FindLongestArray.csproj

# Copy the remaining source code and build the project
COPY src/FindLongestArray/ ./src/FindLongestArray/
RUN dotnet publish ./src/FindLongestArray/FindLongestArray.csproj -c Release -r linux-x64 --self-contained false -o /app/publish

# Use the AWS Lambda .NET runtime image
FROM public.ecr.aws/lambda/dotnet:6

# Copy the published application from the build stage
COPY --from=build /app/publish/ ${LAMBDA_TASK_ROOT}/

# Command to run the Lambda function
CMD ["FindLongestArray::FindLongestArray.Function::FunctionHandler"]
