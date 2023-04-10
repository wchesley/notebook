# Scripts
Mostly notes about bash scripts, any other script I write would probably be in Python. 

## Trap Exit
- http://redsymbol.net/articles/bash-exit-traps/
- https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#index-trap

There is a simple, useful idiom to make your bash scripts more robust - ensuring they always perform necessary cleanup operations, even when something unexpected goes wrong. The secret sauce is a pseudo-signal provided by bash, called EXIT, that you can trap; commands or functions trapped on it will execute when the script exits for any reason. Let's see how this works. 
The basic code structure is like this:  

```bash
#!/bin/bash
function finish {
    # Your cleanup code here
}
trap finish EXIT
```

You place any code that you want to be certain to run in this "finish" function. A good common example: creating a temporary scratch directory, then deleting it after.

It's important to note that the `trap [arg] EXIT` command should come in beginning of a script. That way when the error does happen, it will actually be caught and the script can exit as you tell it to. 