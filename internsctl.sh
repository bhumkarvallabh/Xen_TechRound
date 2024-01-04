#!/bin/bash

# Set variables
COMMAND_NAME="internsctl"
COMMAND_VERSION="v0.1.0"

# Define functions

# Function to display the manual page
# display_manual() {
#     echo "internsctl - Custom Linux Command"
#     echo
#     echo "DESCRIPTION:"
#     echo "  This command performs various operations like get CPU, Memoery info, Can be used to create new user, fetch user list, and can fetch specific file info."
#     echo
#     echo "COMMANDS:"
#     echo "  user create <username>    Create a new user"
#     echo "  user list                 List all regular users"
#     echo "  user list --sudo-only     List users with sudo permissions"
#     echo "  cpu getinfo               Display CPU information"
#     echo "  memory getinfo            Display memory information"
#     echo "  file getinfo <file-name>  Get information about a file"
#     echo
#     echo "OPTIONS:"
#     echo "  --help        Display this help message"
#     echo "  --version     Display the version of the command"
#     echo
#     echo "EXAMPLES:"
#     echo "  $ internsctl user create john_doe"
#     echo "  $ internsctl user list"
#     echo "  $ internsctl user list --sudo-only"
#     echo "  $ internsctl cpu getinfo"
#     echo "  $ internsctl memory getinfo"
#     echo "  $ internsctl file getinfo hello.txt"
#     echo "  $ internsctl file getinfo --size hello.txt"
#     echo "  $ internsctl file getinfo --permissions hello.txt"
#     echo "  $ internsctl file getinfo --owner hello.txt"
#     echo "  $ internsctl file getinfo --last-modified hello.txt"
#     echo
# }

# Function to display the manual page
display_manual() {
    cat <<EOF
INTRODUCTION
    $COMMAND_NAME - Custom Linux Command

DESCRIPTION
    This command performs various operations for interns.

COMMANDS
    user create <username>    Create a new user
    user list                 List all regular users
    user list --sudo-only     List users with sudo permissions
    cpu getinfo               Display CPU information
    memory getinfo            Display memory information
    file getinfo <file-name>  Get information about a file

OPTIONS
    --help        Display this help message
    --version     Display the version of the command

EXAMPLES
    $COMMAND_NAME user create john_doe
    $COMMAND_NAME user list
    $COMMAND_NAME user list --sudo-only
    $COMMAND_NAME cpu getinfo
    $COMMAND_NAME memory getinfo
    $COMMAND_NAME file getinfo hello.txt
    $COMMAND_NAME file getinfo --size hello.txt
    $COMMAND_NAME file getinfo --permissions hello.txt
    $COMMAND_NAME file getinfo --owner hello.txt
    $COMMAND_NAME file getinfo --last-modified hello.txt
EOF
}

# Function to display help
display_help() {
    echo "Usage: $COMMAND_NAME [command] [options] [arguments]"
    echo
    echo "Commands:"
    echo "  user create <username>    Create a new user"
    echo "  user list                 List all regular users"
    echo "  user list --sudo-only     List users with sudo permissions"
    echo "  cpu getinfo               Display CPU information"
    echo "  memory getinfo            Display memory information"
    echo "  file getinfo <file-name>  Get information about a file"
    echo
    echo "Options:"
    echo "  --help        Display this help message"
    echo "  --version     Display the version of the command"
    echo
    echo "Examples:"
    echo "  $COMMAND_NAME user create john_doe"
    echo "  $COMMAND_NAME user list"
    echo "  $COMMAND_NAME user list --sudo-only"
    echo "  $COMMAND_NAME cpu getinfo"
    echo "  $COMMAND_NAME memory getinfo"
    echo "  $COMMAND_NAME file getinfo hello.txt"
    echo "  $COMMAND_NAME file getinfo --size hello.txt"
    echo "  $COMMAND_NAME file getinfo --permissions hello.txt"
    echo "  $COMMAND_NAME file getinfo --owner hello.txt"
    echo "  $COMMAND_NAME file getinfo --last-modified hello.txt"
    echo
}

# Function to display version
display_version() {
    echo "$COMMAND_NAME $COMMAND_VERSION"
}

# Function to create a new user
create_user() {
    if [ $# -eq 0 ]; then
        echo "Error: Username not provided. Use '$COMMAND_NAME user create <username>' for usage."
        exit 1
    fi

    username=$1
    useradd $username
    passwd $username
    echo "User '$username' created successfully."
}

# Function to list all regular users
list_users() {
    cut -d: -f1 /etc/passwd
}

# Function to list users with sudo permissions
list_sudo_users() {
    getent group sudo | cut -d: -f4 | tr ',' '\n'
}

# Function to get CPU information
get_cpu_info() {
    lscpu
}

# Function to get memory information
get_memory_info() {
    free
}

# Function to get file information
get_file_info() {
    if [ $# -eq 0 ]; then
        echo "Error: File name not provided. Use '$COMMAND_NAME file getinfo <file-name>' for usage."
        exit 1
    fi

    filename=$1

    if [ ! -e "$filename" ]; then
        echo "Error: File '$filename' not found."
        exit 1
    fi

    echo $1
    echo $2

    if [ "$2" == "--size" ] || [ "$2" == "-s" ]; then
        stat -c %s "$filename"
    elif [ "$2" == "--permissions" ] || [ "$2" == "-p" ]; then
        stat -c %A "$filename"
    elif [ "$2" == "--owner" ] || [ "$2" == "-o" ]; then
        stat -c %U "$filename"
    elif [ "$2" == "--last-modified" ] || [ "$2" == "-m" ]; then
        stat -c %y "$filename"
    else
        # Default output
        echo "File: $filename"
        echo "Access: $(stat -c %A "$filename")"
        echo "Size(B): $(stat -c %s "$filename")"
        echo "Owner: $(stat -c %U "$filename")"
        echo "Modify: $(stat -c %y "$filename")"
    fi
}

# Main script

# Check for arguments
if [ $# -eq 0 ]; then
    echo "Error: No arguments provided. Use '$COMMAND_NAME --help' for usage."
    exit 1
fi

# Parse arguments
case $1 in
    --help)
        display_help
        ;;
    --version)
        display_version
        ;;
    user)
        case $2 in
            create)
                create_user $3
                ;;
            list)
                list_users
                ;;
            list|--sudo-only)
                list_sudo_users
                ;;
            *)
                echo "Error: Unknown sub-command '$2' for 'user'. Use '$COMMAND_NAME --help' for usage."
                exit 1
                ;;
        esac
        ;;
    cpu)
        case $2 in
            getinfo)
                get_cpu_info
                ;;
            *)
                echo "Error: Unknown sub-command '$2' for 'cpu'. Use '$COMMAND_NAME --help' for usage."
                exit 1
                ;;
        esac
        ;;
    memory)
        case $2 in
            getinfo)
                get_memory_info
                ;;
            *)
                echo "Error: Unknown sub-command '$2' for 'memory'. Use '$COMMAND_NAME --help' for usage."
                exit 1
                ;;
        esac
        ;;
    file)
        case $2 in
            getinfo)
                get_file_info $3 $4
                ;;
            *)
                echo "Error: Unknown sub-command '$2' for 'file'. Use '$COMMAND_NAME --help' for usage."
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Error: Unknown command '$1'. Use '$COMMAND_NAME --help' for usage."
        exit 1
        ;;
esac
