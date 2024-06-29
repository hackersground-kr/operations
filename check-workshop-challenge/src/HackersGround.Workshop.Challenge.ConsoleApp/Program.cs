using HackersGround.Workshop.Challenge.ConsoleApp.Services;

using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var host = Host.CreateDefaultBuilder(args)
               .UseConsoleLifetime()
               .ConfigureServices(services =>
               {
                   services.AddHttpClient<IChallengeCheckerService, ChallengeCheckerService>();
               })
               .Build();

var service = host.Services.GetRequiredService<IChallengeCheckerService>();
await service.RunAsync(args);
