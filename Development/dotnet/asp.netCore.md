[back](./README.md)

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


If you return `PartialView()` from your controllers (instead of return `View()`), then `_viewstart.cshtml` will not be executed. [ref [StackOverflow](https://stackoverflow.com/questions/4081811/correct-way-to-use-viewstart-cshtml-and-partial-razor-views/4082220#4082220)]

## .cshtml file output when app is built

I was curious one day so asked chatGPT this question after a few reworded google questions didn't lead me in the right direction: when an asp.net core MVC application is compiled, what happens to the cshtml files? Where are they located in the build output? 

When an ASP.NET Core MVC application is built, the handling of `.cshtml` files depends on whether **Razor compilation** is set for **runtime** or **precompiled**.

### **1\. Default Behavior (Runtime Compilation)**

-   **What Happens?**
    
    -   `.cshtml` files are **not compiled into the build output** during the build process. Instead, they remain as-is and are compiled **dynamically at runtime** when a view is rendered for the first time.
-   **Why?**
    
    -   This approach allows developers to edit `.cshtml` files without rebuilding the application, making it convenient during development.
-   **Location in Build Output**:
    
    -   Razor views (`.cshtml` files) are copied to the `\Views` folder within the **output directory** (e.g., `bin\Debug\netX.X\Views`).

* * *

### **2\. Precompiled Razor Views**

-   **What Happens?**
    
    -   Razor views are **precompiled** into `.dll` assemblies as part of the build or publish process. This removes the `.cshtml` files from the output and speeds up view rendering since no runtime compilation is needed.
-   **How to Enable?**
    
    -   Use the `Microsoft.AspNetCore.Mvc.Razor.RuntimeCompilation` package and enable **Razor view compilation** in the `.csproj` file:
        

-   -   `<PropertyGroup>     <RazorCompileOnBuild>true</RazorCompileOnBuild>     <RazorCompileOnPublish>true</RazorCompileOnPublish> </PropertyGroup>`
        
-   **Location in Build Output**:
    
    -   Razor views are compiled into a `MyApp.Views.dll` (or equivalent) file, located alongside the main application assembly in the `bin\Debug\netX.X` or `bin\Release\netX.X` directory.
    -   No `\Views` folder with `.cshtml` files is present in the output.

* * *

### **3\. Development vs. Production Considerations**

-   **Development**: Runtime compilation allows live editing of `.cshtml` files without rebuilding.
-   **Production**: Precompiled Razor views improve performance and reduce deployment size.

* * *