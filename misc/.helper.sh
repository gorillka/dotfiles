#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Core Functions Library - Prevents multiple loading of core functionality
# ------------------------------------------------------------------------------

# Guard clause to prevent multiple loading of this module
[[ -n "${_CORE_FUNC_LOADED:-}" ]] && return
_CORE_FUNC_LOADED=1

# ------------------------------------------------------------------------------
# Loads all core functions required by the script
# Initializes colors and icons for consistent output formatting
# ------------------------------------------------------------------------------
__load_core_func() {
    # Prevent multiple initialization of functions
    [[ -n "${__CORE_FUNCTIONS_LOADED:-}" ]] && return
    __CORE_FUNCTIONS_LOADED=1

    __variables
    # Initialize color definitions
    __colors

    # Initialize icon definitions
    __icons

    __override_sudo
}

# Initialize global variables used throughout the script
__variables() {
    MSG_INFO_SHOWN=" "                                                         # Flag to track if info message was shown
    SUDO=""
}

# ------------------------------------------------------------------------------
# Sets ANSI color codes used for styled terminal output.
# Defines both bold and normal variants for consistent theming
# ------------------------------------------------------------------------------
__colors() {
    # Bold color definitions for emphasis
    RED=$'\e[1;31m'           # Bold red for errors
    GREEN=$'\e[1;32m'         # Bold green for success
    GREEN_NORMAL=$'\e[32m'    # Normal green for secondary success
    YELLOW=$'\e[1;33m'        # Bold yellow for warnings
    BLUE=$'\e[1;34m'          # Bold blue for information
    MAGENTA=$'\e[1;1;35m'     # Bold magenta for special cases
    CYAN=$'\e[1;36m'          # Bold cyan for highlights
    CYAN_NORMAL=$'\e[36m'     # Normal cyan for secondary highlights
    ORANGE=$'\e[1;38;5;214m'  # Orange for questions/prompts
    END=$'\e[0m'              # Reset sequence to end formatting
}

# ------------------------------------------------------------------------------
# Sets symbolic icons used throughout user feedback and prompts.
# Each icon is prefixed with appropriate colors for visual consistency
# ------------------------------------------------------------------------------
__icons() {
    OK="${CYAN}:::${END}"          # General information/status
    ACTION="${GREEN}==>${END}"      # Action being performed
    QUESTION="${ORANGE}???${END}"   # User input required
    NOTE="${BLUE}***${END}"       # Important note or tip
    SKIP="${MAGENTA}---${END}"      # Skipped operation
    WARNING="${YELLOW}!!!${END}"    # Warning message
    ERROR="${RED}>-<${END}"         # Error message
}

#==============================================================================
# SPINNER AND MESSAGE FUNCTIONS
#==============================================================================
# This module provides spinner animation and various message display functions
# for interactive shell scripts with visual feedback.

#------------------------------------------------------------------------------
# Private function to display animated spinner
# Uses Unicode braille characters for smooth animation
#------------------------------------------------------------------------------
__spinner() {
    # Define spinner characters (Unicode braille patterns)
    local -a chars=(⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷)
    local i=0

    # Infinite loop for continuous animation
    while true; do
        # Calculate current character index using modulo
        local index=$((i++ % ${#chars[@]}))

        # Clear line and print spinner with message
        # \r = carriage return, \033[2K = clear entire line
        printf "\r\033[2K%s %s" "${RED}${chars[$index]}${END}" "  ${SPINNER_MSG:-}"

        # Animation speed (80ms delay)
        sleep 0.08
    done
}

#------------------------------------------------------------------------------
# Private function to stop the spinner process
# Handles cleanup of background process and temporary files
#------------------------------------------------------------------------------
__stop_spinner() {
    # Get spinner PID from variable or temp file
    local pid="${SPINNER_PID:-}"
    [[ -z "$pid" && -f /tmp/.spinner.pid ]] && pid=$(</tmp/.spinner.pid)

    # Kill spinner process if valid PID exists
    if [[ -n "$pid" && "$pid" =~ ^[0-9]+$ ]]; then
        # Try graceful termination first
        if kill "$pid" 2>/dev/null; then
            sleep 0.05
            # Force kill if still running
            kill -9 "$pid" 2>/dev/null || true
            # Wait for process to terminate
            wait "$pid" 2>/dev/null || true
        fi
        # Clean up temporary PID file
        rm -f /tmp/.spinner.pid
    fi

    # Clean up environment variables
    unset SPINNER_PID SPINNER_MSG

    # Reset terminal to sane state
    stty sane 2>/dev/null || true
}

#------------------------------------------------------------------------------
# Private function for general message formatting
# Parameters: action_symbol message_text
#------------------------------------------------------------------------------
__msg_general() {
    local action="$1"
    local message="$2"

    # Print formatted message with action symbol
    printf "%s %b\n" "$action" "$message"
}

#------------------------------------------------------------------------------
# Display spinning message (prevents duplicate messages)
# Parameters: message_text
#------------------------------------------------------------------------------
msg_spin() {
    local msg="$1"
    [[ -z "$msg" ]] && return

    # Initialize message tracking variable if not set
    if [[ -z "$MSG_INFO_SHOWN" ]]; then
        export MSG_INFO_SHOWN=" "
    fi

    # Skip if message already shown (prevent duplicates)
    if [[ "$MSG_INFO_SHOWN" == *" $msg "* ]]; then
        return
    fi

    # Add message to shown list
    MSG_INFO_SHOWN+=" $msg "

    if [ "${VERBOSE:-no}" == "yes" ]; then
        return
    fi

    # Stop any existing spinner and start new one
    __stop_spinner
    SPINNER_MSG="$msg"

    # Start spinner in background
    __spinner &
    SPINNER_PID=$!

    # Save PID to file for recovery
    echo "$SPINNER_PID" > /tmp/.spinner.pid
    # Detach from current shell
    disown "$SPINNER_PID" 2>/dev/null || true
}

#------------------------------------------------------------------------------
# Display success message and stop spinner
# Parameters: message_text
#------------------------------------------------------------------------------
msg_ok() {
    local msg="$1"
    [[ -z "$msg" ]] && return

    # Stop spinner and clear line
    __stop_spinner
    clear_line

    # Display success message to stderr
    __msg_general "${OK}" "${msg}" >&2

    # Remove message from shown list
    MSG_INFO_SHOWN=${MSG_INFO_SHOWN/ "$msg" / }

    # Clean up whitespace in tracking variable
    MSG_INFO_SHOWN=$(echo "$MSG_INFO_SHOWN" | sed -e 's/^ *//' -e 's/ *$//')
}

#------------------------------------------------------------------------------
# Display action message with delay
# Parameters: message_text
#------------------------------------------------------------------------------
msg_act() {
    local msg="$1"

    # Display action message and pause for visibility
    __msg_general "${ACTION}" "${msg}" && sleep 1
}

#------------------------------------------------------------------------------
# Display question/prompt message
# Parameters: message_text
#------------------------------------------------------------------------------
msg_ask() {
    local msg="$1"

    # Display question with colon suffix
    __msg_general "${QUESTION}" "$msg:"
}

#------------------------------------------------------------------------------
# Display informational note message
# Parameters: message_text
#------------------------------------------------------------------------------
msg_note() {
    local msg="$1"

    # Display note message
    __msg_general "${NOTE}" "$msg"
}

#------------------------------------------------------------------------------
# Display skip message
# Parameters: message_text
#------------------------------------------------------------------------------
msg_skip() {
    local msg="$1"

    # Display skip message
    __msg_general "${SKIP}" "$msg"
}

#------------------------------------------------------------------------------
# Display warning message (stops spinner first)
# Parameters: message_text
#------------------------------------------------------------------------------
msg_warn() {
    # Stop spinner before showing warning
    __stop_spinner
    local msg="$1"

    # Display warning message
    __msg_general "${WARNING}" "$msg"
}

#------------------------------------------------------------------------------
# Display error message (stops spinner first)
# Parameters: message_text
#------------------------------------------------------------------------------
msg_error() {
    # Stop spinner before showing error
    __stop_spinner
    local msg="$1"

    # Display error message
    __msg_general "${ERROR}" "$msg"
}

#------------------------------------------------------------------------------
# Set up trap to ensure spinner cleanup on script exit
#------------------------------------------------------------------------------
trap '__stop_spinner; exit' EXIT INT TERM

# ------------------------------------------------------------------------------
# Clears the current terminal line
# Uses tput commands with fallback to ANSI escape sequences
# ------------------------------------------------------------------------------
clear_line() {
    # Move cursor to beginning of line (carriage return)
    tput cr 2>/dev/null || echo -en "\r"

    # Clear from cursor to end of line
    tput el 2>/dev/null || echo -en "\033[K"
}

# ------------------------------------------------------------------------------
# Prints error message and terminates script
# Uses interrupt signal to allow cleanup handlers to run
# ------------------------------------------------------------------------------
fatal() {
    # Display error message using msg_error function
    msg_error "$1"

    # Send interrupt signal to current process for clean termination
    kill -INT $$
}

# Configure sudo behavior based on user privileges and system availability
__override_sudo() {
    if [ "$USER" = "root" ] || [ ! command -v sudo &>/dev/null ]; then
        SUDO=                                      # Remove sudo if running as root or sudo not available
    else
        SUDO=sudo                               # Preserve environment variables with sudo
        eval "$SUDO --validate"                                    # Validate/refresh sudo credentials
    fi
}

# Find app
find_app() {
    local name="$1"
    local common_install_paths=("/opt/homebrew/bin/${name}" "/home/linuxbrew/.linuxbrew/bin/${name}" "/usr/local/bin/${name}" "/usr/bin/${name}")
    local app_path=""

    for current_path in "${common_install_paths[@]}"; do
        msg_act "Checking for ${name} at ${current_path}"
        if [ -x "${current_path}" ]; then
            msg_note "${name} found at ${current_path}"
            app_path="${current_path}"
            break  # Зупиняємо цикл після знаходження
        fi
    done

    # Виводимо шлях або порожній рядок, якщо не знайдено
    echo "${app_path}"
}

__load_core_func
