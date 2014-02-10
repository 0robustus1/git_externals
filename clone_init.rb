#! /usr/bin/env ruby

require 'pathname'

module GitAutoAbilites

  CONFIG_FILE = File.expand_path("~/.gitconfs/users")

  class << self

    def is_south_of?(path, possible_parent)
      path = File.absolute_path(path)
      possible_parent = File.absolute_path(File.expand_path(possible_parent))
      !! (path =~ /^#{possible_parent}/)
    end

    def find_users
      users = parse_config(CONFIG_FILE)
    end

    def parse_config(config_file)
      config = Hash.new {}
      current_parent = nil
      File.open(config_file) do |file|
        file.each_line do |line|
          if line.match %r{^\s*\[\s*([/\w~]+)\s*\]\s*}
            current_parent = $1.strip
            config[current_parent] = {}
          elsif line.match /^\s*(\w+)\s*=\s*([\w\s@.-]+)/
            key, value = $1.strip, $2.strip
            config[current_parent][key] = value
          end
        end
      end
      config
    end

    def user_config
      users = find_users
      path = `pwd`.strip
      user_path = users.keys.reduce(nil) do |user, key|
        is_south_of?(path, key) ? key : user
      end
      infos = users[user_path] || {}
    end

  end

  class Init
    attr_reader :config

    def perform(config)
      @config = config
      system("git init #{ARGV.join(' ')}")
      conf_commands.each { |cmd| system(cmd) }
    end

    def dir
      ARGV.last
    end

    def git_dir
      if has_separate_git_dir?
        Pathname.new(separate_git_dir)
      elsif is_bare?
        Pathname.new(dir)
      else
        Pathname.new(dir).join('.git')
      end
    end

    def is_bare?
      ARGV.include?('--bare')
    end

    def has_separate_git_dir?
      ARGV.each do |opt|
        if opt =~ /--separate-git-dir=(.+)/
          @separate_git_dir = $1
          return true
        end
      end
      false
    end

    def separate_git_dir
      has_separate_git_dir? if @separate_git_dir.nil?
      @separate_git_dir
    end

    def conf_commands
      config.map do |key, value|
        "git config -f #{git_dir.join('config')} user.#{key} \"#{value}\""
      end
    end
  end

  class Clone
    def perform(config)
      options = option_switches(config) + ARGV
      cmd = "git clone #{options.join(' ')}"
      exec cmd
    end

    def option_switches(config)
      config.map { |key, value| "--config user.#{key}=\"#{value}\"" }
    end

  end

end

program_name = $0
prefix = 'rr'
if program_name =~ /#{prefix}-init/
  GitAutoAbilites::Init.new.perform(GitAutoAbilites.user_config)
elsif program_name =~ /#{prefix}-clone/
  GitAutoAbilites::Clone.new.perform(GitAutoAbilites.user_config)
else
  puts 'Can\'t handle this.'
  exit 1
end
