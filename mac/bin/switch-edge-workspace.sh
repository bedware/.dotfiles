#!/bin/zsh

# Edge Workspace Switcher for macOS
# Equivalent to the Windows PowerShell Switch-BrowserWorkspace.ps1

# Configuration
EDGE_DEFAULT_PATH="$HOME/Library/Application Support/Microsoft Edge/Default/Workspaces/WorkspacesCache"
EDGE_PROFILE2_PATH="$HOME/Library/Application Support/Microsoft Edge/Profile 2/Workspaces/WorkspacesCache"
WORKSPACE_SCRIPT="$(dirname "$0")/get-edge-workspaces.sh"

# Default settings
LOOP_MODE=true

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

# Function to check dependencies
check_dependencies() {
    local missing_deps=()
    
    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi
    
    if ! command -v fzf &> /dev/null; then
        missing_deps+=("fzf")
    fi
    
    if ! command -v osascript &> /dev/null; then
        missing_deps+=("osascript")
    fi
    
    if [[ ! -f "$WORKSPACE_SCRIPT" ]]; then
        print_status "$RED" "Error: get-edge-workspaces.sh not found at $WORKSPACE_SCRIPT"
        exit 1
    fi
    
    if (( ${#missing_deps[@]} > 0 )); then
        print_status "$RED" "Error: Missing dependencies: ${missing_deps[*]}"
        echo "Please install them with:"
        for dep in "${missing_deps[@]}"; do
            case "$dep" in
                "jq"|"fzf")
                    echo "  brew install $dep"
                    ;;
            esac
        done
        exit 1
    fi
}

# Function to get current Edge window title using AppleScript
get_edge_window_title() {
    osascript -e '
    tell application "System Events"
        try
            set frontApp to name of first application process whose frontmost is true
            if frontApp is "Microsoft Edge" then
                tell application "Microsoft Edge"
                    if (count of windows) > 0 then
                        return name of front window
                    else
                        return "No Edge windows"
                    end if
                end tell
            else
                return "Edge not frontmost"
            end if
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell' 2>/dev/null || echo "AppleScript permission needed"
}

# Function to detect current profile based on window title
detect_current_profile() {
    local window_title
    window_title=$(get_edge_window_title)
    
    print_status "$BLUE" "Detecting profile..." >&2
    
    # If window title detection failed or returned an error, skip window-based detection
    if [[ "$window_title" == *"Error"* ]] || [[ "$window_title" == *"permission"* ]] || [[ -z "$window_title" ]]; then
        print_status "$YELLOW" "Window detection failed, using available cache files" >&2
    else
        print_status "$BLUE" "Current Edge window: $window_title" >&2
        
        # Check for profile indicators in window title (similar to PowerShell version)
        if [[ "$window_title" =~ "- Alfa -" ]] || [[ "$window_title" =~ "Profile 2" ]]; then
            echo "profile2"
            return 0
        elif [[ "$window_title" =~ "- Personal -" ]] || [[ "$window_title" =~ "Default" ]]; then
            echo "default"
            return 0
        fi
    fi
    
    # Default to the profile that has a cache file
    if [[ -f "$EDGE_DEFAULT_PATH" ]]; then
        print_status "$BLUE" "Using Default Profile (cache file found)" >&2
        echo "default"
    elif [[ -f "$EDGE_PROFILE2_PATH" ]]; then
        print_status "$BLUE" "Using Profile 2 (cache file found)" >&2
        echo "profile2"
    else
        echo "none"
        return 1
    fi
}

# Function to get cache path for profile
get_cache_path() {
    local profile="$1"
    case "$profile" in
        "default")
            echo "$EDGE_DEFAULT_PATH"
            ;;
        "profile2")
            echo "$EDGE_PROFILE2_PATH"
            ;;
        *)
            return 1
            ;;
    esac
}

# Function to launch Edge with workspace
launch_edge_workspace() {
    local workspace_id="$1"
    local workspace_name="$2"
    
    print_status "$GREEN" "Launching Edge with workspace: $workspace_name"
    print_status "$BLUE" "Workspace ID: $workspace_id"
    
    # Try multiple launch methods
    local edge_exec="/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
    
    if [[ -x "$edge_exec" ]]; then
        print_status "$BLUE" "Using direct executable launch..."
        "$edge_exec" --launch-workspace="$workspace_id" &
    else
        print_status "$BLUE" "Using open command launch..."
        open -n -a "Microsoft Edge" --args "--launch-workspace=$workspace_id"
    fi
    
    # Wait a moment for Edge to launch
    # sleep 3
    
    # Focus the Edge window using AppleScript
    # print_status "$BLUE" "Focusing Edge window..."
    # osascript -e "
    # tell application \"Microsoft Edge\"
    #     activate
    #     delay 1
    # end tell
    
    # tell application \"System Events\"
    #     tell process \"Microsoft Edge\"
    #         try
    #             set frontmost to true
    #         end try
    #     end tell
    # end tell" 2>/dev/null
    
    # print_status "$GREEN" "✅ Edge workspace '$workspace_name' should now be active"
    # print_status "$YELLOW" "If the workspace didn't open correctly, try closing Edge completely and running the script again."
    
    # Close the Terminal window after launching workspace
    # sleep 1
    # osascript -e 'tell application "Terminal" to close front window' &>/dev/null &
}

# Function to select workspace with fzf
select_workspace() {
    local cache_path="$1"
    local profile_name="$2"
    
    if [[ ! -f "$cache_path" ]]; then
        print_status "$RED" "Error: Cache file not found at $cache_path"
        return 1
    fi
    
    print_status "$YELLOW" "Selecting workspace for $profile_name..."
    
    # Get workspace list for fzf (same format as PowerShell version)
    local selected_workspace
    selected_workspace=$("$WORKSPACE_SCRIPT" fzf "$cache_path" | \
        fzf --layout=reverse \
            --border=rounded \
            --border-label="Select Workspace" \
            --margin="1,1,0,1" \
            --info=hidden \
            --prompt="Workspace > ")
    
    if [[ -z "$selected_workspace" ]]; then
        print_status "$YELLOW" "No workspace selected. Exiting."
        return 1
    fi
    
    # Remove the status prefix (>, +, -) to get clean workspace name
    local workspace_name="${selected_workspace:2}"
    
    # Get the workspace ID
    local workspace_id
    workspace_id=$("$WORKSPACE_SCRIPT" id "$cache_path" "$workspace_name")
    
    if [[ -z "$workspace_id" ]]; then
        print_status "$RED" "Error: Could not find workspace ID for '$workspace_name'"
        return 1
    fi
    
    # Launch Edge with the selected workspace
    launch_edge_workspace "$workspace_id" "$workspace_name"
}

# Function to show current workspaces
show_workspaces() {
    print_status "$BLUE" "Available Edge workspaces:"
    echo
    "$WORKSPACE_SCRIPT" list
}

# Function to parse command line arguments
parse_arguments() {
    local args=()
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --loop)
                LOOP_MODE=true
                shift
                ;;
            --no-loop)
                LOOP_MODE=false
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            -*)
                print_status "$RED" "Unknown option: $1"
                echo "Use '$0 --help' for usage information"
                exit 1
                ;;
            *)
                args+=("$1")
                shift
                ;;
        esac
    done
    
    # Return the remaining arguments
    echo "${args[@]}"
}

# Function to show help
show_help() {
    echo "Usage: $0 [options] [command]"
    echo ""
    echo "Options:"
    echo "  --loop        Enable loop mode (default)"
    echo "  --no-loop     Disable loop mode"
    echo "  --help, -h    Show this help message"
    echo ""
    echo "Commands:"
    echo "  auto          Auto-detect profile and switch workspace (default)"
    echo "  default       Use default profile"
    echo "  profile2      Use profile 2"
    echo "  list          Show available workspaces"
    echo ""
    echo "The script will:"
    echo "  1. Detect your current Edge profile (or use specified profile)"
    echo "  2. Show available workspaces in fzf"
    echo "  3. Launch Edge with selected workspace"
    echo "  4. Focus the new Edge window"
    echo "  5. Loop back to step 1 if --loop is enabled (default)"
    echo ""
    echo "Examples:"
    echo "  $0                    # Auto-detect with loop (default)"
    echo "  $0 --no-loop auto     # Auto-detect without loop"
    echo "  $0 --loop default     # Force default profile with loop"
    echo "  $0 list               # Show workspaces and exit"
}

# Main function
main() {
    # print_status "$GREEN" "🔄 Edge Workspace Switcher for macOS"
    echo
    
    # Check dependencies
    check_dependencies
    
    # Parse arguments and get remaining command
    local remaining_args
    remaining_args=$(parse_arguments "$@")
    eval set -- "$remaining_args"
    
    # Show loop mode status
    # if [[ "$LOOP_MODE" == "true" ]]; then
    #     print_status "$BLUE" "Loop mode: enabled (will continue until interrupted)"
    # else
    #     print_status "$BLUE" "Loop mode: disabled (will exit after one selection)"
    # fi
    # echo
    
    # Main loop
    while true; do
        # Parse command line arguments
        case "${1:-auto}" in
            "auto"|"")
                # Automatic mode - detect current profile and switch
                local current_profile
                current_profile=$(detect_current_profile)
                
                if [[ "$current_profile" == "none" ]]; then
                    print_status "$RED" "Error: No Edge profile cache found and cannot detect current profile"
                    print_status "$YELLOW" "Available cache files should be at:"
                    echo "  $EDGE_DEFAULT_PATH"
                    echo "  $EDGE_PROFILE2_PATH"
                    if [[ "$LOOP_MODE" == "true" ]]; then
                        print_status "$YELLOW" "Retrying in 3 seconds..."
                        sleep 3
                        continue
                    else
                        exit 1
                    fi
                fi
                
                local cache_path
                cache_path=$(get_cache_path "$current_profile")
                
                case "$current_profile" in
                    "default")
                        select_workspace "$cache_path" "Default Profile"
                        ;;
                    "profile2")
                        select_workspace "$cache_path" "Profile 2"
                        ;;
                esac
                ;;
            "default")
                # Force default profile
                select_workspace "$EDGE_DEFAULT_PATH" "Default Profile"
                ;;
            "profile2")
                # Force profile 2
                select_workspace "$EDGE_PROFILE2_PATH" "Profile 2"
                ;;
            "list")
                # Show available workspaces
                show_workspaces
                ;;
            "help"|"-h"|"--help")
                show_help
                exit 0
                ;;
            *)
                print_status "$RED" "Unknown command: $1"
                echo "Use '$0 --help' for usage information"
                exit 1
                ;;
        esac
        
        # Check if we should continue looping
        if [[ "$LOOP_MODE" == "false" ]]; then
            break
        fi
        
        # If we're in loop mode, wait a moment before continuing
        if [[ "$LOOP_MODE" == "true" ]]; then
            print_status "$BLUE" "Press Ctrl+C to exit loop mode"
            echo
        fi
    done
}

# Run main function with all arguments
main "$@"
