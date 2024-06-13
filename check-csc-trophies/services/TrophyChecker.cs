using System;
using System.Collections.Generic;
using Microsoft.Playwright;

public class TrophyChecker
{
    private readonly string _url;
    private readonly string _challenge;
    private readonly Dictionary<string, List<string>> _flags;

    public TrophyChecker(string url, string challenge, Dictionary<string, List<string>> flags)
    {
        _url = url;
        _challenge = challenge;
        _flags = flags;
    }

    public void CheckChallengeCompletion()
    {
        if (_url == null){
            throw new ArgumentNullException(nameof(_url));
        }
        using var playwright = Playwright.CreateAsync().GetAwaiter().GetResult();
        var browser = playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions { Headless = true }).GetAwaiter().GetResult();
        var page = browser.NewPageAsync().GetAwaiter().GetResult();

        page.GotoAsync(_url).GetAwaiter().GetResult();
        System.Threading.Thread.Sleep(5000); // 페이지 로딩을 기다립니다.

        var elements = page.QuerySelectorAllAsync(".card-content-title").GetAwaiter().GetResult();
        if (elements == null){
        throw new Exception("No elements found");
        }

        var trophyTasks = elements.Select(element => element.TextContentAsync());
        
        var trophyResults = Task.WhenAll(trophyTasks).GetAwaiter().GetResult();
    
        var trophies = trophyResults.Select(trophy => trophy?.Replace("\n", "").Replace("\t", "").Trim()).ToList();
        PrintResult(_challenge, _flags, trophies);

        browser.CloseAsync().GetAwaiter().GetResult();
    }

    private void PrintResult(string challengeInput, Dictionary<string, List<string>> flags, IEnumerable<string?> trophies)
    {
        bool isValidChallenge = flags.ContainsKey(challengeInput);
        if (!isValidChallenge)
        {
            Console.WriteLine("Invalid challenge code.");
            return;
        }

        var completionStatus = new Dictionary<string, bool>();

        foreach (var (challengeCode, challengeFlags) in flags)
        {
            bool Completed = challengeFlags.All(flag => trophies.Contains(flag));
            completionStatus[challengeCode] = Completed;
        }

        if (completionStatus.TryGetValue(challengeInput, out bool isCompleted))
        {
            Console.WriteLine(isCompleted ? $"OK" : $"Failed");
        }
    }
}
