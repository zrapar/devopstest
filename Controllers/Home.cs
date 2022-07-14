using Microsoft.AspNetCore.Mvc;

namespace devopsTest.Controllers;

[ApiController]
[Route("/")]
public class Home : ControllerBase
{


    private readonly ILogger<Home> _logger;

    public Home(ILogger<Home> logger)
    {
        _logger = logger;
    }

    [HttpGet(Name = "HealthCheck")]
    public string Get()
    {
        return "🧑🏽‍⚕️🐣🐣🐤🐥🐔 Hello chicks!👩🏽‍⚕️";
    }
}
