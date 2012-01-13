# Muppet

Easy CLI server provisioning using Sprinkle

## Installation

    $ gem install muppet

## Usage

Create a new provisioning project

    $ muppet init my_project

List available policies

    $ cd my_project
    $ muppet list
    
Add a pre-defined policy to your project

    $ muppet add monit
    
Policies and dependent packages are added to your project's 'muppet' directory. You can edit them there.

Once your deploy.rb file is configured, setup your boxes with

    $ muppet setup
    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
