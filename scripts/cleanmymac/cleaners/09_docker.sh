#!/bin/sh

# Check if docker is installed and perform tasks
if hash docker 2>/dev/null; then

    echo "Performing docker maintainance"
    echo "================================"
    echo ""

    echo "Pruning docker..."
    docker system prune -f
    echo ""
fi
