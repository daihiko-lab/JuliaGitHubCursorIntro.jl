#!/usr/bin/env bash
# JETLS の check 対象 (DistSSHRun.jl の jetls-check.sh を教材向けに簡略化)
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
shopt -s nullglob

# test/runtests.jl は Test / Aqua 依存のため JETLS 対象外 (Pkg.test で検証)
files=(
    src/JuliaGitHubCursorIntro.jl
    examples/analyze_survey.jl
    submissions/example_githubuser.jl
)

if ((${#files[@]} == 0)); then
    echo "jetls-check: no entry files matched" >&2
    exit 1
fi

print_files=false
jetls_args=()
for arg in "$@"; do
    if [[ "$arg" == "--print-files" ]]; then
        print_files=true
    else
        jetls_args+=("$arg")
    fi
done

if [[ "$print_files" == true ]]; then
    printf '%s\n' "${files[*]}"
    exit 0
fi

if [[ -z "${JULIA_APPS_JULIA_CMD:-}" ]]; then
    export JULIA_APPS_JULIA_CMD="$(command -v julia)"
fi

exec jetls --threads=auto -- check --exit-severity=hint --show-severity=hint "${jetls_args[@]}" "${files[@]}"
