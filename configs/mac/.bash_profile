export PATH="/Applications/CMake.app/Contents/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/3pwd/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/3pwd/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/3pwd/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/3pwd/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

source ~/.bash_scripts

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8