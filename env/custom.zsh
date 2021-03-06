# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

## General commands
cs() { cd "$@" && ls }

## Git commands
alias gs='git status'
alias gc='git add --all; git commit -m'
alias gp='git push; git push --tags'
alias gpl='git pull'
alias gdc='git diff > diff.diff; code diff.diff'

## SSH Servers
alias lf='ssh lfserver'
alias bk='ssh backups'
alias cpi='ssh cpi'

# HTTPie commands
alias post='http POST'
alias put='http PUT'
alias get='http GET'

# Redis
export PATH="/Applications/Redis.app/Contents/Resources/Vendor/redis/bin:$PATH"

# PlatformIO
export PATH="/Users/kedvall/.platformio/penv/bin:$PATH"

# Function for viewing LHC logs
function lhclog {
    lhc_log_viewer.sh $@
}

function netl {
    if (( $# == 0 ))
    then
        netstat -an | (read a; read a; echo "$a"; grep 127.0.0.1)
    else
        netstat -an | (read a; read a; echo "$a"; grep $1)
    fi
}

# Function for Docker rm then run
function rrun {
    if (( $# == 0 ))
    then
        echo 'Usage: rrun <container_name> [CONTAINER OPTIONS]'
        echo 'Ex: rrun my_container -d -p 80:80 my_container:latest'
        echo ' => docker run --name my_container -d -p 80:80 my_container:latest'
        return 1
    fi

    # Stop and remove current Docker container
    echo "Stopping container '$1'"
    docker stop $1 >/dev/null
    echo "Removing container '$1'"
    docker rm $1 >/dev/null

    # Run new Docker container
    echo "docker run --name $1 ${@:2}"
    docker run --name $1 ${@:2}
}

# Function for Docker rm then run, with DEFAULTS!
function rrund {
    if (( $# == 0 ))
    then
        echo 'Usage: rrund <container_name>:<tag> [CONTAINER OPTIONS]'
        echo 'Ex: rrund my_container:test -p 80:80'
        echo ' => docker run --name my_container -d -p 80:80 my_container:test'
        return 1
    fi

    # Separate image and tag
    IFS=':' read -A IMAGE_ARGS <<< "$1";
    IMAGE="${IMAGE_ARGS[1]}"
    TAG="${IMAGE_ARGS[2]}"

    if [ -z "$TAG" ]; then TAG="latest"; fi

    # Stop and remove current Docker container
    echo "Stopping container '$IMAGE'"
    docker stop $IMAGE >/dev/null
    echo "Removing container '$IMAGE'"
    docker rm $IMAGE >/dev/null

    # Run new Docker container
    echo "docker run --name $IMAGE -d ${@:2} $IMAGE:$TAG"
    docker run --name $IMAGE -d ${@:2} $IMAGE:$TAG
}

# Function for docker-compose up of a single service, then image prune
function dcups {  # dcups: docker-compose up service
    if (( $# == 0 ))
    then
        echo 'Usage: dcups <service_name>'
        return 1
    fi
    
    # Build and bring up service
    echo "docker-compose up --build -d $1"
    docker-compose up --build --detach $1

    # Prune old images
    echo "Pruning old images"
    docker image prune -f >/dev/null
}

# Function for uploading to Platformio boards
function pioup {
    if (( $# == 0 ))
    then
        platformio run --target upload
    elif [ "$1" = "-m" ]
    then
        platformio run --target upload --target monitor
    else
        echo Got: $@
    fi
}

# Make aliases
alias mf='make clean ; make flash'

# Alias for pytest and flake8
alias pytest="python -m pytest"
alias pt=pytest
alias flake="python -m flake8"
