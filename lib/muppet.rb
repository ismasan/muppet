require "muppet/version"

module Muppet
  # Your code goes here...
end

require 'muppet/cli'

module Sprinkle
  class Script
    def self.parse(script, filename = '__SCRIPT__')
      powder = new
      powder.instance_eval script, filename
      powder
    end
    def self.policies
      POLICIES
    end
  end
end
