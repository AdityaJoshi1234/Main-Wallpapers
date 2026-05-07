#!/bin/bash

# 1. Start the README with a title
echo "# 🖼️ Main Wallpapers Collection" > README.md
echo "Click on an image to see the full resolution." >> README.md
echo "---" >> README.md

# 2. Find all directories that contain images
# We ignore the .git folder
find . -maxdepth 2 -not -path '*/.*' -type d | sort | while read -r dir; do

    # Skip the root directory (.) itself
    if [ "$dir" == "." ]; then continue; fi

    # Get a clean name for the heading (e.g., ./Anime -> Anime)
    folder_name=$(basename "$dir")

    # Check if there are actually images in this folder
    if ls "$dir"/*.{jpg,jpeg,png,webp} &>/dev/null; then
        echo "## $folder_name" >> README.md
        echo "<table>" >> README.md

        # Start a counter for a 3-column grid
        count=0

        for img in "$dir"/*.{jpg,jpeg,png,webp}; do
            # Open a new row every 3 images
            if [ $((count % 3)) -eq 0 ]; then
                echo "  <tr>" >> README.md
            fi

            # Add the image cell (using 250px width for neatness)
            # We use the relative path so GitHub can find it
            echo "    <td align=\"center\"><a href=\"$img\"><img src=\"$img\" width=\"250px\"></a><br>$(basename "$img")</td>" >> README.md

            count=$((count + 1))

            # Close the row if it's the 3rd image
            if [ $((count % 3)) -eq 0 ]; then
                echo "  </tr>" >> README.md
            fi
        done

        # Close the table
        echo "</table>" >> README.md
        echo "" >> README.md
    fi
done

echo "✅ README.md updated with multiple directories!"
