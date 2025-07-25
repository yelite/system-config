#!/usr/bin/env bash
set -euo pipefail

# Check for required dependencies
command -v ddcutil >/dev/null 2>&1 || { echo "ERROR: ddcutil not found" >&2; exit 1; }
command -v awk >/dev/null 2>&1 || { echo "ERROR: awk not found" >&2; exit 1; }

# Check for required environment variables
if [[ -z "${PRIMARY_MONITOR_DISPLAY_NUM:-}" ]]; then
    echo "ERROR: PRIMARY_MONITOR_DISPLAY_NUM environment variable not set" >&2
    exit 1
fi
if [[ -z "${SECONDARY_MONITOR_DISPLAY_NUM:-}" ]]; then
    echo "ERROR: SECONDARY_MONITOR_DISPLAY_NUM environment variable not set" >&2
    exit 1
fi
if [[ -z "${PRIMARY_MONITOR_LOCAL_INPUT_SOURCE:-}" ]]; then
    echo "ERROR: PRIMARY_MONITOR_LOCAL_INPUT_SOURCE environment variable not set" >&2
    exit 1
fi
if [[ -z "${SECONDARY_MONITOR_LOCAL_INPUT_SOURCE:-}" ]]; then
    echo "ERROR: SECONDARY_MONITOR_LOCAL_INPUT_SOURCE environment variable not set" >&2
    exit 1
fi
if [[ -z "${PRIMARY_MONITOR_REMOTE_INPUT_SOURCE:-}" ]]; then
    echo "ERROR: PRIMARY_MONITOR_REMOTE_INPUT_SOURCE environment variable not set" >&2
    exit 1
fi
if [[ -z "${SECONDARY_MONITOR_REMOTE_INPUT_SOURCE:-}" ]]; then
    echo "ERROR: SECONDARY_MONITOR_REMOTE_INPUT_SOURCE environment variable not set" >&2
    exit 1
fi

declare -A local_input_sources
local_input_sources["$PRIMARY_MONITOR_DISPLAY_NUM"]=$PRIMARY_MONITOR_LOCAL_INPUT_SOURCE
local_input_sources["$SECONDARY_MONITOR_DISPLAY_NUM"]=$SECONDARY_MONITOR_LOCAL_INPUT_SOURCE

declare -A remote_input_sources
remote_input_sources["$PRIMARY_MONITOR_DISPLAY_NUM"]=$PRIMARY_MONITOR_REMOTE_INPUT_SOURCE 
remote_input_sources["$SECONDARY_MONITOR_DISPLAY_NUM"]=$SECONDARY_MONITOR_REMOTE_INPUT_SOURCE

# Initialize arrays to store the new inputs and corresponding I2C bus numbers
declare -a new_inputs
declare -a i2c_buses

collect_new_input_source() {
    local i2c_bus_number=$1
    local local_input_source=$2
    local remote_input_source=$3

    # Get the current input source
    if ! current_input=$(ddcutil getvcp 60 -b "$i2c_bus_number" -t 2>/dev/null | awk '{print strtonum("0" $4)}'); then
        echo "ERROR: Failed to get current input source for I2C bus $i2c_bus_number" >&2
        return 1
    fi

    # Determine the new input source
    if [[ "$current_input" == "$local_input_source" ]]; then
        new_input="$remote_input_source"
    else
        new_input="$local_input_source"
    fi

    # Store the new input source and I2C bus number
    new_inputs+=("$new_input")
    i2c_buses+=("$i2c_bus_number")
}

# Detect display number => i2c bus number
# ddcutil operates much faster with i2c bus number
declare -A display_map

# Read input line by line
while IFS= read -r line; do
    # Check if the line contains "Display"
    if [[ $line =~ ^Display[[:space:]]([0-9]+) ]]; then
        display_number=${BASH_REMATCH[1]}
    fi
    
    # Check if the line contains "I2C bus"
    if [[ $line =~ I2C[[:space:]]bus:[[:space:]]*/dev/i2c-([0-9]+) ]]; then
        i2c_bus_number=${BASH_REMATCH[1]}
        display_map[$display_number]=$i2c_bus_number
    fi
done <<< "$(ddcutil detect -t 2>/dev/null)" || {
    echo "ERROR: Failed to detect displays with ddcutil" >&2
    exit 1
}

for target_display in "$@"; do
    i2c_bus_number=${display_map[$target_display]:-}
    if [[ -n "$i2c_bus_number" ]]; then
        echo "Collecting new input source for Display $target_display on I2C bus $i2c_bus_number"
        if ! collect_new_input_source "$i2c_bus_number" "${local_input_sources[$target_display]}" "${remote_input_sources[$target_display]}"; then
            echo "ERROR: Failed to collect input source for Display $target_display" >&2
            exit 1
        fi
    else
        echo "ERROR: Display $target_display not found or not detected" >&2
        exit 1
    fi
done

echo ${i2c_buses}

# After collecting all new inputs, execute the ddcutil setvcp commands in parallel
for i in "${!new_inputs[@]}"; do
    {
        echo "Executing: ddcutil setvcp 60 ${new_inputs[$i]} -b ${i2c_buses[$i]}"
        if ! ddcutil setvcp 60 "${new_inputs[$i]}" -b "${i2c_buses[$i]}" 2>/dev/null; then
            echo "ERROR: Failed to set input source for I2C bus ${i2c_buses[$i]}" >&2
            exit 1
        fi
    } &
done

# Wait for all background processes to finish
wait

echo "All input sources have been toggled."
