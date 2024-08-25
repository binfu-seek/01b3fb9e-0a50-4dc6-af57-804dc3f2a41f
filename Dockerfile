FROM public.ecr.aws/lambda/dotnet:6

# Copy the function code
COPY src/FindLongestArray/bin/Release/net6.0/linux-x64/publish/ ${LAMBDA_TASK_ROOT}/

# Command to run the Lambda function
CMD ["FindLongestArray::FindLongestArray.Function::FunctionHandler"]