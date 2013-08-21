#!/bin/sh

set -e

# add a symlink to the framework public header folder path in build dir, to help Xcode indexation
if [ ! -e "$TARGET_BUILD_DIR/$PRODUCT_NAME" ]; then
    ln -fs "$PUBLIC_HEADERS_FOLDER_PATH" "$TARGET_BUILD_DIR/$PRODUCT_NAME" || echo "warning: header folder symlink failed"
fi
