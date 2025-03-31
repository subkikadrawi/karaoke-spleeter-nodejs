#!/bin/bash

# Base directory (current directory)
BASE_DIR="./"

# Output file
OUTPUT_FILE="file.json"

# Initialize the JSON structure
echo '{"data": [' > $OUTPUT_FILE

# Get the total number of files with specified extensions
TOTAL_FILES=$(find "$BASE_DIR" -type f \( -name "*.mp4" \) | wc -l)

# Initialize the index
INDEX=0

# Loop through each file with specified extensions
find "$BASE_DIR" -type f \( -name "*.mp4" \) | while read FILE; do
  # Extract file information
  RELATIVE_PATH=$(realpath --relative-to="$BASE_DIR" "$FILE")
  DIRECTORY=$(basename "$(dirname "$FILE")") # Get the directory name of the current file
  FULL_PATH="http://localhost:5500"
  FILENAME=$(basename "$FILE")
  EXTENSION="${FILENAME##*.}"
  FILENAME="${FILENAME%.*}"

  # Append the entry to JSON
  echo "  {" >> $OUTPUT_FILE
  echo "    \"id\": $INDEX," >> $OUTPUT_FILE
  echo "    \"title\": \"$DIRECTORY - $FILENAME\"," >> $OUTPUT_FILE
  echo "    \"pathUrl\": \"${FULL_PATH}/indo/${FILENAME}.${EXTENSION}\"," >> $OUTPUT_FILE
  echo "    \"pathUrlVocal\": \"${FULL_PATH}/indo/separated/${FILENAME}/vocals.mp3\"," >> $OUTPUT_FILE
  echo "    \"pathUrlInstrumental\": \"${FULL_PATH}/indo/separated/${FILENAME}/no_vocals.mp3\"," >> $OUTPUT_FILE
  echo "    \"sourceKaraoke\": \"music\"" >> $OUTPUT_FILE

  # Determine if it's the last item
  if [ "$INDEX" -eq $((TOTAL_FILES - 1)) ]; then
    echo "  }" >> $OUTPUT_FILE
  else
    echo "  }," >> $OUTPUT_FILE
  fi

  # Increment the index
  INDEX=$((INDEX + 1))
done

# Close the JSON array
echo "]}" >> $OUTPUT_FILE

# Notify the user
echo "JSON file has been generated at $OUTPUT_FILE"