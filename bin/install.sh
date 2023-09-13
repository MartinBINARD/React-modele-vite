#!/bin/bash

# Couleurs pour les messages
RED="\033[38;5;167m"
NC="\033[0m" # Reset des couleurs

# Fonction pour afficher le logo
print_logo() {
  echo "                                                                 "
  echo "  #    #   ####    ####    #####  #####    ####   #    #   ####  "
  echo "  ##   #  #    #  #          #    #    #  #    #  ##  ##  #    # "
  echo "  # #  #  #    #   ####      #    #    #  #    #  # ## #  #    # "
  echo "  #  # #  #    #       #     #    #####   #    #  #    #  #    # "
  echo "  #  # #  #    #       #     #    #####   #    #  #    #  #    # "
  echo "  #    #   ####    ####      #    #    #   ####   #    #   ####  "
  echo "                                                                 "
  echo "                                                                 "
  echo "   ####    ####   #    #  #####   #    #   #####  ######  #####  "
  echo "  #    #  #    #  ##  ##  #    #  #    #     #    #       #    # "
  echo "  #       #    #  # ## #  #    #  #    #     #    #####   #    # "
  echo "  #       #    #  #    #  #####   #    #     #    #       #####  "
  echo "  #    #  #    #  #    #  #       #    #     #    #       #   #  "
  echo "   ####    ####   #    #  #        ####      #    ######  #    # "
  echo "                                                                 "

}

# Fonction pour afficher un message en bleu
print_info() {
  if [ -z $2 ]; then
    echo
  fi

  echo -e "${BLUE}$1${NC} \c"
}

# Fonction pour afficher un message en vert
print_success() {
  if [ -z $2 ]; then
    echo
  fi

  echo -e "${GREEN}$1${NC}"
}

# Fonction pour afficher un message en rouge
print_error() {
  if [ -z $2 ]; then
    echo
  fi

  echo -e "${RED}$1${NC}"
}

print_logo

print_error "                                                            " 0
print_error "  SPECIAL ORDER 937... select a remote repo ...             " 0
print_error "  OVERRIDE PRIORITY ONE ... code a marvelous application ..." 0
print_error "  ALL OTHER CONSIDERATIONS SECONDARY                        " 0
print_error "                                                          " 0

print_info "  ⌂"
echo "Welcome to "Mother", the configuration wizard for your new project"
echo

echo "  Please enter the Git repository address or your project name:"
ASK=$(print_success ">" 0)
read -p "$ASK " GIT_REPO

if [ -z "$GIT_REPO" ]; then
  print_error " ❌ No Git repository path or name specified."
  exit 1
fi

if [[ "$GIT_REPO" =~ \.git$ ]]; then
  if ! git ls-remote --exit-code "$GIT_REPO" >/dev/null 2>&1; then
    print_error " ❌ The Git repository does not exist or is inaccessible."
    exit 1
  fi

  git clone "$GIT_REPO"

  if [ $? -eq 0 ]; then
    TARGET_DIRECTORY=$(basename "$GIT_REPO" .git)
  else
    print_error " ❌ Failed to clone Git repository."
    exit 1
  fi
else
  TARGET_DIRECTORY="$GIT_REPO"
  mkdir "$TARGET_DIRECTORY"
fi

print_info "  →"
echo Copying template folders and files

cp -n ./React-modele-vite/{.*,*} "./$TARGET_DIRECTORY"
cp -rn ./React-modele-vite/{src,public,.vscode} "./$TARGET_DIRECTORY"

if [ $? -eq 0 ]; then
  print_success "✓ The template was successfully copied"
else
  print_error "❌ Unable to copy !"
  exit 1
fi

cd "./$TARGET_DIRECTORY"

print_info "  →"
echo "Installing dependencies with yarn"
yarn
print_success "✓ Dependencies are installed"

print_info "  →"
echo "Generating the first commit"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git init
fi

git add .
git commit -m "Install React-modele-vite"

if git remote >/dev/null 2>&1; then
  git push
fi
print_success "✓ The first commit is validated"

print_info "  →"
echo "Opening the project in VS Code"
code .
print_success "✓ The project is open"

print_info "  →"
echo "Launching the server with yarn dev"
yarn dev --open
