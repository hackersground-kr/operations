namespace HackersGround.Csc.Trophies.Services;

using HackersGround.Csc.Trophies.ChallengeSetting;
using HackersGround.Csc.Trophies.Options;

using System;
using Microsoft.Playwright;
using System.Collections.Generic;

public class TrophyCheckService(Dictionary<string, List<string>> challenges) : ITrophyCheckerService
{
    public async Task RunAsync(string []args)
    {
        var options= Options.Parse(args); //code,url 값 가져오기

        if (options.Help)
        {
             this.DisplayHelp();
             return;
        }

        try
        {

            using var playwright = await Playwright.CreateAsync();
            var browser = await playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions { Headless = true });
            var page = await browser.NewPageAsync();

            await page.GotoAsync(options.Url);

            await page.WaitForTimeoutAsync(5000); // 5초 대기

            var elements = await page.QuerySelectorAllAsync(".card-content-title"); //경로 재설정 필요
            if (elements == null || elements.Count == 0)
            {
                throw new Exception("No elements found");
            }

            var trophyTasks = elements.Select(element => element.TextContentAsync());

            var trophyResults = Task.WhenAll(trophyTasks).GetAwaiter().GetResult();

            var trophies = trophyResults.Select(trophy => trophy?.Replace("\n", "").Replace("\t", "").Trim()).ToList();
            PrintResult(options.Code, challenges, trophies);

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

    private void DisplayHelp()
    {
        Console.WriteLine("Usage:");
        Console.WriteLine("  -code, -url    Write Challenge Code to check trophies and Your MS Learn Profile URL"); 
        Console.WriteLine("  -h, --help                                            Display help");
    }
}
