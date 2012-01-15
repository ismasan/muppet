require 'sprinkle/script'
require "muppet/version"

module Muppet
  # Your code goes here...
end

require 'muppet/cli'

module Sprinkle
  class Script
    
    def self.parse(filename)
      script = new
      script.instance_eval File.read(filename), filename
      script
    end
    
    def self.policies
      POLICIES
    end
  end
end
