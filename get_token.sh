ADMIN_SECRET="$(kubectl -n kube-system get secret -o=name | grep 'admin-user')"
TOKEN="$(kubectl -n kube-system get secret $ADMIN_SECRET -o=jsonpath='{..token}')"
TOKEN="$(echo $TOKEN | base64 --decode)"

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# Copy token to the administrator's operating system clipboard
if [ $machine == "Mac" ]; then
  echo $TOKEN | pbcopy
elif [ $machine == "Linux" ]; then
  echo $TOKEN | xclip -selection clipboard -i
elif [ $machine == "Cygwin" ]; then
  echo $TOKEN > /dev/clipboard
fi

echo "Dashboard token is now in your $machine clipboard."