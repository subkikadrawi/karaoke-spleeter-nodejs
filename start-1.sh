#!/bin/bash

# Set the parent directory containing subdirectories
parent_dir="$(pwd)"
echo "Parent directory: $parent_dir"

# Check if the parent directory exists
if [ ! -d "$parent_dir" ]; then
    echo "Error: Parent directory does not exist."
    read -p "Press any key to continue..."
    exit 1
fi

# Loop through all subdirectories in the parent directory
for d in "$parent_dir"/*/ ; do
    echo "Processing subdirectory: $d"

    # Loop through all MP4, AVI, MPG, and DAT files in the current subdirectory
    for f in "$d"*.{mp4,avi,mpg,DAT}; do
        [ -e "$f" ] || continue
        echo "Found file: $f"
        echo "Processing $f..."

        # Convert non-MP4 files to MP4
        ext="${f##*.}"
        if [ "$ext" != "mp4" ]; then
            mp4_file="${f%.*}.mp4"
            if [ ! -f "$mp4_file" ]; then
                echo "Converting $f to MP4..."
                ffmpeg -i "$f" -c:v libx264 -c:a aac "$mp4_file"
                if [ $? -ne 0 ]; then
                    echo "Error: FFmpeg failed to convert $f to MP4."
                    continue
                else
                    echo "Successfully converted $f to MP4."
                    file_to_process="$mp4_file"
                fi
            else
                file_to_process="$mp4_file"
            fi
        else
            file_to_process="$f"
        fi

        # Check if the WAV file already exists
        wav_file="${file_to_process%.*}.wav"
        if [ -f "$wav_file" ]; then
            echo "Skipping conversion: $wav_file already exists."
        else
            # Extract audio from MP4 to WAV using FFmpeg
            echo "Converting $file_to_process to WAV..."
            ffmpeg -i "$file_to_process" -q:a 0 -map a "$wav_file"
            if [ $? -ne 0 ]; then
                echo "Error: FFmpeg failed to convert $file_to_process."
            else
                echo "Successfully converted $file_to_process to WAV."
            fi
        fi

        # # Check if the MP3 file already exists
        # mp3_file="${file_to_process%.*}.mp3"
        # if [ -f "$mp3_file" ]; then
        #     echo "Skipping conversion: $mp3_file already exists."
        # else
        #     # Extract audio from MP4 to MP3 using FFmpeg
        #     echo "Converting $file_to_process to MP3..."
        #     ffmpeg -i "$file_to_process" -q:a 0 -map a "$mp3_file"
        #     if [ $? -ne 0 ]; then
        #         echo "Error: FFmpeg failed to convert $file_to_process."
        #     else
        #         echo "Successfully converted $file_to_process to MP3."
        #     fi
        # fi

        # # Run Spleeter on the MP3 file
        # echo "Splitting $mp3_file into vocals and instruments..."
        # python -m spleeter separate -i "$mp3_file" -p spleeter:2stems -b 320k -o "$d"
        # if [ $? -ne 0 ]; then
        #     echo "Error: Spleeter failed to process $mp3_file."
        # else
        #     echo "Successfully processed $mp3_file."
        # fi

        echo "Finished processing $f."
    done
done

echo "All files processed."
read -p "Press any key to continue..."