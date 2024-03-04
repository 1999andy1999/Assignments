#!/bin/bash
# systeminfo.sh - Generates a system report of the computer.
# this script sources the function library (reportfunctions.sh) to generate reports on various
# system components including CPU, RAM, Disk, Network. errors are shown
# directly to the user or logged, based on the verbose setting

# sources the function library
SCRIPT_DIR="$(dirname "$0")"
source "${SCRIPT_DIR}/reportfunctions.sh" || {
    echo "Error sourcing reportfunctions.sh" >&2 
    exit 1 
}

# initializes the variable for verbose mode
VERBOSE=0

# defines the error handling function
errormessage() {
    local msg="$1"
    if [ "$VERBOSE" -eq 1 ]; then
        echo "$msg" >&2  # Print to stderr
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $msg" >> /var/log/systeminfo.log
    fi
}

# checks for the root permissions
if [[ $EUID -ne 0 ]]; then
    errormessage "This script must be run as root."
    exit 1
fi

# displays the usage information
usage() {
    echo "Usage: $0 [options]"
    echo "-h        Display help message and exit."
    echo "-v        Run verbosely, showing any errors directly."
    echo "-s        Run system reports (computer, OS, CPU, RAM, and video)."
    echo "-d        Run disk report."
    echo "-n        Run network report."
}

# Process command-line options
while getopts ":hvsdn" opt; do
    case ${opt} in
        h )
            usage
            exit 0
            ;;
        v )
            VERBOSE=1
            ;;
        s )
            computerreport
            osreport
            cpureport
            ramreport
            videoreport
            exit 0
            ;;
        d )
            diskreport
            exit 0
            ;;
        n )
            networkreport
            exit 0
            ;;
        \? )
            errormessage "Invalid option: -$OPTARG"
            usage
            exit 1
            ;;
    esac
done

# Default behavior - this will run all reports if no options are provided
if [ $OPTIND -eq 1 ]; then
    computerreport
    osreport
    cpureport
    ramreport
    diskreport
    networkreport
fi

exit 0

