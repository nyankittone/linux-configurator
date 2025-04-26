if [ -n "$XDG_DATA_HOME" ]; then
	data_home="$XDG_DATA_HOME"
else
	data_home="$HOME/.local/share"
fi

export RUSTUP_HOME="$data_home"/rustup
export CARGO_HOME="$data_home"/cargo
export GOPATH="$data_home"/go
PATH="$PATH":"$RUSTUP_HOME"/bin:"$GOPATH"/bin
export LC_ALL=en_US.UTF-8

unset data_home

### INSERTION POINT - DO NOT CHANGE THIS LINE ###

# if running bash
if [ -n "$BASH" ] && [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi

