function setEnv () {
  [[ "$1" ]] && export version=$1 || export version="/c/Users/U482024/.sdkman/candidates/java/17.0.10-tem"
  echo $version
  export oldVersion=${JAVA_HOME}
  export oldPath=$PATH
  export JAVA_HOME=${version}
  export PATH="$PATH:$version/bin"
}

function restoreEnv () {
  export PATH=$oldPath
  export JAVA_HOME=${oldVersion}
}

function mrun () {
  setEnv
  [[ "$1" ]] && local profile=$1 || local profile=local
  [[ "$2" ]] && local version=$2 || local version=RELEASE
  mvn spring-boot:run -s /c/profili/U482024/Downloads/settings.xml -Dversion=${version} -P${profile} -Dspring.profiles.active=${profile}
  restoreEnv
}

function msrc () {
  setEnv
  mvn dependency:sources
  restoreEnv
}

function jrun () {
  setEnv
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -j)
        shift
        local jar=$1
        ;;
      -m)
        shift
        local main=$1
        ;;
      -p)
        shift
        local port=$1
        ;;
      -pr)
        shift
        local profile=$1
        ;;
      -h)
        echo "-j for jar mandatory, -m for main, -p for port, -pr for profile"
        return 1
        ;;
       *)
        echo "no idea"
        shift
    esac
    shift
  done
  [[ "$port" ]] || port=8081
  [[ "$profile" ]] || profile="default"
  [[ "$main" ]] && java -jar $jar $main --server.port=$port -P$profile --spring.profiles.active=$profile || java -jar $jar --server.port=$port -P$profile --spring.profiles.active=$profile
  restoreEnv
}

function mbuild () {
  [[ "$1" ]] && setEnv $1 || setEnv
  mvn clean install package
  restoreEnv
}

function mtest () {
  [[ "$2" ]] && setEnv $version || setEnv
  [[ "$1" ]] && mvn test -Dtest=$1 || mvn clean test
  restoreEnv
}

fopen() {
  [[ "$1" ]] && local path=$1 || local path=~
  find $path -not -path '*.m2*' -not -path '*mysys2*' -not -path '*.git*' -not -path '*JetBrains*' | nvim "$(fzf)"
}

fmd() {
  [[ "$1" ]] && local path=$1 || local path=~
  cd $(find $path -type d -not -path '*.m2*' -not -path '*mysys2*' -not -path '*.git*' -not -path '*JetBrains*' | fzf)
}

alias ll="lsd -al"
alias air='~/go/bin/air.exe'

eval "$(starship init bash)"

export PATH="${PATH}:~/scoop/apps/mongosh/current/bin/mongosh.exe:~/scoop/apps/mongodb/current/bin/mongod.exe"
# export PATH="${PATH}:~/.sdkman/candidates/java/21.0.2-tem/bin"
export PATH="${PATH}:~/.sdkman/candidates/java/current/bin"
PATH=$(echo "$PATH" | sed -e 's/\:\/c\/Program\ Files\/Zulu\/zulu-8-jre\/bin//')

export PATH="${PATH}:/c/Users/U482024/go/pkg/mod/github.com/open-pomodoro/openpomodoro-cli@v0.3.0/"
pmd(){
  openpomodoro-cli "$@"
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
