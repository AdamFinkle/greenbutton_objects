#!/bin/bash


STARTUP_DIR=$(pwd)

python -m pip install -U pip

# Clone home energy app
if [ ! -d "../home-energy-analysis-tool" ]; then
  git clone https://github.com/AdamFinkle/home-energy-analysis-tool.git ../home-energy-analysis-tool
fi

# Set up the environment for the home energy app
cd ../home-energy-analysis-tool/rules-engine

if [ "$(git rev-parse --abbrev-ref HEAD)" != "multi-repo-container" ]; then
  git fetch --all
  git checkout multi-repo-container
fi

# NOTE: It's very important that the home energy app requirements are installed
# first before installing the requirements for the greenbutton library.
# Otherwise edit to greenbutton library will not be reflected in the app

# TODO: This should actually live in the home energy app repo
python -m pip install -r requirements.txt
python -m pip install -r requirements-dev.txt
python -m pip install -e .

# Run the setup script from default container
echo "----------------- Setting up Greenbutton library envrionment -------"
cd $STARTUP_DIR
.devcontainer/env_setup.sh
