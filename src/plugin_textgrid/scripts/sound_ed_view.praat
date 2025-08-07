# Open one by one, all the audio files and their TextGrids in the specified directory
#
# Created by Rolando Munoz A. on 2025-07-13
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
form: "View sound files (TextGridEditor)"
    folder: "Input folder", "/home/rolando/corpus"
    word: "Annotation file extension", ".TextGrid"
    word: "Sound file extension", ".wav"
    sentence: "Filter TextGrid files by (regex)", ""
    boolean: "Adjust_volume", 1
endform

input_folder$ = replace$(input_folder$, "\", "/", 0)
pattern$ = input_folder$ + "/*" + sound_file_extension$
files$# = fileNames_caseInsensitive$#(pattern$)

# Filter files
match# = zero#(size(files$#))
for i to size(files$#)
    match = index_regex(files$#[i], filter_TextGrid_files_by$)
    match#[i] = if match then 1 else 0 fi
endfor

new_index = 0
new_files$# = empty$#(sum(match#))
for i to size(files$#)
    if match#[i] == 1
        new_index +=1
        new_files$#[new_index] = files$#[i]
    endif
endfor

files$# = new_files$#

index = 1
volume = 0.99
selected_btn = 1
pause = 1
freq_cursor = 0.0
n_files = size(files$#)

if n_files == 0
    writeInfoLine: "Open TextGrid & Sound"
    appendInfoLine: "No files in the specified directory"
    exitScript()
endif

## Main
while pause
    index = if index > n_files then 1 else index fi

    sound_path$ = input_folder$ + "/" + files$#[index]
    textgrid_path$ = replace_regex$(sound_path$, "(.+)\..+", "\1", 0) + annotation_file_extension$

    # Open a Sound file from the list
    if adjust_volume
        sound_id = Read from file: sound_path$
        Scale peak: volume
    else
        sound_id = Open long sound file: sound_path$
    endif
    editor_id = sound_id

    object_list# = {sound_id}
    if fileReadable(textgrid_path$)
        textgrid_id = Read from file: textgrid_path$
        object_list# = {textgrid_id, sound_id}
        editor_id = textgrid_id
    endif

    selectObject: object_list#

    View & Edit
    editor: editor_id
    Move frequency cursor to: freq_cursor

    beginPause: "File browser"
        comment: "Case: 'index'/'n_files'"
        natural: "Next file",  if (index + 1) > n_files then 1 else index + 1 fi
        if adjust_volume
            real: "Volume", volume
        endif
    clicked_pause = endPause: "Save", "Jump", "Quit", selected_btn

    freq_cursor = Get frequency at frequency cursor
    endeditor

    selected_btn = clicked_pause

    if clicked_pause = 1
        selectObject: textgrid_id
        Save as text file: textgrid_path$
    endif

    removeObject: object_list#
    index = next_file

    if clicked_pause = 3
        pause = 0
    endif
endwhile
