#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACTION="$1"
shift || true
SERVICE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --service)
            SERVICE="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

get_version() {
    python - <<'PY'
import pathlib
vars = {}
with open(pathlib.Path(__file__).resolve().parent.parent / 'package.py') as f:
    exec(f.read(), vars)
print(vars['version'])
PY
}

usage() {
    VERSION="$(get_version)"
    cat <<USAGE
AYON Shotgrid $VERSION Service Manager

Usage: ${0##*/} <command> [--service <name>]

Commands:
  build        Build docker image.
  build-all    Build docker image for 'leecher', 'processor' and 'transmitter'.
  clean        Remove local images.
  clean-build  Remove local images and build without docker cache.
  dev          Run a service locally.
  dist         Push docker image to DockerHub.
  dist-all     Push docker image for 'leecher', 'processor' and 'transmitter'.
  shell        Open a shell in the service container.
USAGE
}

require_service() {
    if [[ -z "$SERVICE" ]]; then
        echo "--service must be specified for $ACTION"
        usage
        exit 1
    fi
}

case "$ACTION" in
    build)
        require_service
        make -C "$SCRIPT_DIR" build SERVICE="$SERVICE"
        ;;
    build-all)
        make -C "$SCRIPT_DIR" build-all
        ;;
    clean)
        require_service
        make -C "$SCRIPT_DIR" clean SERVICE="$SERVICE"
        ;;
    clean-build)
        require_service
        make -C "$SCRIPT_DIR" clean-build SERVICE="$SERVICE"
        ;;
    dev)
        require_service
        make -C "$SCRIPT_DIR" dev SERVICE="$SERVICE"
        ;;
    dist)
        require_service
        make -C "$SCRIPT_DIR" dist SERVICE="$SERVICE"
        ;;
    dist-all)
        make -C "$SCRIPT_DIR" dist-all
        ;;
    shell)
        require_service
        make -C "$SCRIPT_DIR" shell SERVICE="$SERVICE"
        ;;
    ""|-h|--help|help)
        usage
        ;;
    *)
        echo "Unknown command: $ACTION"
        usage
        exit 1
        ;;
esac

