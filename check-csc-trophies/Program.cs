using System;
using System.Collections.Generic;
using System.IO;
using Microsoft.Extensions.Configuration;
//using HackersGround.Csc.Trophies.Services;

class Program
{
    static void Main(string[] args)
    {
        IConfiguration config = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("./properties/appsettings.json", optional: true, reloadOnChange: true)
            .Build();

        string? url = config["Url"];
        string? challenge = config["ChallengeInput"];
        var challenges = config.GetSection("Challenges").Get<Dictionary<string, List<string>>>();

        //예외 처리 (null 체크)
        if (url == null) throw new ArgumentNullException(nameof(url));
        if(challenge == null) throw new ArgumentNullException(nameof(challenge));
        if (challenges == null) throw new ArgumentNullException(nameof(challenges));

        var trophyChecker = new TrophyCheckerBuilder()
            .WithUrl(url)
            .WithChallenge(challenge)
            .WithFlags(challenges)
            .Build();

        trophyChecker.CheckChallengeCompletion(); // 트로피 획득 여부 확인

        //Console.ReadLine(); // 프로그램이 바로 종료되지 않도록 대기
    }
}
