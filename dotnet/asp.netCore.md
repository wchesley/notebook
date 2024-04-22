# ASP.NET Core 8.0+

### Docs: 

- [ASP.NET Lists with jQuery](./asp.netListsWithjQuery.md)


## MVC Forms with API

Ensure calls in Controllers are awaited, without this, your dbContext might be disposed of before results are ready for viewing. See [this](https://stackoverflow.com/questions/66830530/cannot-access-a-disposed-context-instance-ef-core) relevant StackOverflow post. 

When creating a form, if you are using jQuery/JS to add some user interactivity on the page and posting that information to a local .NET API class. There are a few caveats to watch out for: 

- in jQuery, ensure your parameter names match the method parameters. If your API method is defined like so: 

```chsarp
[HttpPost]
[Route("DeleteFile")]
public async Task<IActionResult> DeleteAttachedFile(
    [FromForm] int id)
    {
        // method definiton
    }
```

Then your jQuery method must also pass the `id` parameter named as `id`. Else the values will not map at all and your API class will see no, or null values passed to it. 

- When POST-ing values from jQuery, ensure your method parameters are prefixed with `[FromForm]` attributes. Else your values might get passed in jQuery, but .NET will not see the values. 