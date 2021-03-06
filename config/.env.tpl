##  ------------------------------------------------------------------------  ##
##                          EDIT ONLY IN THIS FILE                            ##
##  ------------------------------------------------------------------------  ##

##  -----------------------------  METADATA  -------------------------------  ##
APP_NAME=mp3web
APP_HOME=mp3web
APP_BASE=/var/www/html/
APP_ENV=test
APP_KEY=base64:Xf1/esP3TCklX6q1gyzgVZYMrwAvFUDdUapaihIx87E=
APP_DEBUG=false
APP_LOG_LEVEL=warn
APP_URL=http://mp3web.gsm-center.com.ua

##  ---------------------------  WEB SERVICE  ------------------------------  ##
WEB_DIR=webroot
WEB_USER="www-data"
WEB_GROUP="www-data"

##  -----------------------------  ENGINE  ---------------------------------  ##
ENGINE_NAME=laravel
ENGINE_TAG=laravel
ENGINE_VERSION=5.5

##  ---------------------------  REPOSITORY  -------------------------------  ##
# REPO_HOST=https://github.com
REPO_HOST=https://bitbucket.org
REPO_USER=tbaltrushaitis
REPO_NAME=mp3web
REPO_BRANCH=latest

##  ---------------------------  DATABASE  ---------------------------------  ##
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE={{DB_NAME}}
DB_USERNAME={{DB_USER}}
DB_PASSWORD={{DB_PASS}}

##  ---------------------------  CHANNELING  --------------------------------  ##
BROADCAST_DRIVER=log
QUEUE_DRIVER=sync

##  -------------------------  IDENTIFICATION  -----------------------------  ##
CACHE_DRIVER=file
SESSION_DRIVER=file
SESSION_LIFETIME=120

##  -----------------------------  REDIS  ----------------------------------  ##
#REDIS_HOST=127.0.0.1
#REDIS_PASSWORD=null
#REDIS_PORT=6379

##  ------------------------------  MAIL  ----------------------------------  ##
#MAIL_DRIVER=smtp
#MAIL_HOST=smtp.mailtrap.io
#MAIL_PORT=2525
#MAIL_USERNAME=null
#MAIL_PASSWORD=null
#MAIL_ENCRYPTION=null

##  ---------------------------  PUBLISHER  --------------------------------  ##
# PUSHER_APP_ID=
# PUSHER_APP_KEY=
# PUSHER_APP_SECRET=
# PUSHER_APP_CLUSTER=mt1

## APP_DEBUG=`if [ "development" == "${APP_ENV}" ]; then echo true; else echo false; fi`

##  ------------------------------------------------------------------------  ##
