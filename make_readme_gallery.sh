#!/usr/bin/env bash
# set -e

# Usage: ./make_gallery.sh
#
# Run in a directory with a "walls/" subdirectory, and it will create a
# "thumbnails/" subdirectory.
#
# Uses imagemagick's `convert`, so make sure that's installed.
# On Ubuntu install `imagemagick` package via:
# sudo apt install imagemagick

# rm -rf thumbnails
mkdir -p thumbnails walls

raw_url="https://raw.githubusercontent.com/DropB1t/wallbits/main"
wall_url="https://github.com/DropB1t/wallbits/blob/main"

echo "## My Wallpaper Collection" >README.md
echo "This repository contains a curated collection of wallpapers that I've gathered from various sources across the internet. All wallpapers in this collection are **not owned by me** and are the property of their respective creators. All credits and copyrights belong to the original artists who created these wonderful images." >>README.md
echo "### Desktop Wallpapers" >>README.md
echo "" >>README.md

total=$(ls walls/ | wc -l)
i=0

for src in $(ls walls/* | sort -V); do
  ((i++))
  filename="$(basename "$src")"
  # Skip if the file is not a JPG
  if [[ ! "$filename" =~ \.jpg$ ]]; then
    echo "Skipping non-JPG file: $filename"
    continue
  fi
  printf '%4d/%d: %s\n' "$i" "$total" "$filename"

  test -e "${src/walls/thumbnails}" || convert "$src" -resize 200x100^ -gravity center -extent 200x100 "${src/walls/thumbnails}"

  filename_escaped="${filename// /%20}"
  thumb_url="$url_root/thumbnails/$filename_escaped"
  pape_url="$wall_url/walls/$filename_escaped"

  echo "[![$filename]($thumb_url)]($pape_url)" >>README.md
done
echo "" >>README.md