public class TrophyCheckerBuilder
{
    private string _url;
    private string _challenge;
    private Dictionary<string, List<string>> _flags;

    public TrophyCheckerBuilder()
    {
        // 기본 값 설정
        _url = "";
        _challenge = "";
        _flags = new Dictionary<string, List<string>>();
    }

    public TrophyCheckerBuilder WithUrl(string url)
    {
        _url = url;
        return this;
    }

    public TrophyCheckerBuilder WithChallenge(string challenge)
    {
        _challenge = challenge;
        return this;
    }

    public TrophyCheckerBuilder WithFlags(Dictionary<string, List<string>> flags)
    {
        _flags = flags;
        return this;
    }

    public TrophyChecker Build()
    {
        return new TrophyChecker(_url, _challenge, _flags);
    }
}
