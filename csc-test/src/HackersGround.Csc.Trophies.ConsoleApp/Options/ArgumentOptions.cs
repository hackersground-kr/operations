namespace HackersGround.Csc.Trophies.Options;

public class Options
{
    public string Code { get; set; } // code 값을 저장할 변수 추가
    public string Url { get; set; } // url 값을 저장할 변수 추가
    public string Help { get; set; } // Help 값을 저장할 변수 추가
    public static Options Parse(string[] args)
    {
        var Options = new Options();

        //settings with command line arguments
        if (args.Length == 0)
        {
            return Options;
        }

        for (var i = 0; i < args.Length; i++)
        {
            var arg = args[i];
            switch (arg)
            {
                case "-code":
                    if (i + 1 < args.Length) // 다음 인수가 있는지 확인
                    {
                        Options.Code = args[++i]; // code 값 저장
                    }
                    break;
                case "-url":
                    if (i + 1 < args.Length) // 다음 인수가 있는지 확인
                    {
                        Options.Url = args[++i]; // url 값 저장
                    }
                    break;
                case "-Help:
                    Options.Help = true;
                    break;
            }
        }
        return Options;
    }
}