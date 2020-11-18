
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH=$HOME/.local/bin:$HOME/go/bin:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=$PATH:/snap/bin
#export PATH=$PATH:`gem environment gempath`
export PATH=$PATH:$HOME/.node_modules/bin
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
#export PATH=$PATH:`stack path`
export HOMESHICK_DIR=/usr/local/opt/homeshick
#export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
#export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#eval `ssh-agent`


export EDITOR=nvim
alias takeover="tmux detach -a"

export GOPATH=$HOME/go
export GO111MODULE=on
export npm_config_prefix=$HOME/.node_modules
alias "sudo"="sudo "
#alias "docker"="sudo docker"
#alias "docker-compose"="sudo docker-compose"
alias "sail"="sudo systemctl start docker"

alias "kl"="kubectl"
alias "chmod-file"="find . -type d -exec chmod 775 {} \;"
alias "chmod-dir"="find . -type f -exec chmod 644 {} \;  "
alias "wa"="watch -n 1 "
alias "v"="nvim"
alias "vim"="nvim"


git config --global alias.logtree 'log --graph --all --oneline'


source "/usr/local/opt/homeshick/homeshick.sh"

mrAll(){
  find . -type d -name .git | xargs -n 1 dirname | xargs -n1 mr register
}

restic-backup (){
  echo "Continue (y/n)?"
  read choice
  case "$choice" in 
    y|Y ) restic -r /run/media/phisco/BACKUP backup --verbose --exclude "*cache*" --exclude .trash --exclude "*tmp" --exclude cache --exclude "*Cache*"  --password-command "lpass show Backup --password" ~;;
    n|N ) echo "ok, see you";;
    * ) echo "invalid";;
  esac
}
function restic-mount (){
  restic -r /run/media/phisco/BACKUP mount /mnt/restic --password-command "lpass show Backup --password" &
}

function create_config (){
  name=$1
  namespace=$2
  server=$3

  secret=$(kubectl get sa $name -n $namespace -o jsonpath='{.secrets[0].name}')
  ca=$(kubectl get secret/$secret -n $namespace -o jsonpath='{.data.ca\.crt}')
  token=$(kubectl get secret/$secret -n $namespace -o jsonpath='{.data.token}' | base64 --decode)

  echo "
apiVersion: v1
kind: Config
clusters:
- name: default-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: default-cluster
    namespace: ${namespace}
    user: ${name}
current-context: default-context
users:
- name: ${name}
  user:
    token: ${token}
"
}

export PATH="$HOME/.cargo/bin:$PATH"

source $HOME/.cargo/env

export FLUX_FORWARD_NAMESPACE=flux
