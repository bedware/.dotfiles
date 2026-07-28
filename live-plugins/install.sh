#!/bin/sh

set -eu

program=${0##*/}

usage() {
    printf '%s\n' \
        "Usage: $program [--version VERSION | --scratch-directory PATH] [--dry-run]" \
        '' \
        "Install this directory as IntelliJ IDEA's LivePlugin directory." \
        '' \
        'Options:' \
        '  --version VERSION' \
        '      Use the standard config directory for an IntelliJ version,' \
        '      for example: --version 2026.1' \
        '  --scratch-directory PATH' \
        '      Use an exact, absolute IntelliJ scratch directory. This covers' \
        '      custom idea.scratch.path and idea.config.path settings.' \
        '  --dry-run' \
        '      Validate and show the link without creating it.' \
        '  -h, --help' \
        '      Show this help.' \
        '' \
        'With no option, the installer uses the only detected IntelliJ config' \
        'directory. If several exist, it only auto-selects one that already' \
        'links to this source; otherwise an explicit option is required.' \
        '' \
        'The installer never replaces an existing file, directory, or link.'
}

die() {
    printf '%s: %s\n' "$program" "$*" >&2
    exit 1
}

canonical_directory() (
    CDPATH=
    export CDPATH
    cd -P "$1" 2>/dev/null || exit 1
    pwd -P
)

is_intellij_config_name() {
    printf '%s\n' "$1" |
        LC_ALL=C grep -Eq \
            '^(IntelliJIdea|IdeaIC)[0-9]{4}\.[0-9]+(\.[0-9]+)?$'
}

discover_scratch_directory() {
    jetbrains_root=$1
    expected_source=$2
    candidate_count=0
    matching_count=0
    selected_candidate=
    matching_candidate=

    for candidate in \
        "$jetbrains_root"/IntelliJIdea[0-9]* \
        "$jetbrains_root"/IdeaIC[0-9]*
    do
        [ -d "$candidate" ] || continue
        is_intellij_config_name "${candidate##*/}" || continue

        candidate_count=$((candidate_count + 1))
        selected_candidate=$candidate

        candidate_link=$candidate/live-plugins
        if [ -L "$candidate_link" ]; then
            if candidate_source=$(canonical_directory "$candidate_link"); then
                if [ "$candidate_source" = "$expected_source" ]; then
                    matching_count=$((matching_count + 1))
                    matching_candidate=$candidate
                fi
            fi
        fi
    done

    if [ "$candidate_count" -eq 1 ]; then
        printf '%s\n' "$selected_candidate"
        return 0
    fi

    if [ "$candidate_count" -gt 1 ] && [ "$matching_count" -eq 1 ]; then
        printf '%s\n' "$matching_candidate"
        return 0
    fi

    if [ "$candidate_count" -eq 0 ]; then
        printf '%s: no IntelliJ config directories found under %s\n' \
            "$program" "$jetbrains_root" >&2
        printf '%s\n' \
            'Start IntelliJ IDEA first or use --scratch-directory.' >&2
        return 1
    fi

    printf '%s\n' \
        "$program: multiple IntelliJ config directories found:" >&2
    for candidate in \
        "$jetbrains_root"/IntelliJIdea[0-9]* \
        "$jetbrains_root"/IdeaIC[0-9]*
    do
        [ -d "$candidate" ] || continue
        is_intellij_config_name "${candidate##*/}" || continue
        printf '  - %s\n' "${candidate##*/}" >&2
    done
    printf '%s\n' \
        'Run again with --version or --scratch-directory.' >&2
    return 1
}

version=
scratch_dir=
version_set=0
scratch_set=0
dry_run=0

while [ "$#" -gt 0 ]; do
    case $1 in
        --version)
            [ "$#" -ge 2 ] || die '--version requires a value'
            [ "$version_set" -eq 0 ] || die '--version was specified twice'
            version=$2
            version_set=1
            shift 2
            ;;
        --version=*)
            [ "$version_set" -eq 0 ] || die '--version was specified twice'
            version=${1#*=}
            version_set=1
            shift
            ;;
        --scratch-directory)
            [ "$#" -ge 2 ] ||
                die '--scratch-directory requires a value'
            [ "$scratch_set" -eq 0 ] ||
                die '--scratch-directory was specified twice'
            scratch_dir=$2
            scratch_set=1
            shift 2
            ;;
        --scratch-directory=*)
            [ "$scratch_set" -eq 0 ] ||
                die '--scratch-directory was specified twice'
            scratch_dir=${1#*=}
            scratch_set=1
            shift
            ;;
        --dry-run)
            dry_run=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            [ "$#" -eq 0 ] || die "unexpected argument: $1"
            ;;
        -*)
            die "unknown option: $1"
            ;;
        *)
            die "unexpected argument: $1"
            ;;
    esac
done

if [ "$version_set" -eq 1 ] && [ "$scratch_set" -eq 1 ]; then
    die '--version and --scratch-directory are mutually exclusive'
fi

os_name=$(uname -s 2>/dev/null) ||
    die 'cannot determine the operating system'
[ "$os_name" = 'Darwin' ] ||
    die 'this installer supports macOS only'

script_path=$0
case $script_path in
    */*) ;;
    *)
        script_path=$(command -v "$script_path") ||
            die 'cannot locate the installer'
        ;;
esac

symlink_hops=0
while [ -L "$script_path" ]; do
    symlink_hops=$((symlink_hops + 1))
    [ "$symlink_hops" -le 40 ] ||
        die 'too many symbolic links while locating the installer'

    script_parent=$(canonical_directory "$(dirname "$script_path")") ||
        die 'cannot resolve the installer directory'
    script_target=$(readlink "$script_path") ||
        die "cannot read installer symlink: $script_path"

    case $script_target in
        /*) script_path=$script_target ;;
        *)  script_path=$script_parent/$script_target ;;
    esac
done

source_dir=$(canonical_directory "$(dirname "$script_path")") ||
    die 'cannot resolve the live-plugins source directory'

if [ "$scratch_set" -eq 1 ]; then
    [ -n "$scratch_dir" ] ||
        die '--scratch-directory cannot be empty'
    case $scratch_dir in
        /*) ;;
        *) die '--scratch-directory must be an absolute path' ;;
    esac
    [ "$scratch_dir" != '/' ] ||
        die 'refusing to use the filesystem root as the scratch directory'
    [ -d "$scratch_dir" ] ||
        die "scratch directory does not exist: $scratch_dir"
else
    [ -n "${HOME:-}" ] ||
        die 'HOME is not set; use --scratch-directory'

    jetbrains_root=$HOME/Library/Application\ Support/JetBrains

    if [ "$version_set" -eq 1 ]; then
        if ! printf '%s\n' "$version" |
            LC_ALL=C grep -Eq '^[0-9]{4}\.[0-9]+(\.[0-9]+)?$'
        then
            die '--version must look like 2026.1 or 2026.1.2'
        fi

        scratch_dir=$jetbrains_root/IntelliJIdea$version
        [ -d "$scratch_dir" ] ||
            die "IntelliJ config directory does not exist: $scratch_dir"
    else
        [ -d "$jetbrains_root" ] ||
            die "JetBrains config root does not exist: $jetbrains_root"
        scratch_dir=$(
            discover_scratch_directory "$jetbrains_root" "$source_dir"
        ) || exit 1
    fi
fi

scratch_dir=$(canonical_directory "$scratch_dir") ||
    die "cannot access scratch directory: $scratch_dir"
[ "$scratch_dir" != '/' ] ||
    die 'refusing to use the filesystem root as the scratch directory'
case $scratch_dir in
    "$source_dir"|"$source_dir"/*)
        die "refusing to create a recursive link inside the source: $scratch_dir"
        ;;
esac
destination=$scratch_dir/live-plugins

# Test -L before -e so broken symbolic links are detected and preserved.
if [ -L "$destination" ]; then
    current_target=$(readlink "$destination") ||
        die "cannot read existing symbolic link: $destination"

    if current_source=$(canonical_directory "$destination"); then
        if [ "$current_source" = "$source_dir" ]; then
            printf 'Already installed: %s -> %s\n' \
                "$destination" "$source_dir"
            exit 0
        fi
    fi

    die "refusing to replace symbolic link: $destination -> $current_target"
fi

if [ -e "$destination" ]; then
    die "refusing to replace existing path: $destination"
fi

if [ "$dry_run" -eq 1 ]; then
    printf 'Would install: %s -> %s\n' "$destination" "$source_dir"
    exit 0
fi

# macOS ln -h prevents following a destination symlink created during a race.
ln -s -h "$source_dir" "$destination" ||
    die "cannot create symbolic link: $destination"

[ -L "$destination" ] ||
    die "link creation reported success, but no link exists: $destination"
installed_source=$(canonical_directory "$destination") ||
    die "created link cannot be resolved: $destination"
[ "$installed_source" = "$source_dir" ] ||
    die "created link points to an unexpected directory: $destination"

printf 'Installed: %s -> %s\n' "$destination" "$source_dir"
