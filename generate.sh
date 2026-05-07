#!/bin/bash

# Define the README header
echo "# 🖼️ Wallpaper Collection" > README.md
echo "Auto-generated preview gallery. Click images for full resolution." >> README.md
echo "" >> README.md

# Find all directories that contain images (ignoring the .git folder)
# This looks for folders in the current path
find . -maxdepth 1 -type d -not -path '*/.*' -not -path '.' | sort | while read -r dir; do
    
    # Get the folder name for the heading (e.g., Nature)
    folder_name=$(basename "$dir")
    
    echo "## $folder_name" >> README.md
    echo "<table>" >> README.md
    
    count=0
    # Search for common image formats inside this specific directory
    # We use a subshell to avoid globbing issues if a folder is empty
    images=$(ls "$dir"/*.{jpg,jpeg,png,webp,gif} 2>/dev/null)
    
    if [ -z "$images" ]; then
        echo "  <tr><td>No images found in this folder.</td></tr>" >> README.md
    else
        for img in $images; do
            # Start a new row every 3 images
            if [ $((count % 3)) -eq 0 ]; then
                echo "  <tr>" >> README.md
            fi
            
            # Create the cell with a thumbnail and a link to the full file
            # Width is set to 250px so it fits most screens
            echo "    <td align=\"center\">
      <a href=\"$img\">
        <img src=\"$img\" width=\"250px\" alt=\"$img\"><br>
        <sub>$(basename "$img")</sub>
      </a>
    </td>" >> README.md
            
            count=$((count + 1))
            
            # Close the row after 3 images
            if [ $((count % 3)) -eq 0 ]; then
                echo "  </tr>" >> README.md
            fi
        done
        
        # If the last row isn't full, close it anyway
        if [ $((count % 3)) -ne 0 ]; then
            echo "  </tr>" >> README.md
        fi
    fi
    
    echo "</table>" >> README.md
    echo "" >> README.md
done

echo "✅ Gallery generated with separate grids for every directory."
