[back](./README.md)

# Bash

Bash is the GNU Project's shell—the Bourne Again SHell. This is an sh-compatible shell that incorporates useful features from the Korn shell (ksh) and the C shell (csh). It is intended to conform to the IEEE POSIX P1003.2/ISO 9945.2 Shell and Tools standard. It offers functional improvements over sh for both programming and interactive use. In addition, most sh scripts can be run by Bash without modification.

## What does `2>&1` mean? 

To combine `stderr` and `stdout` into the `stdout` stream, we append this to a command:
```shell
2>&1
```

For example, the following command shows the first few errors from compiling main.cpp:

```shell
g++ main.cpp 2>&1 | head
```

But what does `2>&1` mean?

---

File descriptor 1 is the standard output (`stdout`).
File descriptor 2 is the standard error (`stderr`).

At first, `2>1` may look like a good way to redirect `stderr` to `stdout`. However, it will actually be interpreted as "redirect `stderr` to a file named `1`".

`&` indicates that what follows and precedes is a *file descriptor*, and not a filename. Thus, we use `2>&1`. Consider `>&` to be a *redirect merger* operator.

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

### Trap exit on Error

To exit only on an error from bash, you first need to add `set -e` to the script. This gives us access to the exit code from the script. 

```bash
#!/bin/bash
set -e
finish() {
    if [ "$1" != "0" ]; then
        # Handle error/cleanup
    else
        # Do clean up on normal exit
    fi
}
```