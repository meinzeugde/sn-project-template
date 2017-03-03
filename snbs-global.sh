#!/bin/sh

### CONFIGURE SCRIPT
INPUT_SCRIPT=background_scripts/global.js 
OUTPUT_LOG=snbs-global.log  
COLORCODE=33                # color of script result
INSTANCE_AUTH=authkey
INSTANCE_NAME=instance_prefix
INSTANCE_SCOPE=global

### OUTPUT AND LOG RESULTS
echo "
=======TIME OF START========" | tee -a $OUTPUT_LOG
echo "`date -u` `./script.sh`" | tee -a $OUTPUT_LOG
echo "=======ORIGINAL SCRIPT======" | tee -a $OUTPUT_LOG
cat $INPUT_SCRIPT | tee -a $OUTPUT_LOG
echo "
=======OUTPUT===============" | tee -a $OUTPUT_LOG
echo -e "\033[${COLORCODE}m"
/c/nodejs/node /c/snow-runner/run.js $INSTANCE_AUTH@$INSTANCE_NAME --scope "$INSTANCE_SCOPE" $INPUT_SCRIPT | tee -a $OUTPUT_LOG

# Color	    Foreground
# Black	    30
# Red	    31
# Green	    32
# Yellow	33
# Blue	    34
# Magenta	35
# Cyan	    36
# White	    37