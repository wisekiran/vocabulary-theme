#!/bin/bash
set -o errexit
set -o errtrace
set -o nounset

# setup fun colors for added UX
HEAD='\033[1m\033[7m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Change directory to repository root
# (parent directory of this script's location)
pushd "${0%/*}/.." >/dev/null

if [[ -z "${1:-}" ]]
then
     {
        echo
        echo -en "${RED}missing VERSION argument ("
        echo -n 'format: vMAJOR.MINOR.PATCH,'
        echo -e " example: v0.1.0)${NC}"
        echo
     } 1>&2
     exit 1
elif [[ ! "${1}" =~ ^v[0-9]+[.][0-9]+([.][0-9]+)?$ ]]
then
     {
        echo
        echo -e "${RED}invalid VERSION argument: ${1}${NC}"
        echo
     } 1>&2
     exit 1
else
    printf "${HEAD} %-80s${NC}\n" 'Checkout prep branch'
    git checkout -b "prep-${1}"
    echo

    printf "${HEAD} %-80s${NC}\n" 'Stage directories/files for release'
    mv ./src/* ./
    # remove unneeded files for release (and self destruct)
    rm -fr -- \
        ./.devcontainer \
        ./.github \
        ./src \
        ./docker \
        ./scripts \
        .cc-metadata.yml \
        .env.example \
        .gitignore \
        docker-compose.yml

    echo 'done.'
    echo

    printf "${HEAD} %-80s${NC}\n" 'Repository status'
    git status
    echo

    printf "${HEAD} %-80s${NC}\n" 'Next steps'
    echo 'Changes ready to be commited, please commit, and push with:'
    echo
    echo -e "    ${GREEN}git push origin prep-${1}${NC}"
    echo
fi
