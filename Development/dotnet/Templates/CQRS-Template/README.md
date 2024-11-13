# CQRS Template

Create new command or query class and file. 

Adapted from Jason Taylor's `ca-usecase` [link](https://github.com/jasontaylordev/CleanArchitecture/tree/main/templates/ca-use-case).

## Usage

Example: 

```ps1
dotnet new cqrs -f testCommand -us command -r int 
```

Help output: 

```
CQRS Creator(C#)
Author: Walker Chesley
Description: Create new query or command
Usage:
  dotnet new cqrs [options] [template options]
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
    -f, --featureName <featureName>     The name of the feature
        Type: string
        Default: CQRS.Application
    -us, --useCaseType <command|query>  The type of use case to create
        Required: *true*
        Type: choice
            command  Create a new command
            query    Create a query
    -r, --returnType <returnType>       
        Type: string
        Default: object
```