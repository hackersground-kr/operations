using HackersGround.Csc.Trophies.ConsoleApp.Models;

namespace HackersGround.Csc.Trophies.ConsoleApp.Options;

/// <summary>
/// This represents the options entity for arguments.
/// </summary>
public class ArgumentOptions
{
    /// <summary>
    /// Gets or sets the challenge code.
    /// </summary>
    public ChallengeCodeType? ChallengeCode { get; set; }

    /// <summary>
    /// Gets or sets the Microsoft Learn profile URL.
    /// </summary>
    public string? MicrosoftLearnProfileUrl { get; set; }

    /// <summary>
    /// Gets or sets the value indicating whether to show help or not.
    /// </summary>
    public bool Help { get; set; } // Help 값을 저장할 변수 추가

    /// <summary>
    /// Parses the arguments and returns the <see cref="ArgumentOptions"/> instance.
    /// </summary>
    /// <param name="args">List of arguments.</param>
    /// <returns>Returns the <see cref="ArgumentOptions"/> instance.</returns>
    public static ArgumentOptions Parse(string[] args)
    {
        var options = new ArgumentOptions();
        if (args.Length == 0)
        {
            return options;
        }

        for (var i = 0; i < args.Length; i++)
        {
            var arg = args[i];
            switch (arg)
            {
                case "-c":
                case "--code":
                case "--challenge-code":
                    options.ChallengeCode = i < args.Length - 1
                        ? Enum.TryParse<ChallengeCodeType>(args[++i].Replace("-", "_"), ignoreCase: true, out var result)
                            ? result
                            : ChallengeCodeType.Undefined
                        : ChallengeCodeType.Undefined;
                    break;

                case "-u":
                case "-url":
                case "-profile-url":
                    if (i < args.Length - 1)
                    {
                        options.MicrosoftLearnProfileUrl = args[++i];
                    }
                    break;

                case "-h":
                case "--help":
                    options.Help = true;
                    break;
            }
        }

        return options;
    }
}