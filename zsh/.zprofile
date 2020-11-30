# Add directories to the path if available.
# Directories listed later appear earler in the path.
typeset -a directories=(
  "/opt/brew/bin"
  "${HOME}/bin"
)

for directory in "${directories[@]}"; do
  export PATH="${directory}:${PATH}"
done
