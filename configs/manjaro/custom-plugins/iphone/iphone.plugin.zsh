function mount_iphone() {
  readonly DIRECTORY="$HOME/iphone"

  if [ ! -d "$DIRECTORY" ]; then
    mkdir "$DIRECTORY"
  fi

  if mount | grep -q "$DIRECTORY"; then
    echo "iPhone is already mounted in $DIRECTORY."
  else
    ifuse "$DIRECTORY" && echo "iPhone mounted in $DIRECTORY." || {
      echo "Failed to mount iPhone."
      return 1
    }
  fi
}

function unmount_iphone() {
  readonly DIRECTORY="$HOME/iphone"

  if mount | grep -q "$DIRECTORY"; then
    sudo umount "$DIRECTORY" && echo "iPhone unmounted." || echo "Failed to unmount iPhone."
  else
    echo "iPhone is not currently mounted."
  fi
}
