#!/bin/bash

# OVERWRITE keybindings
cp ./keybindings.json ~/AppData/Roaming/VSCodium/User

target_json=~/AppData/Roaming/VSCodium/User/settings.json
# target_json_=~/AppData/Roaming/VSCodium/User/settings_.json
original_json=~/AppData/Roaming/VSCodium/User/original_settings.json
file_fn() {
    file_fpath="$1"
    if [[ $# -gt 1 ]]; then
        last=1
    else
        last=0
    fi
    echo "file_fn '$file_fpath'"
    last_line=""
    # OLD_IFS="$IFS"
    # IFS=
    while IFS= read -r line; do
        if [[ ! "$line" =~ ^[\{\}] ]]; then
            [[ -n "$last_line" ]] && {
                echo "" >>"$target_json"
                echo -n "$last_line" >>"$target_json"
            }
            last_line="$line"
        elif [[ "$line" =~ ^[\}] ]]; then
            last_line=$(echo -n "$last_line" | tr -d '\r')
            if [[ $last -eq 1 ]]; then
                echo -n "${last_line}" >>"$target_json"
            else
                echo -n "${last_line}," >>"$target_json"
            fi
            return
        fi
    done <"$file_fpath"
    # IFS="$OLD_IFS"
}

if [[ ! -f ~/AppData/Roaming/VSCodium/User/original_settings.json ]]; then
    cp "$target_json" "$original_json"
fi
# overwrites target_json file
echo -n "{" >"$target_json"
file_fn "$original_json"
file_fn ./kit_etc.json
file_fn ./kit_nightrider.json last
echo -e "\n}" >>"$target_json"

# xxd -p "$target_json"
# stat -c '%s' "$target_json"
