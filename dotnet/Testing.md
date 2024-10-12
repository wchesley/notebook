# Testing

Might seem obvious, but tripped me up for a moment. When testing the search feature of an index query in ASP.Net Core, make sure your mocked model contains all of the fields you are attempting to search by else you will end up with a null reference exception.

Example Index Controller Action: 

```cs
//Most of this Action is ommited to only show the relevant portions
using X.Extensions.PagedList.EF;
 [HttpGet]
public async Task<IActionResult> Index(
    string sortOrder,
    string searchString,
    string currentFilter,
    int? page)
{
    if (!string.IsNullOrEmpty(searchString))
    {
        page = 1;
    }
    else
    {
        searchString = currentFilter;
    }

    ViewData["CurrentFilter"] = searchString;
    if (!string.IsNullOrEmpty(searchString))
    {
        engines = engines.Where(
            e => e.EngineDescription.Contains(searchString) ||
                    e.EngineEngineMfg.Contains(searchString) ||
                    e.EngineModel.Contains(searchString) ||
                    e.EngineEngineHp.ToString().Contains(searchString) ||
                    e.EngineEngineRpm.ToString().Contains(searchString));
    }
    return View(
        nameof(Index),
        await engines.ToPagedListAsync(
            pageNumber,
            PageSize));
}
```

The test: 

```cs
[Fact]
private async Task Index_WithSearchString_ReturnsMatchingResult()
{
    const string SearchString = "Test Engine 1";
    var mediatorMock = new Mock<IMediator>();
    var engines = new List<EngineWebModel>
    {
        new EngineWebModel { EngineId = 1, EngineDescription = "Test Engine 1", EngineModel = "Test Model 1", EngineEngineMfg = "Test Mfg 1", EngineEngineRpm = 1000, EngineEngineHp = 100 },
        new EngineWebModel { EngineId = 2, EngineDescription = "Test Engine 2", EngineModel = "Test Model 2", EngineEngineMfg = "Test Mfg 2", EngineEngineRpm = 2000, EngineEngineHp = 200 }
    }.AsQueryable();
    var mock = engines.AsParallel().BuildMock();
    mediatorMock.Setup(m => m.Send(It.IsAny<GetAllEnginesQuery>(), It.IsAny<CancellationToken>()))
        .ReturnsAsync(mock);
    var controller = new EnginesController(mediatorMock.Object, Mock.Of<ILogger<EnginesController>>());
    
    //Act
        var result = await controller.Index(
        null,
        SearchString,
        null,
        null);
    
    //Assert
    var viewResult = Assert.IsType<ViewResult>(result);
    var model = Assert.IsAssignableFrom<StaticPagedList<EngineWebModel>>(viewResult.Model);
    Assert.Single(model);
}
```