# ASP.NET Core 8.0+

### Docs: 

- [ASP.NET Lists with jQuery](./asp.netListsWithjQuery.md)

## Note Links

- [Lists with jQuery](./asp.netListsWithjQuery.md)
- [.editorconfig](./Editorconfig.md)
- [Snippits](./snippits.md)

## MVC Forms with API

Ensure calls in Controllers are awaited, without this, your dbContext might be disposed of before results are ready for viewing. See [this](https://stackoverflow.com/questions/66830530/cannot-access-a-disposed-context-instance-ef-core) relevant StackOverflow post. 



## Data Validation

### Partial Views

When using a partial view within a form. I've seen validation attributes not get sent to the partial view when it throws a validation error on POST-ing the form. The invalid field is correctly detected by jquery and cursor control is redirected to said invalid field, yet the error message is not present. I had tried the normal way with setting `<div asp-validation-for="ModelOnly"></div>` yet had no luck. It was only when I set the `asp-validation-for` value to `all` that I got the error message in the partial view. The caveat to this, the error message doesn't appear inline with the invalid element. Instead appears where the partial's `asp-validation-for` div is defined. 