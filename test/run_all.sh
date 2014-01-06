echo_and_run() { echo "$ $@" ; "$@" ; echo -e "\n" ;}

CID=cccccccccccc
LID=llllllllllll
TID=tttttttt
EMAIL="test@example.com"
REQUESTBIN="http://requestb.in/xxxxxxx" #go to requestb.in and create new page
RANDOM_NAME="Random Name"

### ------------------------------
### CAMPAIGNS (15)
### ------------------------------
echo_and_run bundle exec bin/mc --list=$LID campaigns content $CID
echo_and_run bundle exec bin/mc --list=$LID campaigns create
echo_and_run bundle exec bin/mc --list=$LID campaigns delete
echo_and_run bundle exec bin/mc --list=$LID campaigns list
echo_and_run bundle exec bin/mc --list=$LID campaigns ready
echo_and_run bundle exec bin/mc --list=$LID campaigns replicate
echo_and_run bundle exec bin/mc --list=$LID campaigns resume
echo_and_run bundle exec bin/mc --list=$LID campaigns schedule
echo_and_run bundle exec bin/mc --list=$LID campaigns schedule-batch
echo_and_run bundle exec bin/mc --list=$LID campaigns segment-test
echo_and_run bundle exec bin/mc --list=$LID campaigns send
echo_and_run bundle exec bin/mc --list=$LID campaigns send-test
echo_and_run bundle exec bin/mc --list=$LID campaigns template-content
echo_and_run bundle exec bin/mc --list=$LID campaigns unschedule
echo_and_run bundle exec bin/mc --list=$LID campaigns update

### ------------------------------
### ECOMM (3)
### ------------------------------
echo_and_run bundle exec bin/mc --list=$LID ecomm add --order_id 1000 --store_id 1000 --email $EMAIL --total 5
echo_and_run bundle exec bin/mc --list=$LID ecomm orders
echo_and_run bundle exec bin/mc --list=$LID ecomm delete --order_id 1000 --store_id 1000

### ------------------------------
### GALLERY (1)
### ------------------------------
echo_and_run bundle exec bin/mc --list=$LID gallery list

### ------------------------------
### HELPER (10)
### ------------------------------
echo_and_run bundle exec bin/mc --list=$LID helper account
echo_and_run bundle exec bin/mc --list=$LID helper apikey
echo_and_run bundle exec bin/mc --list=$LID helper campaigns-for-email $EMAIL
echo_and_run bundle exec bin/mc --list=$LID helper chatter
echo_and_run bundle exec bin/mc --list=$LID helper default-list
echo_and_run bundle exec bin/mc --list=$LID helper last-campaign
echo_and_run bundle exec bin/mc --list=$LID helper lists-for-email $EMAIL
echo_and_run bundle exec bin/mc --list=$LID helper ping
echo_and_run bundle exec bin/mc --list=$LID helper userid
echo_and_run bundle exec bin/mc --list=$LID helper verified

### ------------------------------
### LISTS (26)
### ------------------------------
echo_and_run bundle exec bin/mc --list=$LID lists abuse-reports
echo_and_run bundle exec bin/mc --list=$LID lists clients
echo_and_run bundle exec bin/mc --list=$LID lists group
echo_and_run bundle exec bin/mc --list=$LID lists grouping
echo_and_run bundle exec bin/mc --list=$LID lists growth
echo_and_run bundle exec bin/mc lists list
echo_and_run bundle exec bin/mc --list=$LID lists locations
echo_and_run bundle exec bin/mc --list=$LID lists member-activity $EMAIL
echo_and_run bundle exec bin/mc --list=$LID lists member-info $EMAIL
echo_and_run bundle exec bin/mc --list=$LID lists members
echo_and_run bundle exec bin/mc --list=$LID lists merge-vars
echo_and_run bundle exec bin/mc --list=$LID lists segments
echo_and_run bundle exec bin/mc --list=$LID lists static-segments
echo_and_run bundle exec bin/mc --list=$LID lists subscribe $EMAIL
echo_and_run bundle exec bin/mc --list=$LID lists webhook
echo_and_run bundle exec bin/mc --list=$LID lists group add $RANDOM_NAME
echo_and_run bundle exec bin/mc --list=$LID lists group delete $RANDOM_NAME
echo_and_run bundle exec bin/mc --list=$LID lists group update
echo_and_run bundle exec bin/mc --list=$LID lists grouping add --type radio --groups $RANDOM_NAME
echo_and_run bundle exec bin/mc --list=$LID lists grouping delete
echo_and_run bundle exec bin/mc --list=$LID lists grouping list
echo_and_run bundle exec bin/mc --list=$LID lists grouping update
echo_and_run bundle exec bin/mc --list=$LID lists merge-vars list
echo_and_run bundle exec bin/mc --list=$LID lists webhook add $REQUESTBIN
echo_and_run bundle exec bin/mc --list=$LID lists webhook list
echo_and_run bundle exec bin/mc --list=$LID lists webhook delete $REQUESTBIN

### ------------------------------
### REPORTS (18)
### ------------------------------
echo_and_run bundle exec bin/mc --list=$LID reports abuse --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports advice --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports bounce --cid=$CID $EMAIL
echo_and_run bundle exec bin/mc --list=$LID reports bounces --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports clicked-url --cid=$CID --tid=$TID
echo_and_run bundle exec bin/mc --list=$LID reports clicks --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports domains --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports ecomm --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports eepurl --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports ga --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports geo --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports member-activity --cid=$CID $EMAIL
echo_and_run bundle exec bin/mc --list=$LID reports not-opened --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports opened --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports sent-to --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports share --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports summary --cid=$CID
echo_and_run bundle exec bin/mc --list=$LID reports unsubscribes --cid=$CID

### ------------------------------
### SEARCH (2)
### ------------------------------
echo_and_run bundle exec bin/mc search campaigns santa
echo_and_run bundle exec bin/mc search members kale.davis
echo_and_run bundle exec bin/mc --list=$LID search members kale.davis

### ------------------------------
### USERS (6)
### ------------------------------
echo_and_run bundle exec bin/mc --list=$LID users invite
echo_and_run bundle exec bin/mc --list=$LID users invite-revoke
echo_and_run bundle exec bin/mc --list=$LID users invites
echo_and_run bundle exec bin/mc --list=$LID users login-revoke
echo_and_run bundle exec bin/mc --list=$LID users logins
echo_and_run bundle exec bin/mc --list=$LID users profile

### ------------------------------
### VIP (4)
### ------------------------------
echo_and_run bundle exec bin/mc --list=$LID vip add $EMAIL
echo_and_run bundle exec bin/mc --list=$LID vip activity
echo_and_run bundle exec bin/mc --list=$LID vip members
echo_and_run bundle exec bin/mc --list=$LID vip remove $EMAIL

### ------------------------------
### EXPORT (3)
### ------------------------------
echo_and_run bundle exec bin/mc export activity $CID > export_activity.txt
echo_and_run bundle exec bin/mc export ecommm > export_ecomm.txt
echo_and_run bundle exec bin/mc export list $LID > export_list.txt
