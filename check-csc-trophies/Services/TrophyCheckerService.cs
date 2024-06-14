namespace HackersGround.Csc.Trophies.Services;

using Microsoft.Extensions.Configuration;
using System;
using Microsoft.Playwright;
using System.Collections.Generic;

public class TrophyCheckService : ITrophyCheckerService
{
    private readonly IConfiguration Configuration;
    private readonly string? url;
    private readonly string? challengeInput;
    private readonly Dictionary<string, List<string>>? challenges;

    public TrophyCheckService(IConfiguration configuration)
    {
        Configuration = configuration;
        url = Configuration["Url"];
        challengeInput = Configuration["ChallengeInput"];
        challenges = Configuration.GetSection("Challenges")
                                  .Get<Dictionary<string, List<string>>>();
    }
    public async Task RunAsync()
    {
        try
        {
            using var playwright = await Playwright.CreateAsync();
            var browser = await playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions { Headless = true });
            var page = await browser.NewPageAsync();

            await page.GotoAsync(url);

            await page.WaitForTimeoutAsync(5000); // 5초 대기

            var elements = await page.QuerySelectorAllAsync(".card-content-title");
            if (elements == null || elements.Count == 0)
            {
                throw new Exception("No elements found");
            }

            var trophyTasks = elements.Select(element => element.TextContentAsync());

            var trophyResults = Task.WhenAll(trophyTasks).GetAwaiter().GetResult();

            var trophies = trophyResults.Select(trophy => trophy?.Replace("\n", "").Replace("\t", "").Trim()).ToList();
            PrintResult(challengeInput, challenges, trophies);

            browser.CloseAsync().GetAwaiter().GetResult();
        }
        catch (Exception e)
        {
            Console.WriteLine(e.Message);
        }
    }

    private void PrintResult(string challengeInput, Dictionary<string, List<string>> challengs, IEnumerable<string?> trophies)
    {
        bool isValidChallenge = challengs.ContainsKey(challengeInput);
        if (!isValidChallenge)
        {
            Console.WriteLine("Invalid challenge code.");
            return;
        }

        var completionStatus = new Dictionary<string, bool>();

        foreach (var (challengeCode, challengechallengs) in challengs)
        {
            bool Completed = challengechallengs.All(flag => trophies.Contains(flag));
            completionStatus[challengeCode] = Completed;
        }

        if (completionStatus.TryGetValue(challengeInput, out bool isCompleted))
        {
            Console.WriteLine(isCompleted ? "OK" : "Failed");
        }
    }
}
