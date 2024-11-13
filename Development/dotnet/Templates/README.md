# Dotnet Templates

With .NET 7+, you can create and deploy templates that generate projects, files, and resources.

# My Templates

- `CQRS`
  - Adapted from Jason Taylor's [ca-usecase](https://github.com/jasontaylordev/CleanArchitecture/tree/main/templates/ca-use-case)

# Create Item Template
###### [Source](https://learn.microsoft.com/en-us/dotnet/core/tutorials/cli-templates-create-item-template)

## Create the required folders

This series uses a "working folder" where your template source is contained and a "testing folder" used to test your templates. The working folder and testing folder should be under the same parent folder.

First, create the parent folder, the name doesn't matter. Then, create two subfolders named _working_ and _test_. Inside of the _working_ folder, create a subfolder named _content_.

The folder structure should look like the following.

Console

    parent_folder
    ├───test
    └───working
        └───content
    

## Create an item template

An item template is a specific type of template that contains one or more files. These types of templates are useful when you already have a project and you want to generate another file, like a config file or code file. In this example, you'll create a class that adds an extension method to the string type.

In your terminal, navigate to the _working\\content_ folder and create a new subfolder named _extensions_.

Console

    working
    └───content
        └───extensions
    

Navigate to the _extensions_ folder and create a new file named _StringExtensions.cs_. Open the file in a text editor. This class will provide an extension method named `Reverse` that reverses the contents of a string. Paste in the following code and save the file:

C#

    namespace System;
    
    public static class StringExtensions
    {
        public static string Reverse(this string value)
        {
            char[] tempArray = value.ToCharArray();
            Array.Reverse(tempArray);
            return new string(tempArray);
        }
    }
    

Now that the content of the template is finished, the next step is to create the template config.

## Create the template config

In this part of the tutorial, your template folder is located at _working\\content\\extensions_.

Templates are recognized by .NET because they have a special folder and config file that exist at the root of your template folder.

First, create a new subfolder named _.template.config_, and enter it. Then, create a new file named _template.json_. Your folder structure should look like this:

Console

    working
    └───content
        └───extensions
            └───.template.config
                    template.json
    

Open the _template.json_ with your favorite text editor and paste in the following JSON code and save it.

```JSON
{
    "$schema": "http://json.schemastore.org/template",
    "author": "Me",
    "classifications": [ "Common", "Code" ],
    "identity": "ExampleTemplate.StringExtensions",
    "name": "Example templates: string extensions",
    "shortName": "stringext",
    "tags": {
        "language": "C#",
        "type": "item"
    },
    "symbols": {
        "ClassName":{
        "type": "parameter",
        "description": "The name of the code file and class.",
        "datatype": "text",
        "replaces": "StringExtensions",
        "fileRename": "StringExtensions",
        "defaultValue": "StringExtensions"
        }
    }
}
```    

This config file contains all the settings for your template. You can see the basic settings, such as `name` and `shortName`, but there's also a `tags/type` value that's set to `item`. This categorizes your template as an "item" template. There's no restriction on the type of template you create. The `item` and `project` values are common names that .NET recommends so that users can easily filter the type of template they're searching for.

The `classifications` item represents the **tags** column you see when you run `dotnet new` and get a list of templates. Users can also search based on classification tags. Don't confuse the `tags` property in the _template.json_ file with the `classifications` tags list. They're two different concepts that are unfortunately named the same. The full schema for the _template.json_ file is found at the [JSON Schema Store](http://json.schemastore.org/template) and is described at [Reference for template.json](https://github.com/dotnet/templating/wiki/Reference-for-template.json). For more information about the _template.json_ file, see the [dotnet templating wiki](https://github.com/dotnet/templating/wiki).

The `symbols` part of this JSON object is used to define the parameters that can be used in the template. In this case, there's one parameter defined, `ClassName`. The defined parameter contains the following settings:

-   `type` - This is a mandatory setting and must be set to `parameter`.
-   `description` - The description of the parameter, which is printed in the template help.
-   `datatype` - The type of data of the parameter value when the parameter is used.
-   `replaces` - Specifies a text value that should be replaced in all template files by the value of the parameter.
-   `fileRename` - Similar to `replaces`, this specifies a text value that is replaced in the names of all of the template files by the value of the parameter.
-   `defaultValue` - The default value of this parameter when the parameter isn't specified by the user.

When the template is used, the user can provide a value for the `ClassName` parameter, and this value replaces all occurrences of `StringExtensions`. If a value isn't provided, the `defaultValue` is used. For this template, there are two occurrences of `StringExtensions`: the file _StringExtensions.cs_ and the class _StringExtensions_. Because the `defaultValue` of the parameter is `StringExtensions`, the file name and class name remain unchanged if the parameter isn't specified when using the template. When a value is specified, for example `dotnet new stringext -ClassName MyExts`, the file is renamed _MyExts.cs_ and the class is renamed to _MyExts_.

To see what parameters are available for a template, use the `-?` parameter with the template name:

.NET CLI

    dotnet new stringext -?
    

Which produces the following output:

Console

    Example templates: string extensions (C#)
    Author: Me
    
    Usage:
      dotnet new stringext [options] [template options]
    
    Options:
      -n, --name <name>       The name for the output being created. If no name is specified, the name of the output directory is used.
      -o, --output <output>   Location to place the generated output.
      --dry-run               Displays a summary of what would happen if the given command line were run if it would result in a template creation.
      --force                 Forces content to be generated even if it would change existing files.
      --no-update-check       Disables checking for the template package updates when instantiating a template.
      --project <project>     The project that should be used for context evaluation.
      -lang, --language <C#>  Specifies the template language to instantiate.
      --type <item>           Specifies the template type to instantiate.
    
    Template options:
      -C, --ClassName <ClassName>  The name of the code file and class.
                                   Type: text
                                   Default: StringExtensions
    

Now that you have a valid _.template.config/template.json_ file, your template is ready to be installed. In your terminal, navigate to the _extensions_ folder and run the following command to install the template located at the current folder:

-   **On Windows**: `dotnet new install .\`
-   **On Linux or macOS**: `dotnet new install ./`

This command outputs the list of templates installed, which should include yours.

Console

    The following template packages will be installed:
       <root path>\working\content\extensions
    
    Success: <root path>\working\content\extensions installed the following templates:
    Templates                                         Short Name               Language          Tags
    --------------------------------------------      -------------------      ------------      ----------------------
    Example templates: string extensions              stringext                [C#]              Common/Code
    

[](https://learn.microsoft.com/en-us/dotnet/core/tutorials/cli-templates-create-item-template#test-the-item-template)

## Test the item template

Now that you have an item template installed, test it.

1.  Navigate to the _test_ folder.
    
2.  Create a new console application with `dotnet new console`, which generates a working project you can easily test with the `dotnet run` command.
    
    .NET CLI
    

    dotnet new console
    

You get output similar to the following.

Output

-       The template "Console Application" was created successfully.
        
        Processing post-creation actions...
        Running 'dotnet restore' on C:\test\test.csproj...
          Restore completed in 54.82 ms for C:\test\test.csproj.
        
        Restore succeeded.
        
    
-   Run the project using the following command.
    
    .NET CLI
    

    dotnet run
    

You get the following output.

Output

-       Hello, World!
        
    
-   Run `dotnet new stringext` to generate the _StringExtensions.cs_ file from the template.
    
    .NET CLI
    

    dotnet new stringext
    

You get the following output.

Output

-       The template "Example templates: string extensions" was created successfully.
        
    
-   Change the code in _Program.cs_ to reverse the `"Hello, World!"` string with the extension method provided by the template.
    
    C#
    

    Console.WriteLine("Hello, World!".Reverse());
    

Run the program again and see that the result is reversed.

.NET CLI

    dotnet run
    

You get the following output.

Output

1.      !dlroW ,olleH
        
    

Congratulations! You created and deployed an item template with .NET. In preparation for the next part of this tutorial series, uninstall the template you created. Make sure to delete all files and folders in the _test_ folder too. This gets you back to a clean state ready for the next part of this tutorial series.

[](https://learn.microsoft.com/en-us/dotnet/core/tutorials/cli-templates-create-item-template#uninstall-the-template)

## Uninstall the template

In your terminal, navigate to the _extensions_ folder and run the following command to uninstall the templates located at the current folder:

-   **On Windows**: `dotnet new uninstall .\`
-   **On Linux or macOS**: `dotnet new uninstall ./`

This command outputs a list of the templates that were uninstalled, which should include yours.

Console

    Success: <root path>\working\content\extensions was uninstalled.
    

At any time, you can use `dotnet new uninstall` to see a list of installed template packages, including for each template package the command to uninstall it.