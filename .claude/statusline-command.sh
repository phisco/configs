#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
transcript_path=$(echo "$input" | jq -r '.transcript_path')
model_name=$(echo "$input" | jq -r '.model.display_name')
model_id=$(echo "$input" | jq -r '.model.id')

# Context window stats
total_input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
used_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // empty')



# Shorten directory path (show last 2 components)
if [ "$cwd" = "$project_dir" ]; then
    short_dir=$(basename "$cwd")
elif [ -n "$project_dir" ]; then
    # Show relative path from project dir
    short_dir="$(basename "$project_dir")/...$(echo "$cwd" | sed "s|$project_dir||")"
else
    short_dir=$(echo "$cwd" | awk -F/ '{print $(NF-1)"/"$NF}')
fi

# Get git branch (skip optional locks for performance)
git_branch=""
if cd "$cwd" 2>/dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        git_branch=" on 🌿 $branch"
    fi
fi

# Count running agents and turns from transcript
agent_count=0
turn_count=0
if [ -f "$transcript_path" ]; then
    agent_count=$(jq -r '[.turns[] | select(.role == "assistant" and .message.content[]?.type == "agent_use")] | length' "$transcript_path" 2>/dev/null || echo "0")
    turn_count=$(jq -r '[.turns[] | select(.role == "user")] | length' "$transcript_path" 2>/dev/null || echo "0")
fi

# Format token information from JSON input
token_info=""
context_info=""

# Format token information
if [ -n "$total_input_tokens" ] && [ -n "$total_output_tokens" ]; then
    # Format tokens in K (thousands)
    input_k=$(echo "scale=1; $total_input_tokens / 1000" | bc 2>/dev/null)
    output_k=$(echo "scale=1; $total_output_tokens / 1000" | bc 2>/dev/null)
    total_k=$(echo "scale=1; ($total_input_tokens + $total_output_tokens) / 1000" | bc 2>/dev/null)

    if [ -n "$input_k" ] && [ -n "$output_k" ]; then
        token_info="📊 ${input_k}K↓ ${output_k}K↑ (${total_k}K)"
    fi
fi


# Format context window information (just percentage)
if [ -n "$used_percentage" ] && [ "$used_percentage" != "null" ]; then
    context_info="🧠 ${used_percentage}%"
fi


# Build left side of status line
# Format: 🤖 [Model] 📁 dir 🌿 branch | 🔧 Agents: N
left_status=""

# Model (shortened)
model_short=$(echo "$model_name" | sed 's/Claude //' | sed 's/ /-/g')
left_status="🤖 $model_short"

# Directory
left_status="$left_status │ 📁 $short_dir"

# Git branch
if [ -n "$git_branch" ]; then
    left_status="$left_status$git_branch"
fi

# Agents (only show if > 0)
if [ "$agent_count" -gt 0 ]; then
    left_status="$left_status │ 🔧 Agents: $agent_count"
fi

# Build right side of status line
# Format: 💬 turns | 🧠 context | 📊 tokens | 💾 cache
right_status=""

# Turn count
if [ "$turn_count" -gt 0 ]; then
    right_status="💬 ${turn_count}"
fi

# Context window info
if [ -n "$context_info" ]; then
    if [ -n "$right_status" ]; then
        right_status="$right_status │ $context_info"
    else
        right_status="$context_info"
    fi
fi

# Token info
if [ -n "$token_info" ]; then
    if [ -n "$right_status" ]; then
        right_status="$right_status │ $token_info"
    else
        right_status="$token_info"
    fi
fi



# Get terminal width (default to 100 if unable to determine)
term_width=${COLUMNS:-100}

# Count emojis (they display as 2 chars but count as more bytes)
count_emojis() {
    echo "$1" | grep -o '[🤖📁🌿🔧💬🧠📊│]' | wc -l | tr -d ' '
}

# Calculate display width (string length + emoji adjustment)
left_emoji_count=$(count_emojis "$left_status")
right_emoji_count=$(count_emojis "$right_status")

# Each emoji is ~4 bytes but displays as 2 chars, so subtract 2 per emoji
left_display_len=$((${#left_status} - left_emoji_count * 2))
right_display_len=$((${#right_status} - right_emoji_count * 2))

if [ -n "$right_status" ]; then
    spaces_needed=$((term_width - left_display_len - right_display_len))

    if [ $spaces_needed -gt 0 ]; then
        padding=$(printf "%${spaces_needed}s" "")
        echo -n "${left_status}${padding}${right_status}"
    else
        echo -n "${left_status}  ${right_status}"
    fi
else
    echo -n "$left_status"
fi
