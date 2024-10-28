# Versionize

Dotnet tool to automate changelog generation based on [conventional commit](../Git/git.md) style. 

- Github Repo: https://github.com/versionize/versionize

## Usage

```man
PS C:\Users\wchesley> versionize -h
1.23.0.0

Usage: versionize [command] [options]

Options:
  -?|-h|--help                         Show help information.
  -v|--version                         Show version information.
  -w|--workingDir <WORKING_DIRECTORY>  Directory containing projects to version
  -d|--dry-run                         Skip changing versions in projects, changelog generation and
                                       git commit
  --skip-dirty                         Skip git dirty check
  -r|--release-as <VERSION>            Specify the release version manually
  --silent                             Suppress output to console
  --skip-commit                        Skip commit and git tag after updating changelog and
                                       incrementing the version
  --skip-tag                           Skip git tag after making release commit
  -i|--ignore-insignificant-commits    Do not bump the version if no significant commits (fix, feat or
                                       BREAKING) are found
  --exit-insignificant-commits         Exits with a non zero exit code if no significant commits (fix,
                                       feat or BREAKING) are found
  --changelog-all                      Include all commits in the changelog not just fix, feat and
                                       breaking changes
  --commit-suffix                      Suffix to be added to the end of the release commit message
                                       (e.g. [skip ci])
  -p|--pre-release                     Release as pre-release version with given pre release label.
  -a|--aggregate-pre-releases          Include all pre-release commits in the changelog since the last
                                       full version.
  --proj-version-bump-logic            [DEPRECATED] Use --find-release-commit-via-message instead
  --find-release-commit-via-message    Use commit message instead of tag to find last release commit
  --tag-only                           Only works with git tags, does not commit or modify the csproj
                                       file.

Commands:
  inspect                              Prints the current version to stdout

Run 'versionize [command] -?|-h|--help' for more information about a command.
```

## Caveat with auto-generated build numbers

I have a project where I'm automatically incrementing the build number with each build. This action takes place via powershell script that is run at build time. The only issue this creates with versionize is it breaks the ability to properly generate a change log. Instead of only adding most recent changes it will add all of them every time the change log is generated. To avoid this, run versionize with the `--find-release-commit-via-message` arguement.