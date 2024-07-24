#!/bin/sh

# Check if zimfw is installed and perform tasks
if hash zimfw 2>/dev/null; then

    echo "Updating zimfw"
    echo "================================"
    echo ""

    echo "Updating plugins..."
    zimfw update
    echo ""
fi
