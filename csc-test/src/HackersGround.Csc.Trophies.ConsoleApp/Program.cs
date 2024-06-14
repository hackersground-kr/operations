using HackersGround.Csc.Trophies.ChallengeSetting;
using HackersGround.Csc.Trophies.Services;

using System.IO;

using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

IHostBuilder builder = Host.CreateDefaultBuilder(args);

builder.ConfigureAppConfiguration((hostingContext, config) =>
{
    config.Sources.Clear();

    IHostEnvironment env = hostingContext.HostingEnvironment;

    config.AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
          .AddJsonFile($"appsettings.{env.EnvironmentName}.json", true, true);
});

ChallengeSetting Challenges = new();
builder.ConfigureServices.GetSection(nameof(ChallengeSetting))
    .Bind(Challenges);

Console.WriteLine("${Challenges}");

using IHost host = Host.CreateApplicationBuilder(args)
                .UseConsoleLifetime()
               .ConfigureServices(services =>
                {
                    services.AddSingleton(Challenges);
                    services.AddTransient<ITrophyCheckerService, TrophyCheckService>();
                    
                }).Build();

var service = host.Services.GetRequiredService<ITrophyCheckerService>();
await service.RunAsync(args);


