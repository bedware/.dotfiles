#!/bin/zsh

# Edge Workspace Cache Reader for macOS
# This script reads Microsoft Edge workspace cache and extracts workspace information

# Default paths for Edge profiles
EDGE_DEFAULT_PATH="$HOME/Library/Application Support/Microsoft Edge/Default/Workspaces/WorkspacesCache"
EDGE_PROFILE2_PATH="$HOME/Library/Application Support/Microsoft Edge/Profile 2/Workspaces/WorkspacesCache"

# Function to check if jq is installed
check_jq() {
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is not installed. Please install it first:"
        echo "  brew install jq"
        exit 1
    fi
}

# Function to read workspace cache
read_workspace_cache() {
    local cache_path="$1"
    local profile_name="$2"
    
    if [[ ! -f "$cache_path" ]]; then
        echo "Warning: Cache file not found at $cache_path"
        return 1
    fi
    
    echo "=== Edge Workspaces - $profile_name ==="
    echo
    
    # Parse JSON and extract workspace information
    jq -r '.workspaces[] | 
        "\(.name)|\(.id)|\(.active)|\(.accent)|\(.count)|\(.menuSubtitle // "No subtitle")"' "$cache_path" | \
    while IFS='|' read -r name id active accent count subtitle; do
        # Format status indicators
        if [[ "$active" == "true" ]]; then
            status_char=">"
        elif [[ "$accent" == "true" ]]; then
            status_char="+"
        else
            status_char="-"
        fi
        
        # Print formatted output
        printf "%s %-20s | ID: %s | %s\n" "$status_char" "$name" "$id" "$subtitle"
    done
    
    echo
}

# Function to get workspace list for fzf (similar to PowerShell version)
get_workspace_list_for_fzf() {
    local cache_path="$1"
    
    if [[ ! -f "$cache_path" ]]; then
        return 1
    fi
    
    jq -r '.workspaces[] | 
        if .active == true then "> " + .name
        elif .accent == true then "+ " + .name  
        else "- " + .name
        end' "$cache_path" | sort -r
}

# Function to get workspace ID by name
get_workspace_id() {
    local cache_path="$1"
    local workspace_name="$2"
    
    if [[ ! -f "$cache_path" ]]; then
        return 1
    fi
    
    jq -r --arg name "$workspace_name" '.workspaces[] | select(.name == $name) | .id' "$cache_path"
}

# Function to get all workspace data as JSON
get_workspace_data() {
    local cache_path="$1"
    
    if [[ ! -f "$cache_path" ]]; then
        return 1
    fi
    
    jq '.workspaces' "$cache_path"
}

# Main function
main() {
    check_jq
    
    # Parse command line arguments
    case "${1:-list}" in
        "list"|"")
            # List workspaces from both profiles
            if [[ -f "$EDGE_DEFAULT_PATH" ]]; then
                read_workspace_cache "$EDGE_DEFAULT_PATH" "Default Profile"
            fi
            
            if [[ -f "$EDGE_PROFILE2_PATH" ]]; then
                read_workspace_cache "$EDGE_PROFILE2_PATH" "Profile 2"
            fi
            
            if [[ ! -f "$EDGE_DEFAULT_PATH" && ! -f "$EDGE_PROFILE2_PATH" ]]; then
                echo "Error: No Edge workspace cache files found."
                echo "Expected locations:"
                echo "  $EDGE_DEFAULT_PATH"
                echo "  $EDGE_PROFILE2_PATH"
                exit 1
            fi
            ;;
        "fzf")
            # Output format suitable for fzf
            profile_path="${2:-$EDGE_DEFAULT_PATH}"
            get_workspace_list_for_fzf "$profile_path"
            ;;
        "id")
            # Get workspace ID by name
            if [[ -z "$3" ]]; then
                echo "Usage: $0 id <cache_path> <workspace_name>"
                exit 1
            fi
            get_workspace_id "$2" "$3"
            ;;
        "json")
            # Output raw JSON data
            profile_path="${2:-$EDGE_DEFAULT_PATH}"
            get_workspace_data "$profile_path"
            ;;
        "help"|"-h"|"--help")
            echo "Usage: $0 [command] [options]"
            echo ""
            echo "Commands:"
            echo "  list          List all workspaces (default)"
            echo "  fzf [path]    Output workspace list for fzf"
            echo "  id <path> <name>  Get workspace ID by name"
            echo "  json [path]   Output raw JSON workspace data"
            echo "  help          Show this help message"
            echo ""
            echo "Default cache paths:"
            echo "  Default: $EDGE_DEFAULT_PATH"
            echo "  Profile 2: $EDGE_PROFILE2_PATH"
            ;;
        *)
            echo "Unknown command: $1"
            echo "Use '$0 help' for usage information"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
