Andromeda Project
=================

# Getting Started

Andromeda requires an old-skool build system that we shamefully used a while back.

    # Clone the repository
    git clone https://github.com/zooniverse/AndromedaProject.git
    
    cd AndromedaProject
    
    # If using RVM, create a new gemset
    rvm 1.9.3@ap --create
    
    # Install Bundler
    gem install bundler
    
    # Install development dependencies in the Gemfile
    bundle install
    
    # Install Node based development dependencies in package.json
    npm install
    
    # Serve the project locally
    zoo serve
    
    # Build the project into a build directory
    zoo build
    