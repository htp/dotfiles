# Add Homebrew to the path if available.
if [ -d "/opt/brew" ]; then
  export PATH="/opt/brew/bin:${PATH}"
fi
