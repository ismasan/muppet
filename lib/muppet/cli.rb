require 'thor'
require 'fileutils'
require 'sprinkle'

module Muppet

  class CLI < Thor

    MUPPET_REPO = 'git@github.com:cloud8421/muppet-central.git'

    include Thor::Actions

    source_root File.dirname(__FILE__)

    default_task :help

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
      invoke :copy_deploy_rb, [app_name]
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
      helper_file = File.join(app_name, 'muppet', 'recipe_helper.rb')
      FileUtils.cp(File.join(repo_dir, 'recipe_helper.rb'), helper_file) unless File.exists?(helper_file)
      defaults app_name, 'policies', %w(utils.rb)
    end

    desc 'configurations', 'Create default configurations'
    def configurations(app_name)
      defaults app_name, 'conf', %w(vim)
    end

    desc 'clone_repo', 'Clone central muppet repo'
    def clone_repo(*args)
      if Dir.exists?(repo_dir)
        say %(Muppet policies repository already cloned into #{repo_dir})
      else
        say "Cloning muppet policies repo", :yellow
        empty_directory muppet_central
        `git clone #{MUPPET_REPO} #{repo_dir}`
        say %(Muppet policies repository cloned into #{repo_dir}), :green
      end
    end

    desc 'update', 'Update repo'
    def update(*args)
      puts `cd #{repo_dir} && git pull`
    end

    desc 'list', 'List all available policies in policies repo'
    def list(*args)
      Dir["#{repo_dir}/policies/*.rb"].each do |file|
        Sprinkle::Script.parse file
      end
      added_policies, other_policies = [], []
      Sprinkle::Script.policies.each do |policy|
        if File.exists?("./muppet/policies/#{policy.name}.rb")
          added_policies << policy
        else
          other_policies << policy
        end
      end
      
      puts ''
      if added_policies.any?
        say "Current policies", :magenta
        added_policies.each do |policy|
          say "  #{policy.name}", :green
        end
      end
      
      say "Available policies", :magenta
      other_policies.each do |policy|
        say "  #{policy.name}", :yellow
      end
      puts ''
      say "Add policies with muppet add [policy name]"
      puts ''
    end
    
    desc 'add', 'Use a policy in your app'
    def add(policy_name)
      in_app!
      Sprinkle::Script.parse(File.join(repo_dir, 'policies', "#{policy_name}.rb"))
      policy = Sprinkle::Script.policies.first
      say "adding packages..."
      copy_packages policy.packages
      
      conf_dir = File.join(repo_dir, 'conf', policy_name)
      if File.exists?(conf_dir)
        FileUtils.cp_r conf_dir, './muppet/conf/'
      end
      
      FileUtils.cp File.join(repo_dir, 'policies', "#{policy_name}.rb"), './muppet/policies'
      say "Policy #{policy_name} added to local project", :yellow
    end

    desc 'copy_deploy_rb', 'Copy deploy.rb default template'
    def copy_deploy_rb(app_name)
      @app_name = app_name
      server_ip = ask("Enter your remote box's IP (or leave blank):", :yellow).chomp
      @server_ip = server_ip == '' ? '[SERVER_IP]' : server_ip
      template 'templates/deploy.rb.tt', File.join(app_name, 'deploy.rb')
    end

    desc 'setup', 'Setup remote box using provided policies'
    def setup(*args)
      in_app!
      Dir["./muppet/policies/*.rb"].each do |file|
        Sprinkle::Script.sprinkle File.read(file), file
      end
    end

    protected
    
    def copy_packages(packages)
      packages.each do |pack|
        pack_path = File.join(repo_dir, 'packages', "#{pack}.rb")
        target_path = "./muppet/packages/#{pack}.rb"
        FileUtils.cp(pack_path, target_path) if (File.exists?(pack_path) && !File.exists?(target_path))
      end
    end
    
    def in_app!
      File.exists?('./muppet') or raise "Not in a muppet app! Create one with muppet init app_name or cd into it"
    end

    def defaults(app_name, folder_name, defaults)
      empty_directory File.join(app_name, 'muppet', folder_name)
      defaults.each do |pack|
        FileUtils.cp_r File.join(repo_dir, folder_name, pack), File.join(app_name, 'muppet', folder_name, pack)
      end
      say "Copied default #{folder_name} into #{File.join(app_name, folder_name)}", :green
    end

    def muppet_central
      @muppet_central ||= File.join(ENV['HOME'], '.muppet')
    end

    def repo_dir
      File.join(muppet_central, 'repo')
    end
    
    def copy_absolute_file(source, destination)
      create_file destination, nil, config do
        content = File.binread(source)
        content = block.call(content) if block
        content
      end
    end

  end

end
