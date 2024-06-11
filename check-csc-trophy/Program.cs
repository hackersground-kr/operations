// C# code
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using HtmlAgilityPack;

class Program
{
    static readonly HttpClient client = new HttpClient();

    static async Task Main(string[] args)
    {
        string profileLink = args[0];
        string challengeCode = args[1];

        await CheckChallengeCompletion(profileLink, challengeCode);
    }

    static async Task CheckChallengeCompletion(string url, string challenge)
    {
        var web = new HtmlWeb();
        var doc = await web.LoadFromWebAsync(url);

        var elements = doc.DocumentNode.DescendantsAndSelf().Where(n => n.NodeType == HtmlNodeType.Text).Select(n => n.InnerHtml.Replace("\n", "").Replace("\t", "").Trim()).ToList();

        var flags = new Dictionary<string, List<string>>
        {
            {"AZ-900", new List<string> {"Microsoft Azure 기본 사항: 클라우드 개념 설명", "Azure 기본 사항: Azure 아키텍처 및 서비스 설명", "Azure 기본 사항: Azure 관리 및 거버넌스 설명"}},
            {"AI-900", new List<string> {"인공 지능 기초: 인공 지능 개념 설명", "인공 지능 기초: 인공 지능 서비스 설명", "인공 지능 기초: 인공 지능 솔루션 개발"}},
        };

        PrintResult(challenge, flags, elements);
    }

    static void PrintResult(string challengeInput, Dictionary<string, List<string>> flags, List<string> elements)
    {
            var completionStatus = new Dictionary<string, bool>();

    foreach (var flag in flags)
    {
        bool isCompleted = flag.Value.All(elements.Contains);
        completionStatus[flag.Key] = isCompleted;
    }

    if (completionStatus.ContainsKey(challengeInput.ToUpper()))
    {
        if (completionStatus[challengeInput.ToUpper()])
        {
            Console.WriteLine($"{challengeInput} 완료 /ok");
        }
        else
        {
            Console.WriteLine($"{challengeInput} NO");
        }
    }
    else
    {
        Console.WriteLine("유효하지 않은 챌린지 코드입니다.");
    }
    }
}