# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

# Another one for terminal beeping
setterm -blength 0

# `dircolors` prints out `LS_COLORS='...'; export LS_COLORS`, so eval'ing
# $(dircolors) effectively sets the LS_COLORS environment variable.
# http://unix.stackexchange.com/questions/94299/dircolors-modify-color-settings-globaly
eval "$(dircolors /etc/DIR_COLORS)"
