#!/usr/bin/env bash
#
# NAME
#     market_test.sh - Test of Market server Restful API.
#
#     Test of Market server Restful API.
#     You can see this application as a simple headless (no GUI) browser communication with microservice.
#     Start the market server before running this script.
#     No preflight request will be done.
#     A preflight request is automatically issued by a browser, when needed.
#
# SYNOPSIS
#     market_test.sh  [OPTIONS]
#
# OPTIONS
#     -u <username>
#                 Login username (mandatory)
#     -p <password>
#                 Login passsword (mandatory)
#     -o <host>
#                 Market server (default localhost)
#     -r <port>
#                 Market server port number. (default 50304)
#     -a <assetid>
#                 Asset id. Used to get asset by id.
#     -v
#                 Verbose
# Returns:
#     0 successful and <>0 for unsuccessful
#
# Note:
#     Install package curl and jq. For Mac try "brew install jq".
#
# Example:
#     This command will login and get asset with id 87180231.
#     bash market_test.sh -u test-dev@adtoox.com -p hemligt -1 -2    -4 -5 -6 -7 -8 -9 
#     bash market_test.sh -u ulf.haga@adtoox.com -p hemligt -1 -2 -3 -4 -5 -6    -8 -9  -a 87180231
#     bash market_test.sh -u ulf.haga@adtoox.com -p hemligt -o api-market-stage.adtoox.com -r 443 -t -1 -2 -4 -5 -6 -7 -8 -9  -a 80041006   
#     bash market_test.sh -t  -o api-market-ci.adtoox.com -r 443 -u test-dev@adtoox.com -n "v2" -p hemligt -1 -2 -3 -4 -5 -6 -7 -8 -9 -v
#

# Declare globals variables used in functions

shopt -s -o nounset # disallow the use of undefined variables

declare -r SCRIPT=${0##*/}  || exit 201;  # SCRIPT is the name of this script
declare -r CDIR=`dirname $0`

#declare -g -r NO_FORMAT="\033[0m"
#declare -g -r C_RED="\033[38;5;9m"

declare -g -r  PORT1=50304

declare -g -i port=${PORT1}

declare -g protocol=http

declare -g secure_protocol=false

declare -g -r COOKIE_JWT_SIGNATURE=mjwts
declare -g context='/v2/'

declare -g log=false
declare -g host=localhost
declare -g help=false

declare -g user_name
declare -g password
declare -g jwt
declare -g cookie_underskrift

declare -g first_asset
declare -g prefer_asset
declare -g user_id=3
declare -g user_agent=""

declare -g login_user_enable=true
declare -g get_user_me_enable=true
declare -g get_user_by_id_enable=true
declare -g asset_favorite_enable=true
declare -g list_assets_enable=true
declare -g publisher_list_assets_enable=true
declare -g get_publisher_assets_by_id_enable=true
declare -g relogin_enable=true
declare -g category_enable=true
declare -g logout_user_enable=true
declare -g create_user=false
declare -g create_destination=false
declare -g create_order=false
declare -g system_reset=false
declare -g sort_filter='?sortBy=Time%20Uploaded&sortOrder=Ascending&resultStartRange=0&resultEndRange=19'
declare -g create_storage_file=false;

#######################################
# Main
# Globals:
#   port
#   user_name
#   password
#   host
#   PORT1
#   help
#   login_user_enable
#   get_user_me_enable
#   publisher_list_assets_enable
#   list_assets_enable
#   relogin_enable
#   logout_user_enable
# Arguments:
#   None
# Returns:
#   None
#######################################
main() {

  # Initialize

  init "$@"

  # Tests

  if [ $system_reset = true ]; then
    system_reset
  fi

  if [ $create_user = true ]; then
    create_user
  fi

  if [ $create_storage_file = true ]; then
    create_storage_file
  fi

  if [ $create_destination = true ]; then
    create_destination
  fi

  if [ $create_order = true ]; then
    create_order
  fi

  if [ $login_user_enable = true ]; then
    validate_username_password
    login_user
  fi

  if [ $get_user_me_enable = true ]; then
    validate_username_password
    get_user_me
  fi

  if [ $asset_favorite_enable = true ]; then
    validate_username_password
    asset_favorite
  fi

  if [ $list_assets_enable = true ]; then
    validate_username_password
    list_assets
  fi

  if [ $publisher_list_assets_enable = true ]; then
    validate_username_password
    publisher_list_assets
  fi

  if [ $get_publisher_assets_by_id_enable = true ]; then
    validate_username_password
    get_publisher_assets_by_id
  fi

  if [ $relogin_enable = true ]; then
    validate_username_password
    relogin
  fi

  if [ $category_enable = true ]; then
    validate_username_password
    get_category
  fi

  if [ $get_user_by_id_enable = true ]; then
    validate_username_password
    get_user_by_id
  fi

  if [ $logout_user_enable = true ]; then
    validate_username_password
    logout_user
  fi

  printf \\n\\r

  if [[ $log = true ]]; then
    printf "**************END************************"\\n\\r
  fi

}

#######################################
# printf_test - Print the name of the test to the console
# 
# Arguments:
#   message
#
# Returns:
#   None
printf_test()
{
  local NO_FORMAT="\033[0m"
  local C_BLUE="\033[38;5;12m"
  local F_UNDERLINED="\033[4m"
  printf "\n**************${F_UNDERLINED}${C_BLUE}${1}${NO_FORMAT}**************\n"
}

#######################################
# printf_error - Print error message to console
# 
# Arguments:
#   message
#
# Returns:
#   None
printf_error()
{
  local NO_FORMAT="\033[0m"
  local C_RED="\033[38;5;9m"
  printf "${C_RED}${1}${NO_FORMAT}\n"
}

#######################################
# validate_username_password - Validation
# Globals:
# user_name
# password
# 
# Returns:
#   None
validate_username_password(){
  if [[ -z ${user_name} ]]; then
    printf_error "The user name must is missing in the argumment. Print help with ./market_test.sh  -h "
    exit 1
  fi

  if [[ -z ${password} ]]; then
    printf_error "The password must is missing in the argumment. Print help with ./market_test.sh  -h "
    exit 1
  fi
}
#######################################
# init - Initialize
# Globals:
#   port
#   user_name
#   password
#   host
#   user_id
#   prefer_asset
#   get_user_me_enable
#   logout_user_enable
#   list_assets_enable
#   asset_favorite_enable
#   relogin_enable
#   publisher_list_assets_enable
#   get_publisher_assets_by_id_enable
#   category_enable
#   logout_user_enable
#   create_storage_file
#   create_order
#   create_destination
#   create_user
#   system_reset
#   help
#   log
# Arguments:
#   Shell parameters
# Returns:
#   None
init() {
  # Arguments
  while getopts z:n:s:i:p:a:u:o:r:hvbcdeft0123456789 option; do
    case "${option}" in

      a) prefer_asset=${OPTARG} ;;
      b) system_reset=true ;;
      c) create_user=true ;;
      d) create_destination=true ;;
      e) create_order=true ;;
      f) create_storage_file=true;;
	  h) help=true ;;
      i) user_id=${OPTARG} ;;
	  n) context='/'${OPTARG}'/' ;;
      o) host=${OPTARG} ;;
	  p) password=${OPTARG} ;;
	  u) user_name=${OPTARG} ;;
      r) port=${OPTARG} ;;
      s) sort_filter=${OPTARG};;
	  t) protocol=https ;;
	  z) user_agent=${OPTARG};;
	  v) log=true ;;

      0) login_user_enable=false ;;
      1) get_user_me_enable=false ;;
      2) get_user_by_id_enable=false ;;
      3) list_assets_enable=false ;;
      4) asset_favorite_enable=false ;;
      5) relogin_enable=false ;;
      6) publisher_list_assets_enable=false ;;
      7) get_publisher_assets_by_id_enable=false ;;
      8) category_enable=false ;;
      9) logout_user_enable=false ;;

    esac
  done

  if [ $help = true ]; then
    printf "\nNAME\n"
    printf "\t${SCRIPT} - Test of Market server Restful API.\n"
    printf "SYNOPSIS\n"
    printf "\t${SCRIPT}  [OPTIONS]\n"
    printf "OPTIONS\n"
    printf "\t-u\t username (mandatory)\n"
    printf "\t-p\t password (mandatory)\n"
    printf "\t-o\t host (default localhost) \n"
    printf "\t-r\t port (default 50304)\n"
	printf "\t-n\t Context  (default v2) \n"
	printf "\t-t\t use Hypertext Transfer Protocol Secure (HTTPS)\n"
    printf "\t-s\t sort filter \n"
    printf "\t-a\t prefer asset (get asset by id)\n"
    printf "\t-b\t reset\n"
    printf "\t-c\t create user\n"
    printf "\t-d\t create destination \n"
    printf "\t-e\t create order\n"
    printf "\t-f\t create storage file\n"
    printf "\t-i\t user by id\n"
	printf "\t-z\t user agent\n"
    printf "\t-0\t disable - login (/oauth/login) \n"
    printf "\t-1\t disable - get user information (/users/me) \n"
    printf "\t-2\t disable - get user by id (/users/{userId}) \n"
    printf "\t-3\t disable - lh/publisher/asset/publisher/asset)\n"
    printf "\t-4\t disable - set publisher asset favorite (/publisher/asset/{assetId}/favorite) \n"
    printf "\t-5\t disable - relogin (/oauth/refresh)  \n"
    printf "\t-6\t disable - get publisher by asset's id and with filter (/publisher/asset/{assetId}/?sortBy=TimeUploaded&sortOrder=Ascending&resultStartRange=0&resultEndRange=19) \n"
    printf "\t-7\t disable - get publisher by asset's id (/publisher/asset/{assetId}) \n"
    printf "\t-8\t disable - get category (/category) \n"
    printf "\t-9\t disable - logout user  \n"
    printf "\t-v\t verbose\n"
    printf "\nEXAMPLES\n"
	printf "\tComponent tests on your local PC (advanced):\n"
    printf "\t${SCRIPT} -u container-test-user@adtoox.com  -p hemligt -b -c -d -e -f   -2 \n"
    printf "\t${SCRIPT} -u container-test-user@adtoox.com  -p hemligt -c -d -e -f -1 -2 -4 -5 -6 -7 -8 -9  \n"
    printf "\t${SCRIPT} -u container-test-user@adtoox.com  -p hemligt -a 1 -i 1 -1 -2 -3 -4 -5 -6 -8 -9 \n"
    printf "\t${SCRIPT} -u ulf.haga@adtoox.com -p  Kaka123  \n"
    printf "\t${SCRIPT} -u ulf.haga@adtoox.com -p  Kaka123 -o localhost -r 50304   \n"
    printf "\t${SCRIPT} -u ulf.haga@adtoox.com -p  Kaka123 -o localhost -r 50304  -1 -2 -4 -5 -6 -7 -8 -9 -a 87180231  \n"
    printf "\t${SCRIPT} -u test-dev@adtoox.com -p hemligt -a 87089971 -1 -2 -4 -5 -6 -7 -8 -9 \n"
    printf "\t${SCRIPT} -u test-dev@adtoox.com -p hemligt  -1 -2 -3 -4 -5  -7 -8 -9  -s '?sortBy=Time%%20Uploaded' "
    printf "\n"
    printf "\tSet favorite for asset 87089971 and get all favorite assets:\n"
    printf "\t${SCRIPT} -u test-dev@adtoox.com -p hemligt -a 87089971 -1 -2 -3 -4 -5  -7 -8 -v  -s '?sortBy=Time%%20Uploaded&sortOrder=Ascending&resultStartRange=0&resultEndRange=19&favoriteFilter=true'"
    printf "\n"
    printf "\tTests on CI environment:\n"
	printf "\t${SCRIPT} -t -o api-market-ci.adtoox.com -r 443 -u test-dev@adtoox.com -n v2 -p hemligt -1 -2  -4 -5 -6 -7 -8 -9" 
    printf "\n\n"
 
    exit 0
  fi

  # Scan for listening daemons
  if [[ ${log} = true ]]; then
    printf "Check if server is listing for %q:%q. Take max 30 seconds.\n"  ${host} ${port} ;
  fi

  if [[ -n "${user_agent}" ]]; then
	 user_agent="-A ${user_agent}" 
  fi

  
  declare -i -r is_server_listen=$(nc -z  ${host} ${port} && echo 0 || echo 1);

  if [[ ${is_server_listen} == 0 ]] ; then
    if [[ ${log} = true ]]; then
      printf "Server is listing for %q:%q. Take max 30 seconds.\n"  ${host} ${port} ;
    fi
  else
    printf 'ERROR: No server is listen!'
    exit 26;
  fi
}

#######################################
# system_reset
# Globals:
#   port
#   host
# Arguments:
#   None
# Returns:
#   None
#######################################
system_reset() {
  printf "\\n\\r"

  printf_test "System reset"

  local url="${protocol}://$host:$port${context}system/reset"

  local response=$(curl ${user_agent} -c - -s -X DELETE "${url}" -H "Access-Control-Allow-Credentials: true" -H "accept: text/plain" -H "Content-Type: text/plain"  | sed '/^$/d')

  if [[ $log = true ]]; then
    printf "Request URL ${url}\n"
  fi
  echo $response
}


#######################################
# create_user
# Globals:
#   port
#   user_name
#   password
#   host
# Arguments:
#   None
# Returns:
#   None
#######################################
create_user() {
  printf \\n\\r
  printf_test "Create user"
  printf "Create user to Market server with user ${user_name}:\n"

  local url="${protocol}://$host:$port${context}users/1"
  local data='{
  "username": "'"${user_name}"'",
  "password": "'"$password"'",
  "firstName": "Jenny",
  "lastName": "jorander",
  "companyName": "Adtoox",
  "userRoles": {
  "producer": "true"
},
"email": "$user_name"
  }'

  local response=$(curl ${user_agent}  -c - -s -X PUT "${url}"  -H "accept: */*" -H "Content-Type: application/json; charset=UTF-8" -d "${data}" | sed '/^$/d')

  if [[ $log = true ]]; then
    printf "Request URL ${url}\n"
  fi

}

#######################################
# create_destination
# Globals:
#   port
#   host
# Arguments:
#   None
# Returns:
#   None
#######################################
create_destination() {
  printf "\\n\\r"

  printf_test "Create destination"
  printf "Create a destination\\n\\r"

  local url="${protocol}://$host:$port${context}destinations/1" 
  local data='{ "displayName": "mydistination" }'
  local response=$(curl ${user_agent}  -c - -s -X PUT "${url}" -H "accept: */*" -H "Content-Type: application/json" -d "${data}" | sed '/^$/d')

  if [ $log = true ]; then
    printf "Request URL ${url}\n"
  fi
}

#######################################
# create_storage_file
# Globals:
#   port
#   host
# Arguments:
#   None
# Returns:
#   None
#######################################
create_storage_file() {
  printf "\\n\\r"

  printf_test "Create storage file"
  printf "Create a storage file\n"

  local url="${protocol}://$host:$port${context}storagefiles/1"
  local data='{"url": "${protocol}://www.adtoox.com"}'
  local response=$(curl ${user_agent}  -c - -s -X PUT "${url}" -H "accept: */*" -H "Content-Type: application/json" -d "${data}" | sed '/^$/d')

  if [ $log = true ]; then
    printf "Request URL ${url}\n"
  fi
}

#######################################
# create_order
# Globals:
#   port
#   host
# Arguments:
#   None
# Returns:
#   None
#######################################
create_order() {
  printf "\\n\\r"
  printf_test "Create order"
  printf "Create a order\\n\\r"

  local data='{
  "title": "mytitle",
  "copyCode": "S1TZAA153200000000",
  "countryCode": "se",
  "expressBrand": {
  "advertiser": "Adoox",
  "brand": "AdtooxBrand"
},
"expressOrderMaterial": {
"duration": "30",
"timeDelivered": "1985-04-12T23:20:50.52Z",
"uploaded": {
"userName": "container-test-user@adtoox.com",
"firstName": "Jenny",
"lastName": "Linde",
"companyName": "Adtoox",
"activityDateTime": "2017-10-02T01:30+01:00"
		},
		"previewImage": {
		"storageFileId":"1",
		"url": "http://www.adtoxx.com/my.jpg",
		"mimetype": "jpg",
		"width": "480",
		"height": "680"
	      },
	      "previewVideo": {
	      "storageFileId":"1",
	      "url": "HTTP://www.adtoox.com/my.mp4",
	      "mimetype": "mp4",
	      "width": 640,
	      "height": 480
	    },
	    "deliveryApprovedToStart": {
	    "userName": "container-test-user@adtoox.com",
	    "firstName": "container-test-user",
	    "lastName": "container-test-user",
	    "companyName": "Adtoox",
	    "activityDateTime": "1985-04-12T23:20:50.52Z"
	  },
	  "remoteid": "1"
	},
	"expressDestination": {
	"id": "1",
	"displayname": "HelloAdtoox"
      },
      "expressCampaignPeriod": {
      "firstAirdate": "1985-04-12T23:20:50.52Z",
      "lastAirdate": "1985-04-12T23:20:50.52Z"
    }
  }'

  local response=$(curl ${user_agent}  -c - -s -X PUT "${protocol}://$host:$port${context}orders/1"  -H "accept: */*" -H "Content-Type: application/json; charset=UTF-8" -d "${data}" | sed '/^$/d')

  if [ $log = true ]; then
    printf "Request URL ${protocol}://$host:$port/${CONTEXT}/integration/orders/createorder\n"
  fi

}

#######################################
# login_user
# Globals:
#   port
#   user_name
#   password
#   host
#   COOKIE_JWT_SIGNATURE
#   cookie_underskrift
#   jwt
# Arguments:
#   None
# Returns:
#   None
#######################################
login_user() {
  printf "\n\r"
  printf_test "Login"
  printf "Login to Market server with user $user_name:\n"
  local body="{\"username\": \"$user_name\", \"password\": \"$password\"}"

  local login_response=$(curl ${user_agent} -c - -s -X POST "${protocol}://$host:$port${context}oauth/login" -H "Access-Control-Allow-Credentials: true" -H "accept: application/json" -H "Content-Type: application/json" -d "${body}" | sed '/^$/d')

  if [ $log = true ]; then
    printf "Request URL ${protocol}://$host:$port${context}oauth/login\n"
    printf "Request body:\n"
	echo "${body}"
	printf "\n"
  fi

  # Note the sign " around sed reg expression may be a ' in Linux.
  cookie_underskrift=$(echo ${login_response} | sed "s/.*\\${COOKIE_JWT_SIGNATURE}\(.*\)$/\1/g")
  jwt=$(echo $login_response | sed "s/.*Bearer \(.*\)\".*/\1/g")

  if [ $log = true ]; then
    printf "Login response:\n"
    printf "${login_response}\n"
  fi

  if [[ "$jwt" =~ ^[A-Za-z0-9_=]+\.[A-Za-z0-9_=]+$ ]]; then
    printf \\n\\r
    printf "Login successful!\n"
  else
    printf \\n\\r
    printf "Error. login unsuccessful!\n"
    exit 3
  fi

  if [ $log = true ]; then
    printf "JWT header and payload:\n"
    printf \\n\\r
    printf ${jwt}
  fi

  jwt=$(echo $login_response | sed "s/.*Bearer \(.*\)\".*/\1/g")

  if [ $log = true ]; then
    printf \\n\\r
    printf \\n\\r
    printf "JWT signature in Cookie ${COOKIE_JWT_SIGNATURE}:"
    printf \\n\\r
    printf $cookie_underskrift
    printf \\n\\r
  fi

  local regex=^[[:blank:]]*[A-Za-z0-9_=-]*[[:blank:]]*$
  if [[ ${cookie_underskrift} =~ $regex ]]; then
    printf 'cookie successful\n'
  else
    printf 'Error: Cookie value is incorrect. \njwt:%s \ncookie:%s\n' ${jwt} ${cookie_underskrift}
    exit 4
  fi

}

#######################################
# get_user_me
# Globals:
#   port
#   user_name
#   password
#   host
#   COOKIE_JWT_SIGNATURE
#   cookie_underskrift
#   jwt
# Arguments:
#   None
# Returns:
#   None
#######################################
get_user_me() {
  printf \\n\\r
  printf_test "User me"
  printf "Ask the Market server about my email address."\\n\\r

  if [ -z $jwt ]; then
    printf "\n\nNo JWT in the response:"
    exit 5
  else

    local me_response=$(curl ${user_agent}  -s -X GET "${protocol}://$host:$port${context}users/me" -H "cookie:${COOKIE_JWT_SIGNATURE}=$cookie_underskrift ; Version=1; Path=/; Discard; HttpOnly; Comment=Market token" -H "Authorization: Bearer $jwt" -H "accept: application/json,text/plain" -H "Content-Type: application/json" -H "User-Agent: Curl" -H "Connection: keep-alive")
    if [ $log = true ]; then
      printf "Request URL ${protocol}://$host:$port${context}users/me"
      printf \\n\\r
      printf "Response body:"
      printf \\n\\r
      printf $me_response
      printf \\n\\r
    fi

    local email=$(echo $me_response | sed 's/.*email\":\"\(.*\)\",.*/\1/g')

    if [[ "$email" =~ .+@.+\..+ ]]; then
      printf \\n\\r
      printf 'Your email is:%s\n' $email
      printf "Getting email is successful!\n"
    else
      printf \\n\\r
      printf "Getting email is unsuccessful! Is is $email"
      exit 6
    fi
  fi
  printf \\n\\r
}


#######################################
# get_user_by_id
# Globals:
#   port
#   user_name
#   password
#   host
#   url
#   COOKIE_JWT_SIGNATURE
#   cookie_underskrift
#   jwt
# Arguments:
#   None
# Returns:
#   None
#######################################
get_user_by_id() {
  printf \\n\\r
  printf_test "User by id ${user_id}"
  printf "Ask the Market server about my email address."\\n\\r

  if [ -z $jwt ]; then
    printf "\n\nNo JWT in the response:"
    exit 16
  else
    local url="${protocol}://$host:$port${context}users/${user_id}"
    local user_by_id_response=$(curl ${user_agent}  -s -X GET "${url}" -H "cookie:${COOKIE_JWT_SIGNATURE}=$cookie_underskrift ; Version=1; Path=/; Discard; HttpOnly; Comment=Market token" -H "Authorization: Bearer $jwt" -H "accept: application/json,text/plain" -H "Content-Type: application/json" -H "User-Agent: Curl" -H "Connection: keep-alive")
    if [ $log = true ]; then
      printf "Request URL: ${url}"
      printf \\n\\r
      printf "Response body:"
      printf \\n\\r
      printf $user_by_id_response
      printf \\n\\r
    fi
    if [ -x "$(command -v jq)" ]; then
      email=$(echo $user_by_id_response | jq '.email')
      printf 'Your email is:%s\n' $email
    fi
  fi
}

#######################################
# relogin
# Globals:
#   port
#   user_name
#   password
#   host
#   COOKIE_JWT_SIGNATURE
#   cookie_underskrift
#   jwt
# Arguments:
#   None
# Returns:
#   None
#######################################
relogin() {
  printf \\n\\r
  printf \\n\\r
  printf_test "Refresh"
  printf "ReLogin to Market server with the OAuth2 refresh token in the JWT :"\\n\\r
  assetsResponse=$(curl ${user_agent}  -c - -s -X GET "${protocol}://$host:$port${context}oauth/refresh" -H "cookie:${COOKIE_JWT_SIGNATURE}=$cookie_underskrift ; Version=1; Path=/; Discard; HttpOnly; Comment=Market token" -H "Authorization: Bearer $jwt" -H "Access-Control-Allow-Credentials: true" -H "accept: application/json" -H "Content-Type: application/json" | sed '/^$/d')

  if [ $log = true ]; then
    printf "Request URL ${protocol}://$host:$port${context}oauth/refresh"
    printf \\n\\r
    printf ${assetsResponse}
  fi

  printf ${assetsResponse}

  # Note the sign " around sed reg expression may be a ' in Linux.
  cookie_underskrift=$(echo ${assetsResponse} | sed "s/.*\\${COOKIE_JWT_SIGNATURE}\(.*\)$/\1/g")
  jwt=$(echo $assetsResponse | sed "s/.*Bearer \(.*\)\".*/\1/g")

  if [[ "$jwt" =~ ^[A-Za-z0-9_=]+\.[A-Za-z0-9_=]+$ ]]; then
    printf \\n\\r
    printf \\n\\r
    echo "Refresh successful!"
  else
    printf \\n\\r
    echo "Refresh unsuccessful!"
    exit 7
  fi

  if [ $log = true ]; then
    printf \\n\\r
    printf "JWT header and payload:"
    printf \\n\\r
    printf $jwt
    printf \\n\\r
  fi

  if [ $log = true ]; then
    printf \\n\\r
    printf \\n\\r
    printf "JWT signature in Cookie ${COOKIE_JWT_SIGNATURE}:"
    printf \\n\\r
    printf ${cookie_underskrift}
    printf \\n\\r
  fi
}

#######################################
# list_assets
# Globals:
#   port
#   user_name
#   password
#   host
#   COOKIE_JWT_SIGNATURE
#   cookie_underskrift
#   jwt
# Arguments:
#   None
# Returns:
#   None
#####################################
list_assets() {
  printf_test "List Asset"
  printf "Get assets from Market server\n"
  if [ -z $jwt ]; then
    printf "No JWT available. You have to login first. \n"
    exit 10
  else
    local assetsResponse=$(curl ${user_agent}  -s -X GET "${protocol}://$host:$port${context}publisher/asset?sortBy=Time%20Uploaded&sortOrder=Ascending&resultStartRange=0&resultEndRange=19" -H "cookie:${COOKIE_JWT_SIGNATURE}=$cookie_underskrift ; Version=1; Path=/; Discard; HttpOnly; Comment=Market token" -H "Authorization: Bearer $jwt" -H "Access-Control-Allow-Credentials: true" -H "accept: application/json" -H "Content-Type: application/json" | sed '/^$/d')
    if [[ ${log} = true ]]; then
      printf "Request URL ${protocol}://$host:$port${context}publisher/asset"
      printf \\n\\r
      printf "\nresponse:\n"
      echo $assetsResponse
      printf \\n\\r
    fi
    printf \\n\\r
    local regex='(^{"totalNoOfAssets":.*)'
    if [[ "$assetsResponse" =~ $regex ]]; then
      if [ -x "$(command -v jq)" ]; then
	totalNoOfAssets=$(echo $assetsResponse | jq '.totalNoOfAssets')
	printf "Total no of assets %s\n" "$totalNoOfAssets"
	retrievedAssets==$(echo $assetsResponse | jq '.retrievedAssets')
	first_asset=$(echo $assetsResponse | jq '.retrievedAssets[0].id' | tr -d '"')
	printf "The first asset id: %s\n" "$first_asset"
      fi
      printf 'Get assets successful!'
    else
      printf 'Error wrong response:\n'
      echo $assetsResponse
      exit 8
    fi
  fi
}

#######################################
# publisher_list_assets
# Globals:
#   port
#   user_name
#   password
#   host
#   COOKIE_JWT_SIGNATURE
#   cookie_underskrift
#   jwt
# Arguments:
#   None
# Returns:
#   None
#####################################
publisher_list_assets() {
  printf_test "Publisher List Asset with sort filter"
  printf "Get assets from Market server.\n";

  if [[ -z "${jwt}" ]]; then
    printf "No JWT available. You have to login first. \n"
    exit 10
  else

    local url="${protocol}://$host"':'"$port"'/'"${context}"'/publisher/asset'${sort_filter} 

    local assetsResponse=$(curl ${user_agent}  -s -X GET "${url}" -H "cookie:${COOKIE_JWT_SIGNATURE}=$cookie_underskrift ; Version=1; Path=/; Discard; HttpOnly; Comment=Market token" -H "Authorization: Bearer $jwt" -H "Access-Control-Allow-Credentials: true" -H "accept: application/json" -H "Content-Type: application/json" | sed '/^$/d')


    if [[ "$log" == "true" ]]; then
      printf "Request URL: %s\n" ${url}
      printf "\nResponse:\n"
      echo $assetsResponse
      printf \\n\\r
    fi
    printf \\n\\r

    if [[ -x "$(command -v jq)" ]]; then

      local number_of_assets=$(echo ${assetsResponse} | jq '.totalNoOfAssets' )
      printf "Number of assets:%s\n"  ${number_of_assets}

      number_of_assets=$(echo ${assetsResponse} | jq '.retrievedAssets | length')
      printf "Number of assets in the response:%s\n"  ${number_of_assets}

      local counter=0
      while [[ "$counter" -lt "${number_of_assets}" ]]; do
	printf \\n\\r
	local first_asset=$(echo $assetsResponse | jq ".retrievedAssets[${counter}].id")
	printf "Asset id:%s\n" "$first_asset"

	local assets_copyCode=$(echo $assetsResponse | jq ".retrievedAssets[${counter}].copyCode")
	printf "Asset CopyCode:%s\n" "${assets_copyCode}"

	local assets_title=$(echo $assetsResponse | jq ".retrievedAssets[${counter}].title")
	printf "Asset title:%s\n" "$assets_title"

	((counter++))
      done
    fi
  fi
}

#######################################
# get_publisher_assets_by_id
# Globals:
#   port
#   user_name
#   password
#   host
#   COOKIE_JWT_SIGNATURE
#   cookie_underskrift
#   jwt
#   first_asset
#   prefer_asset
# Arguments:
#   None
# Returns:
#   None
#####################################
get_publisher_assets_by_id() {
  printf_test "Publisher Asset by id"

  if [ -z ${prefer_asset} ]; then
    if [ ! -z ${first_asset} ]; then
      local asset_id=${first_asset}
    fi
  else
    local asset_id=${prefer_asset}
  fi

  if [ -z ${asset_id} ]; then
    printf "\nNo asset id is specified. Use the option -a <asset id>\n"
  else
    printf "Get asset by id %s from Market server." ${asset_id}

    local assetsResponse=$(curl ${user_agent}  -s -X GET "${protocol}://$host:$port${context}publisher/asset/${asset_id}" -H "cookie:${COOKIE_JWT_SIGNATURE}=$cookie_underskrift ; Version=1; Path=/; Discard; HttpOnly; Comment=Market token" -H "Authorization: Bearer $jwt" -H "Access-Control-Allow-Credentials: true" -H "accept: application/json" -H "Content-Type: application/json" | sed '/^$/d')

    if [ $log = true ]; then
      printf "Request URL ${protocol}://$host:$port${context}publisher/asset/%s" ${asset_id}
      printf \\n\\r
      printf "\nresponse:\n"
      echo $assetsResponse
      printf \\n\\r
    fi
    printf \\n\\r

    local regex=^[[:blank:]]?\{.*\}[[:blank:]]?$
    if [[ "$assetsResponse" =~ $regex ]]; then
      if [ -x "$(command -v jq)" ]; then

	printf "Some data from the response:\n"
	local asset_id=$(echo $assetsResponse | jq '.id')
	printf "id:%s\n" "$asset_id"

	local asset_title=$(echo $assetsResponse | jq '.title')
	printf "title:%s\n" "$asset_title"

	local asset_copycode=$(echo $assetsResponse | jq '.copycode')
	printf "copycode:%s\n" "$asset_copycode"

	local asset_uploadDateTime=$(echo $assetsResponse | jq '.uploaded.dateTime')
	printf "uploadDateTime:%s\n" "$asset_uploadDateTime"

	local asset_description=$(echo $assetsResponse | jq '.description')
	printf "description:%s\n" "$asset_description"

	local asset_licencePeriod=$(echo $assetsResponse | jq '.licencePeriod')
	printf "licencePeriod:%s\n" "$asset_licencePeriod"

	if [ $log = true ]; then
	  local asset_videos=$(echo $assetsResponse | jq '.previewVideos')
	  printf "First videoEssences.video.url:%s\n" "$asset_videos"
	fi

	local asset_video_url=$(echo $assetsResponse | jq -r '.previewVideos[0].video.url')
	printf "First video url (videoEssences.video.url): %s\n" "$asset_video_url"

	if [[ $(wget -q --progress=dot -P videos $asset_video_url) -eq 0 ]]; then
	  printf "File downloaded in folder videos."
	else
	  printf "Warning. File not downloaded."
	fi

      fi
    else
      printf 'Error wrong response:\n'
      echo $assetsResponse
      exit 20
    fi
  fi
}

#######################################
# get_category
# Globals:
#   port
#   user_name
#   password
#   host
#   COOKIE_JWT_SIGNATURE
#   cookie_underskrift
#   jwt
# Arguments:
#   None
# Returns:
#   None
#######################################
get_category() {
  printf "\n"
  printf_test "Category"
  printf "Ask the Market server to list categories.\n"

  if [ -z $jwt ]; then
    printf "No JWT available. You have to login first. \n"
    exit 5
  else
    local url="${protocol}://$host:$port${context}category"

    local category_response=$(curl ${user_agent}  -s -X GET ${url} -H "cookie:${COOKIE_JWT_SIGNATURE}=$cookie_underskrift ; Version=1; Path=/; Discard; HttpOnly; Comment=Market token" -H "Authorization: Bearer $jwt" -H "accept: application/json,text/plain" -H "Content-Type: application/json" -H "User-Agent: Curl" -H "Connection: keep-alive")
    if [ $log = true ]; then
      printf "Request URL ${url}"
      printf \\n\\r
      printf "Response body:"
      printf \\n\\r
      printf $category_response
      printf \\n\\r
    fi

    if [ -x "$(command -v jq)" ]; then

      first_nr_catgories=$(echo $category_response | jq '. | length')
      printf "Number of categories id:%s\n" "${first_nr_catgories}"

      first_system_name=$(echo $category_response | jq '.[0].systemName')
      printf "Value of the name systemName for the first category:%s\n" "$first_system_name"

      first_display_name=$(echo $category_response | jq '.[0].displayName')
      printf "Value of the name displayName for the first category:%s\n" "$first_display_name"

      first_nr_subcatgories=$(echo $category_response | jq '.[0].subCategories | length')
      printf "Number of subcategories id:%s\n" "${first_nr_subcatgories}"
    fi

  fi
  printf \\n\\r
}

#######################################
# logout_user
# Globals:
#   port
#   user_name
#   password
#   host
#   COOKIE_JWT_SIGNATURE
#   cookie_underskrift
#   jwt
# Arguments:
#   None
# Returns:
#   None
#####################################
logout_user() {
  #
  # Logout
  #
  printf \\n\\r
  printf \\n\\r
  printf_test "Logout"
  printf "Logout from Market server\n"
  logoutResponse=$(curl ${user_agent}  -o - -c - -s -X DELETE "${protocol}://$host:$port${context}oauth/logout" -H "Access-Control-Allow-Credentials: true" -H "cookie:${COOKIE_JWT_SIGNATURE}=$cookie_underskrift ;  Version=1; Path=/; Discard; HttpOnly; Comment=Market token" -H "Authorization: Bearer $jwt")

  if [ $log = true ]; then
    printf "Request URL ${protocol}://$host:$port${context}oauth/logout"
    printf "\nResponse:\n"
    printf "%q" $logoutResponse
    printf "\n"
  fi

  # Note the sign " around sed reg expression may be a ' in Linux.
  cookie_underskrift=$(echo ${logoutResponse} | sed "s/.*\\${COOKIE_JWT_SIGNATURE}\(.*\)$/\1/g")

  if [[ -z ${cookie_underskrift} ]]; then
    printf \\n\\r
    printf "No cookie value in the response:"
    exit 9
  fi

  local regex=^[[:blank:]]?invalid_signature[[:blank:]]?$
  if [[ ${cookie_underskrift} =~ $regex ]]; then
    printf 'Logout successful'
  else
    printf 'Error: Cookie value is incorrect.'
    echo ${cookie_underskrift}
    exit 10
  fi

}


#######################################
# asset_favorite
# Globals:
#   port
#   user_name
#   password
#   host
#   COOKIE_JWT_SIGNATURE
#   cookie_underskrift
#   jwt
# Arguments:
#   None
# Returns:
#   None
#####################################
asset_favorite() {
  printf_test "Set asset favorite"

  if [ -z ${prefer_asset} ]; then
    if [ ! -z ${first_asset} ]; then
      local asset_id=${first_asset}
    fi
  else
    local asset_id=${prefer_asset}
  fi

  if [ -z ${asset_id} ]; then
    printf "\nNo asset id is specified. Use the option -a <asset id>\n"
  else
    printf "Asset id: %s\n" ${asset_id}
    local url="${protocol}://$host:$port${context}publisher/asset/${asset_id}/favorite"
    local favoriteResponse=$(curl ${user_agent}  -c -  -i -s  -X PUT "${url}" -H "cookie:${COOKIE_JWT_SIGNATURE}=$cookie_underskrift ; Version=1; Path=/; Discard; HttpOnly; Comment=Market token" -H "Authorization: Bearer $jwt" -H "Access-Control-Allow-Credentials: true" -H "accept: application/json" -H "Content-Type: application/json" | sed '/^$/d')

    if [ $log = true ]; then
      printf "Request URL ${url}\n" ${asset_id}
      printf "\nResponse:\n"
      printf "%q" $favoriteResponse
      printf \\n\\r
    fi

    if [ $log = false ]; then
      printf "Request URL ${url}\n" ${asset_id}
      printf "Response:\n"
      echo -e $favoriteResponse
      printf \\n\\r
    fi
    printf \\n\\r
  fi
}

main "$@"


