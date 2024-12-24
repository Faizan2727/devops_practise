#!/bin/bash

# Function to display the menu
display_menu() {
    echo "\n=== Docker Container Manager ==="
    echo "1. List all containers"
    echo "2. Start a container"
    echo "3. Stop a container"
    echo "4. Remove a container"
    echo "5. Create a new container"
    echo "6. Exit"
    echo -n "Choose an option: "
}

# Main script logic
while true; do
    display_menu
    read choice

    if [[ $choice -eq 1 ]]; then
        echo "\nListing all containers..."
        docker ps -a

    elif [[ $choice -eq 2 ]]; then
        echo -n "\nEnter the container ID or name to start: "
        read container_id
        docker start "$container_id" && echo "Container $container_id started successfully." || echo "Failed to start container $container_id."

    elif [[ $choice -eq 3 ]]; then
        echo -n "\nEnter the container ID or name to stop: "
        read container_id
        docker stop "$container_id" && echo "Container $container_id stopped successfully." || echo "Failed to stop container $container_id."

    elif [[ $choice -eq 4 ]]; then
        echo -n "\nEnter the container ID or name to remove: "
        read container_id
        docker rm "$container_id" && echo "Container $container_id removed successfully." || echo "Failed to remove container $container_id."

    elif [[ $choice -eq 5 ]]; then
        echo -n "\nEnter the image name to create a container (e.g., nginx): "
        read image_name
        echo -n "Enter a name for the new container (or leave blank for default): "
        read container_name

        if [[ -z $container_name ]]; then
            docker run -d "$image_name" && echo "Container created successfully from image $image_name." || echo "Failed to create container from image $image_name."
        else
            docker run -d --name "$container_name" "$image_name" && echo "Container $container_name created successfully from image $image_name." || echo "Failed to create container $container_name from image $image_name."
        fi

    elif [[ $choice -eq 6 ]]; then
        echo "\nExiting Docker Container Manager. Goodbye!"
        break

    else
        echo "\nInvalid option. Please choose a valid option."
    fi
done
