# asdf-marksman

[marksman](https://github.com/artempyanykh/marksman) plugin for the [asdf version manager](https://asdf-vm.com).

Marksman is a language server for Markdown that provides code assist and intelligence features in your editor.

## Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

## Dependencies

**Required:**
- `bash`, `curl`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html)
- `git`: for listing versions

## Install

Plugin:

```shell
asdf plugin add marksman https://github.com/AxlER8R/asdf-marksman.git
```

marksman:

```shell
# Show all installable versions
asdf list all marksman

# Install specific version
asdf install marksman 2025-12-13

# Install latest version
asdf install marksman latest

# Set a version globally (in your ~/.tool-versions file)
asdf set --home marksman latest

# Now marksman commands are available
marksman --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to install & manage versions.

## Contributing

Contributions of any kind welcome! See the [contributing guide](CONTRIBUTE.md).

## License

See [LICENSE](LICENSE) © [AxlER8R](https://github.com/AxlER8R/)
