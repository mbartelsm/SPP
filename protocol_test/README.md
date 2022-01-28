# Protocol test

This is a simple implementation of the quote protocol described in the [Let it recover](https://dl.acm.org/doi/10.1145/3033019.3033031) paper.

## Running the program

### Windows

A powershell script to build the project has been included, to run it simply execute the following command on a powershell console

```ps1
PowerShell 7.2.1
Copyright (c) Microsoft Corporation.

> ./make.ps1 build    # To build without running
> ./make.ps1 run      # To execute
> ./make.ps1 debug    # To execute with full debug output
```

### Linux

For linux distributions a Makefile has been included

```bash
$ make build    # To build without running
$ make run      # To execute
$ make debug    # To execute with full debug output
```

### Manual build

If the build scripts fail, the project can be built using the following steps:

1. Make a `./ebin/` directory if one does not already exist
2. Build the project with the command `erl -make`
3. Set the environment variable for logging output
   - On Powershell, this is `$Env:ERL_LEVEL="warn"` (possible values are `"debug"`, `"info"`, `"warn"`, and `"error"`)
   - On Bash this is `ERL_LEVEL=warn` (possible values are `debug`, `info`, `warn`, and `error`)
   - Other terminals may have a different way to declare environment variables
4. Run the project with the command `erl -noinput -noshell -pa ./ebin/ -s main main`
