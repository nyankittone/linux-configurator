#!/usr/bin/env bash

set -eu

# $1 is the exit code to use
# $2 and onward is the message to print
die() {
    local exit_code
    exit_code=$1

    shift
    printf '\33[1;91mfatal:\33[m %s\n' "$(tr '\n' ' ' <<< "$@")" >&2

    exit "$exit_code"
}

shout() {
    printf '\33[1;92m%s\33[m\n' "$(tr '\n' ' ' <<< "$@")"
}

# $1 is the message to show
# Remaining args are for the individual options
choose() {
    list_options() {
        awk 'BEGIN{i=1} {print i++")\t"$0}' <<< "$options" >&2
    }

    print_error() {
        printf '\33[1;91mBad option provided. (type "help" to re-list options)\33[m\n' >&2
    }

    local question
    question=$1
    shift

    printf '\33[1m%s\33[m\n' "$question" >&2

    local options
    options=$(printf '%s\n' "$@") # There has got to be a cleaner way to do this...
    list_options

    local line
    while true; do
        read -rp '> ' line
        line=$(awk '{print tolower($0)}' <<< "$line")

        # WARNING: Evil regex alert
        local matches
        if ! matches=$(grep -E "^$(sed 's/[^a-z0-9]/\\\0/g' <<< "$line")" <<< "$options"); then
            print_error
        elif [ "$(wc -l <<< "$matches")" != 1 ]; then
            print_error
        else
            echo "$matches"
            break
        fi
    done

    unset -f list_options
    unset -f print_error
}

select_user() {
    # A valid user for this script must have a UID of 100 or larger (maening it's a non-system
    # user), and should have it's home directory going to somewhere in /home.
    local users
    local user
    users=$(awk -F : '{if($3 >= 1000 && match($6, /^\/home\/.*$/)) print $1}' /etc/passwd)
    if [ -n "$users" ]; then
        user=$(choose 'What user will be targetted?' $users 'new user')
        if [ "$user" != 'new user' ]; then
            printf 'target_user=%s\n' "$user"
            return
        fi
    fi

    # TODO: Add checking functionality to this for both the username and password!
    local password
    printf '\33[1mWhat is the new username?\33[m\n' >&2
    read -rp '> ' user
    printf '\33[1mWhat should be their password?\33[m\n' >&2
    read -rp '> ' password

    printf 'target_user=%s\ntarget_password='"'"'%s'"'"'\n' "$user" "$(sed "s/'/'\"'\"'/g" <<< "$password")"
}

configure_system() {
    # Parse args passed over
    local system_type
    local window_system
    local target_user
    local target_password

    # Fuck your stinky-ass DRY. I'm a free woman!
    while [ -n "${1+deez}" ]; do
        case "$(cut -d '=' -f 1 <<< "$1")" in
            system_type)
                system_type=$(cut -d '=' -f 2- <<< "$1")
            ;;
            window_system)
                window_system=$(cut -d '=' -f 2- <<< "$1")
            ;;
            target_user)
                target_user=$(cut -d '=' -f 2- <<< "$1")
            ;;
            target_password)
                target_password=$(cut -d '=' -f 2- <<< "$1")
            ;;
        esac
        shift
    done

    # Start by updating the system
    apt update
    apt upgrade
}

main() {
    # If we're not running as root, get the fuck outta here.
    # 

    # Start by polling the user for important info, like:
    # who is the user?
    # is this a desktop or laptop system?
    # is this going to run X11, Wayland, or none?
    shout Welcome to my funny Debian configuration script! :3

    local system_type
    local window_system
    local target_user
    local target_password

    system_type=$(choose 'What kind of computer is this?' desktop laptop)
    window_system=$(choose 'What windowing system will you use?' x11 wayland none)
    eval "$(select_user)"

    if [ -n "${target_password+deez}" ]; then
        configure_system system_type="$system_type" window_system="$window_system" \
            target_user="$target_user" target_password="$target_password"
    else
        configure_system system_type="$system_type" window_system="$window_system" \
            target_user="$target_user"
    fi
}

main "$@"

