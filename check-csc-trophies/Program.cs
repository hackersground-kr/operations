using HackersGround.Csc.Trophies.Services;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var host = Host.CreateDefaultBuilder()
               .UseConsoleLifetime()
               .ConfigureServices(services =>
               {
                   services.AddTransient<ITrophyCheckerService, TrophyCheckService>();
               })
               .Build();

var service = host.Services.GetRequiredService<ITrophyCheckerService>();
await service.RunAsync();


