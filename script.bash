#!/bin/bash

# Function to check if Homebrew is installed
check_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        (echo; echo 'eval "$(/usr/local/bin/brew shellenv)"') >> /Users/admin/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    else
        echo "Homebrew is already installed."
    fi
}

# Function to install software using Homebrew
install_software() {
    echo "Installing software..."

    # List of casks to install
    casks=(
        google-chrome
        nextcloud
        onlyoffice
        openoffice
    )

    # List of other software to install
    formulas=(
        git
    )

    for cask in "${casks[@]}"; do
        read -p "Do you want to install $cask? (y/n): " answer
        if [ "$answer" != "${answer#[Yy]}" ]; then
            brew install --cask $cask
        else
            echo "Skipping $cask"
        fi
    done

    for formula in "${formulas[@]}"; do
        read -p "Do you want to install $formula? (y/n): " answer
        if [ "$answer" != "${answer#[Yy]}" ]; then
            brew install $formula
        else
            echo "Skipping $formula"
        fi
    done
}

# Function to add a WiFi network
add_wifi() {
    echo "Adding WiFi network..."
    read -p "Enter WiFi SSID: " wifi_ssid
    read -sp "Enter WiFi Password: " wifi_password
    echo
    networksetup -setairportnetwork en0 "$wifi_ssid" "$wifi_password"
}

# Function to add a new user
add_user() {
    echo "Adding new user..."
    read -p "Enter new username: " new_username
    read -sp "Enter password for new user: " new_password
    echo
    read -sp "Confirm password for new user: " confirm_password
    echo

    if [ "$new_password" != "$confirm_password" ]; then
        echo "Passwords do not match. Exiting..."
        exit 1
    fi

    sudo sysadminctl -addUser $new_username -password $new_password
}


# Main script execution
check_homebrew
install_software
add_wifi
add_user

echo "Script execution complete."
