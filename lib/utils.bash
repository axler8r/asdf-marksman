#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/artempyanykh/marksman"
TOOL_NAME="marksman"
TOOL_TEST="marksman --version"

fail() {
    echo -e "asdf-$TOOL_NAME: $*"
    exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
    curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
    sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
        LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
    git ls-remote --tags --refs "$GH_REPO" |
        grep -o 'refs/tags/.*' | cut -d/ -f3- |
        sed 's/^v//'
}

list_all_versions() {
    list_github_tags
}

get_platform() {
    local os arch

    os="$(uname -s | tr '[:upper:]' '[:lower:]')"
    arch="$(uname -m)"

    case "$os" in
    linux)
        case "$arch" in
        x86_64) echo "linux-x64" ;;
        aarch64 | arm64) echo "linux-arm64" ;;
        *) fail "Unsupported architecture: $arch" ;;
        esac
        ;;
    darwin)
        echo "macos"
        ;;
    mingw* | msys* | cygwin*)
        echo "windows"
        ;;
    *)
        fail "Unsupported operating system: $os"
        ;;
    esac
}

download_release() {
    local version filename url platform
    version="$1"
    filename="$2"
    platform="$(get_platform)"

    if [[ "$platform" == "windows" ]]; then
        url="$GH_REPO/releases/download/${version}/${TOOL_NAME}.exe"
    else
        url="$GH_REPO/releases/download/${version}/${TOOL_NAME}-${platform}"
    fi

    echo "* Downloading $TOOL_NAME release $version for $platform..."
    curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
    local install_type="$1"
    local version="$2"
    local install_path="${3%/bin}/bin"

    if [ "$install_type" != "version" ]; then
        fail "asdf-$TOOL_NAME supports release installs only"
    fi

    (
        mkdir -p "$install_path"
        cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

        local tool_cmd
        if [[ "$(get_platform)" == "windows" ]]; then
            tool_cmd="$TOOL_NAME.exe"
        else
            tool_cmd="$TOOL_NAME"
        fi

        chmod +x "$install_path/$tool_cmd"
        test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

        echo "$TOOL_NAME $version installation was successful!"
    ) || (
        rm -rf "$install_path"
        fail "An error occurred while installing $TOOL_NAME $version."
    )
}
