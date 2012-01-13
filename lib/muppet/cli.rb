require 'thor'
require 'fileutils'
module Muppet
  
  class CLI < Thor
    
    MUPPET_REPO = 'git@github.com:cloud8421/Sprinkle-provisioning-scripts'
    
    include Thor::Actions
    
    desc "init", "Clone the Muppet policies repository into this environment"
    def init(app_name)
      # create directory if doesn't exist
      invoke :app_dir, [app_name]
      # clone central repo if not exists
      invoke :clone_repo
      # create ./muppet/packages if not exist
      invoke :packages, [app_name]
      # create ./muppet/policies if not exist
      invoke :policies, [app_name]
      # create ./muppet/conf if not exist
      invoke :configurations, [app_name]
      # create deploy.rb if not exist
    end
    
    desc 'app_dir', 'Create app directory'
    def app_dir(app_name)
      empty_directory app_name
    end
    
    desc 'packages', 'Create default packages'
    def packages(app_name)
      defaults app_name, 'packages', %w(build_essential.rb git.rb wget.rb tree.rb vim.rb)
    end
    
    desc 'policies', 'Create default policies'
    def policies(app_name)
      defaults app_name, 'policies', %w(utils.rb)
    end
    
    desc 'configurations', 'Create default configurations'
    def configurations(app_name)
      defaults app_name, 'conf', %w(vimrc)
    end
    
    desc 'clone_repo', 'Clone central muppet repo'
    def clone_repo(*args)
      empty_directory muppet_central
      `git clone #{MUPPET_REPO} #{repo_dir}` unless Dir.exists?(repo_dir)
      say %(Central policies repository cloned into #{repo_dir}), :green
    end
    
    protected

    def defaults(app_name, folder_name, defaults)
      empty_directory File.join(app_name, 'muppet', folder_name)
      defaults.each do |pack|        
        FileUtils.cp File.join(repo_dir, folder_name, pack), File.join(app_name, 'muppet', folder_name, pack)
      end
      say "Copied default #{folder_name} into #{File.join(app_name, folder_name)}", :green
    end
    
    def muppet_central
      @muppet_central ||= File.join(ENV['HOME'], '.muppet')
    end
    
    def repo_dir
      File.join(muppet_central, 'repo')
    end
  end
  
end