# Copyright 2017-2025 Rolando Munoz Aramburú

if variableExists("plugin_dir$") == 0
    plugin_dir$ = "."
endif

if praatVersion < 6033
  appendInfoLine: "Plug-in name: Annotation Assistant"
  appendInfoLine: "Warning: This plug-in was tested on Praat versions above 6.4.37. Please, get a more recent version of Praat."
  appendInfoLine: "Praat website: http://www.fon.hum.uva.nl/praat/"
endif

# Static menu
Add menu command: "Objects", "Goodies", "TGToolkit", "", 0, ""

## Inspect files 
if praatVersion > 6437
    Add menu command: "Objects", "Goodies", "View TextGrid files...", "TGToolkit", 1, "'plugin_dir$'/scripts/textgrid_ed_view.praat"
    Add menu command: "Objects", "Goodies", "View Sound files...", "TGToolkit", 1, "'plugin_dir$'/scripts/sound_ed_view.praat"
else
    Add menu command: "Objects", "Goodies", "Open files (TextGridEditor)...", "TGToolkit", 1, "'plugin_dir$'/scripts/textgridEditor-open_files.praat"
endif
if praatVersion > 6437
    Add menu command: "Objects", "Goodies", "---", "TGToolkit", 1, ""
    Add menu command: "Objects", "Goodies", "Extract intervals as files...", "TGToolkit", 1, "'plugin_dir$'/scripts/extract_intervals_as_files.praat"
    Add menu command: "Objects", "Goodies", "---", "TGToolkit", 1, ""
endif

## Modify
Add menu command: "Objects", "Goodies", "Create", "TGToolkit", 1, ""
Add menu command: "Objects", "Goodies", "Sound to TextGrid...", "Create", 2, "'plugin_dir$'/scripts/create-textgrid.praat"
Add menu command: "Objects", "Goodies", "Sound to TextGrid (silences)...", "Create", 2, "'plugin_dir$'/scripts/create-textgrid_silences.praat"

Add menu command: "Objects", "Goodies", "Modify", "TGToolkit", 1, ""
Add menu command: "Objects", "Goodies", "Convert...", "Modify", 2, "'plugin_dir$'/scripts/mod-convert.praat"
Add menu command: "Objects", "Goodies", "-", "Modify", 2, ""
Add menu command: "Objects", "Goodies", "Insert tier...", "Modify", 2, "'plugin_dir$'/scripts/mod-insert_tier.praat"
Add menu command: "Objects", "Goodies", "Duplicate tier...", "Modify", 2, "'plugin_dir$'/scripts/mod-duplicate_tier.praat"
Add menu command: "Objects", "Goodies", "Remove tier...", "Modify", 2, "'plugin_dir$'/scripts/mod-remove_tier.praat"
Add menu command: "Objects", "Goodies", "Set tier name...", "Modify", 2, "'plugin_dir$'/scripts/mod-set_tier_name.praat"
Add menu command: "Objects", "Goodies", "-", "Modify", 2, ""
Add menu command: "Objects", "Goodies", "Replace text...", "Modify", 2, "'plugin_dir$'/scripts/mod-replace_text.praat"
Add menu command: "Objects", "Goodies", "Replace text (dictionary)...", "Modify", 2, "'plugin_dir$'/scripts/mod-replace_text_from_csv.praat"

Add menu command: "Objects", "Goodies", "Query", "TGToolkit", 1, ""
Add menu command: "Objects", "Goodies", "Report duration...", "Query", 2, "'plugin_dir$'/scripts/query-get_duration.praat"
Add menu command: "Objects", "Goodies", "-", "Query", 2, ""
Add menu command: "Objects", "Goodies", "Create Table word occurrences...", "Query", 2, "'plugin_dir$'/scripts/corpus-word_occurrences.praat"
Add menu command: "Objects", "Goodies", "Create Table child/parent...", "Query", 2, "'plugin_dir$'/scripts/corpus-child2parent.praat"

Add menu command: "Objects", "Goodies", "Clean", "TGToolkit", 1, ""
Add menu command: "Objects", "Goodies", "Summarize tiers...", "Clean", 2, "'plugin_dir$'/scripts/clean-check_tg_tiers.praat"
Add menu command: "Objects", "Goodies", "Find TextGrid files if tier name...", "Clean", 2, "'plugin_dir$'/scripts/clean-find_tg_if_tier_name.praat"
Add menu command: "Objects", "Goodies", "Check boundary aligments...", "Clean", 2, "'plugin_dir$'/scripts/clean-get_missing_time_boundaries.praat"
Add menu command: "Objects", "Goodies", "Check whitespaces...", "Clean", 2, "'plugin_dir$'/scripts/clean-check_tg_whitespaces.praat"


Add menu command: "Objects", "Goodies", "-", "", 1, ""
Add menu command: "Objects", "Goodies", "About", "TGToolkit", 1, "'plugin_dir$'/scripts/about.praat"

# Dynamic menu
Add action command: "Table", 1, "", 0, "", 0, "TGToolkit", "", 0, ""
Add action command: "Table", 1, "", 0, "", 0, "To TextGridEditor", "TGToolkit", 0, "'plugin_dir$'/scripts/dynamic_menu/open_tg_from_table.praat"
Add action command: "TextGrid", 1, "", 0, "", 0, "-", "Modify interval tier", 2, ""
Add action command: "TextGrid", 1, "", 0, "", 0, "Merge tiers by name", "Modify interval tier", 2, "'plugin_dir$'/scripts/dynamic_menu/tg-join_interval_tiers_by_name.praat"
Add action command: "TextGrid", 1, "", 0, "", 0, "Merge tiers...", "Modify interval tier", 2, "'plugin_dir$'/scripts/dynamic_menu/tg-join_interval_tiers.praat"
Add action command: "TextGrid", 1, "", 0, "", 0, "Tabulate bad aligments...", "Tabulate occurrences...", 3, "'plugin_dir$'/scripts/dynamic_menu/tg-missing_time_boundaries.praat"
