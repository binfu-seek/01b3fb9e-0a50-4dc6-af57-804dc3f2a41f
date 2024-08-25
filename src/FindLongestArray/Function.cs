// <copyright file="Function.cs" company="PlaceholderCompany">
// Copyright (c) PlaceholderCompany. All rights reserved.
// </copyright>

using Amazon.Lambda.Core;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace FindLongestArray;

public class Function
{
    /// <summary>
    /// Given any string that represents a sequence of integers, the function then outputs the longest increasing subsequence in that sequence.
    /// </summary>
    /// <param name="input">A string input of any number of integers separated by single whitespace.</param>
    /// <param name="context">The ILambdaContext that provides methods for logging and describing the Lambda environment.</param>
    /// <returns>The longest increasing subsequence present in that sequence.</returns>
    public string FunctionHandler(string input, ILambdaContext context)
    {
        try
        {
            var integers = ParseStringToIntList(input);
            var longestAcendingArray = FindLongestAscendingArray(integers);

            return string.Join(" ", longestAcendingArray);
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            return "Something went wrong";
        }
    }

    public static List<int> ParseStringToIntList(string input)
    {
        if (string.IsNullOrWhiteSpace(input))
        {
            return new List<int>();
        }

        string[] parts = input.Split(' ');

        // Convert each part to an integer and collect into a List<int>
        List<int> integers = parts
            .Select(part =>
            {
                // Try parsing each part; if parsing fails, handle the exception as needed
                if (!int.TryParse(part, out int result))
                {
                    throw new InvalidDataException($"Invalid - cannot convert to integer: {part}");
                }

                return result;
            })
            .ToList();

        return integers;
    }

    public static List<int> FindLongestAscendingArray(List<int> arr)
    {
        var maxArray = new List<int>();
        if (arr == null || arr.Count == 0)
        {
            return maxArray;
        }

        List<int> currentArray = new List<int>();
        currentArray.Add(arr[0]);
        for (int i = 1; i < arr.Count; i++)
        {
            if (arr[i] > arr[i - 1])
            {
                currentArray.Add(arr[i]);
            }
            else
            {
                if (currentArray.Count > maxArray.Count)
                {
                    maxArray = currentArray.ToList();
                }

                currentArray.Clear();
                currentArray.Add(arr[i]);
            }
        }

        if (currentArray.Count > maxArray.Count)
        {
            maxArray = currentArray.ToList();
        }

        return maxArray;
    }
}
