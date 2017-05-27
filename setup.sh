#!/usr/bin/env bash
##  ------------------------------------------------------------------------  ##
##                     Build project working directory                        ##
##  ------------------------------------------------------------------------  ##
#
#   Script to initialize project
# - Install required node and bower packages
# - Install framework engine
# - Update framework installation with project's source scripts.
# - Deploy dist code into public web
# - Consist of:
#   -   usage
#   -   preSetupChecks
#   -   depsChecks
#   -   Build
#   -   Deploy

if [ -n "$APP_DEBUG" ]; then
    set -x
fi

set -e
trap 'echo >&2 Ctrl+C captured, exiting; exit 1' SIGINT

## Source settings
if [ -f ./setup.rc ]; then
    #. setup.rc
    source setup.rc
else
    exit 1
fi


function usage () {
    >&2 cat << EOM
            ${BWhite}Build application${NC}

Usage: $0 <command> [<params>]

    $0 <usage | help | h>   -   Show usage information
    $0 <test | t>           -   Perform environment tests
    $0 <prepare | prep | p> -   Install PHP, BOWER and NPM dependencies.
    $0 <build | b>          -   Build project directory
    $0 <deploy | d>         -   Sync sites public web directory (<webroot> by default)
    $0 <rebuild | rb>       -   Perform <build> and then <deploy> tasks

EOM
    RETVAL=1
}


##  ------------------------------------------------------------------------  ##
##                                PREREQUISITES                               ##
##  ------------------------------------------------------------------------  ##

OPTS=$@

WD="$(cd $(dirname $0) && pwd -P)"      #   Current working directory
APP_HOME="$(pwd)/"                      #   Current directory
APP_PATH="${APP_HOME}${APP_DIR}"        #   Full path to target directory
ENGINE_DIR="${ENGINE_NAME}-${ENGINE_VERSION}"
CODE_VERSION="$(cat ./VERSION)"
# WEB_USER="${WEB_USER}"

BUILD="${WD}/build"
SRC="${WD}/src"
DIST="${WD}/dist"

DATE="$(date +"%Y%m%d%H%M%S")"
DATETIME="$(date "+%Y-%m-%d")_$(date "+%H-%M-%S")"

# printf "\n----------------------------  ${DATE}  ---------------------------\n";

##  ------------------------------------------------------------------------  ##
##                                PRE-CHECKS                                  ##
##  ------------------------------------------------------------------------  ##

## Source functions
source bin/f.sh
source bin/f-engine.sh
source bin/f-node.sh
source bin/f-php-composer.sh
source bin/host-checks.sh


function preSetupChecks () {
    splash "$FUNCNAME(${@})";

    okNode
    okNpm
    okBower
    okGulp

}

info "WD = \t ${WD}";
info "BUILD = \t ${BUILD}";
info "SRC = \t ${SRC}";
info "CODE_VERSION = \t ${CODE_VERSION}";
info "APP_PATH = \t ${APP_PATH}";
info "ENGINE_DIR = \t ${ENGINE_DIR}";
info "WEB_USER = \t ${WEB_USER}";


##  ------------------------------------------------------------------------  ##
##                                 GIT HOOKS                                  ##
##  ------------------------------------------------------------------------  ##
##  printf "[info] Installing git hooks ... \n"
##  ln -sf ../../validate-commit-msg.js .git/hooks/commit-msg

##  ------------------------------------------------------------------------  ##
##                                 SCENARIO                                   ##
##  ------------------------------------------------------------------------  ##
##  1.  git clone https://github.com/tbaltrushaitis/mp3web.git -b "dev-1.0.2" mp3web
##  2.  sudo chown -R www-data:www-data mp3web && cd mp3web && sudo rights
##  3.  composer -vvv create-project --prefer-dist laravel/laravel laravel-5.2 "5.2.*"
##  4.  cp -pr laravel-5.2/ build/ && cd build && composer -vvv update && cd -
##  5.  ./setup.sh
##  6.  npm i && bower i

# deploy
#gulp sync:web
#gulp artisan:clear

#deploy -> sync:web, artisan:clear
# php artisan key:generate
##  ------------------------------------------------------------------------  ##
##                                 EXECUTION                                  ##
##  ------------------------------------------------------------------------  ##

function depsChecks () {
    splash "$FUNCNAME(${@})";

    check_composer
    sleep 1;

    check_engine
    sleep 1;

    # fix_permissions
    # sleep 1;

    deps_install
    sleep 1;
}

# check_git

# git_update
# sleep 1;

# deps_outdated
# sleep 1;


function Build () {
    splash "$FUNCNAME params: [${@}]";

    cd ${WD}
    gulp --env=${APP_ENV} #--verbose
    sleep 1;

    cd ${WD}
    mv -p "${BUILD}/.env" "${BUILD}/.env.${DATE}" 2>/dev/null
    cp -pr ./setup.rc "${BUILD}/.env.setup"
    cp -pr "${SRC}/composer.json" "${BUILD}/"
    sleep 1;

    cd ${BUILD}
    composer -v update
    sleep 1;

    cd ${WD}
    sudo chown -R "${WEB_USER}":"${WEB_USER}" "${BUILD}/"
    sleep 1;

}


function Deploy () {
    splash "$FUNCNAME [${@}]";

    cd ${WD}
    gulp sync:web --env=${APP_ENV} --verbose
    sleep 1;

    cd ${WD}
    cd "${WD}/${APP_DIR}/public/"
    ln -s ../storage/media/audio/ >&2 2>/dev/null
    sleep 1;

    cd ${WD}
    sudo chown -R ${WEB_USER}:${WEB_USER} "${APP_DIR}"
    sleep 1;

    gulp artisan:clear --env=${APP_ENV} --verbose
    sleep 1;

}


# gulp deploy  --env=dev --verbose

# gulp build
# gulp artisan

# gulp dist
# gulp deploy;

##  ------------------------------------------------------------------------  ##
##                                  EXECUTION                                 ##
##  ------------------------------------------------------------------------  ##
printf "\n-------------------------\t $0 $1 \t----------------------------\n";

case "$1" in

    "")
        splash "without params";
        usage
        RETVAL=0
    ;;

    "usage" | "h")
        splash "usage()";
        usage
        RETVAL=0
    ;;

    "test" | "t")
        splash "test()";
        preSetupChecks
        RETVAL=$?
    ;;

    "prepare" | "prep" | "p")
        splash "prepare()";
        depsChecks
        RETVAL=$?
    ;;

    "build" | "b")
        splash "build()";
        Build
        RETVAL=$?
    ;;

    "rebuild" | "rb")
        splash "REbuild()";
        Build
        Deploy
        RETVAL=$?
    ;;

    "deploy" | "d")
        splash "deploy()";
        Deploy
        RETVAL=$?
    ;;

    "all" | "a")
        splash "all()";
        preSetupChecks
        depsChecks
        Build
        Deploy
        RETVAL=$?
    ;;

    *)
        RETVAL=1
    ;;

esac

printf "\n\n[LOG]\tALL DONE\n"

exit $RETVAL

##  --------------------------  EOF: setup.sh  -----------------------------  ##
