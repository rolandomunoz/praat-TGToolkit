# Extract TextGrid as intervals as files
#
# Written by Rolando Muñoz A. (20 July 2025)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
form: "Extract intervals as files"
    folder: "Input folder", "/home/rolando/corpus"
    word: "Annotation file extension", ".TextGrid"
    word: "Sound file extension", ".wav"
    sentence: "Filter TextGrid files by (regex)", ""
    comment: "Search:"
    sentence: "Tier name", "phrase"
    sentence: "Match content (regex)", ""
    folder: "Output folder", "<input_folder>"
    comment: "Output file:"
    real: "Margin (sec)", "0.2"
    sentence: "Filename", "<filename>_<label>_R<id:00>"
endform

src_dir$ = replace$(input_folder$, "\", "/", 0)
pattern$ = src_dir$ + "/*" + annotation_file_extension$
files$# = fileNames_caseInsensitive$#(pattern$)

dst_dir$ = replace$(output_folder$, "\", "/", 0)
if index(dst_dir$, "<input_folder>")
   dst_dir$ = src_dir$ + "/tmp" + replace$(mid$(date_iso$(), 1, 19), ":", "_", 0)
   createFolder(dst_dir$)
endif

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
n_files = size(files$#)

if n_files == 0
    writeInfoLine: "Open TextGrid & Sound"
    appendInfoLine: "No files in the specified directory"
    exitScript()
endif

for i to size(files$#)
    textgrid_path$ = src_dir$ + "/" + files$#[i]
    sound_path$ = textgrid_path$ - annotation_file_extension$ + sound_file_extension$

    if fileReadable(sound_path$)
        tg = Read from file: textgrid_path$
        sd = Open long sound file: sound_path$

        selectObject: tg
        total_dur = Get total duration

        @get_tier_by_name: tier_name$
        selected_tier = get_tier_by_name.return

        is_interval_tier = Is interval tier: selected_tier

        if selected_tier > 0 and is_interval_tier == 1
            count = Count intervals where: selected_tier, "matches (regex)", match_content$
            if count > 0
                n_intervals = Get number of intervals: selected_tier
                for j to n_intervals
                    selectObject: tg
                    label$ = Get label of interval: selected_tier, j
                    if index_regex(label$, match_content$) and label$ != ""
                        #Filename
                        stem$ = files$#[i] - annotation_file_extension$
                        fname$ = replace$(filename$, "<filename>", stem$, 0)
                        fname$ = replace$(fname$, "<label>", label$, 0)
                        if index_regex(fname$, "\<id:?(.*)\>")
                            zeroes$ = replace_regex$(fname$, ".*\<id:?(.*)\>.*", "\1", 0)
                            if zeroes$ == ""
                                zeroes$ = "0"
                            endif
                            @unique_fname: fname$, dst_dir$, zeroes$
                            id$ = unique_fname.return$
                            fname$ = replace_regex$(fname$, "\<id:?.*\>", id$, 0)
                        endif
                        @safe_filename: fname$
                        fname$ = safe_filename.return$

                        textgrid_path_out$ = dst_dir$ + "/" + fname$ + ".TextGrid"
                        sound_path_out$ = dst_dir$ + "/" + fname$ + ".wav"

                        tmin = Get start time of interval: selected_tier, j
                        tmax = Get end time of interval: selected_tier, j

                        tmin = if (tmin - margin) > 0 then (tmin - margin) else 0 fi 
                        tmax = if (tmax + margin) > total_dur then total_dur else (tmax + margin) fi
                        tmp_tg = Extract part: tmin, tmax, "no"
                        Save as text file: textgrid_path_out$

                        # Long sound
                        selectObject: sd
                        tmp_sound = Extract part: tmin, tmax, "no"
                        Save as WAV file: sound_path_out$
                        
                        removeObject: tmp_tg, tmp_sound
                    endif
                endfor
            endif
        endif
        removeObject: tg, sd
    endif
endfor

procedure get_tier_by_name: .pattern$
    .n_tiers = Get number of tiers
    .selected_tier = 0
    .tier = 1
    while .tier <= .n_tiers
        .tier_name$ = Get tier name: .tier
        if .tier_name$ == .pattern$
            .selected_tier = .tier
            .tier = .n_tiers
        endif
        .tier +=1
    endwhile
    .return = .selected_tier
endproc

procedure unique_fname: .fname$, .dst_dir$, .zeroes$
    .index = 0
    repeat
        .index+=1
        .index$ = string$(.index)
        .preffix$ = left$(.zeroes$, length(.zeroes$)-length(.index$))
        .id$ = .preffix$ + .index$
        .name$ = replace_regex$(.fname$, "\<id:?.*\>", .id$, 0)
    until !fileReadable(.dst_dir$ + "/" + .name$ + ".TextGrid")
    .return$ =.id$
endproc

procedure safe_filename: .fname$
    # Replaces characters that are forbidden in Windows, macOS, and Linux filenames
    # with underscores (_), ensuring cross-platform compatibility.
    .fname$ = backslashTrigraphsToUnicode$(.fname$)
    .fname$ = replace$(.fname$, "<", "_", 0)
    .fname$ = replace$(.fname$, ">", "_", 0)
    .fname$ = replace$(.fname$, """", "_", 0)
    .fname$ = replace$(.fname$, "/", "_", 0)
    .fname$ = replace$(.fname$, "\", "_", 0)
    .fname$ = replace$(.fname$, "|", "_", 0)
    .fname$ = replace$(.fname$, "?", "_", 0)
    .fname$ = replace$(.fname$, "*", "_", 0)
    .fname$ = replace$(.fname$, ":", "_", 0)
    .return$ = .fname$
endproc