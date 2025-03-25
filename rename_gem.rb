#!/usr/bin/env ruby

require 'fileutils'

# 源目录和目标目录
SOURCE_DIR = File.expand_path('lib/netsuite', __dir__)
TARGET_DIR = File.expand_path('lib/netsuite_new', __dir__)

# 确保目标目录存在
FileUtils.mkdir_p(TARGET_DIR)

# 递归复制文件并替换内容
def copy_and_replace(source_dir, target_dir)
  Dir.foreach(source_dir) do |entry|
    next if entry == '.' || entry == '..'
    
    source_path = File.join(source_dir, entry)
    target_path = File.join(target_dir, entry)
    
    if File.directory?(source_path)
      FileUtils.mkdir_p(target_path)
      copy_and_replace(source_path, target_path)
    else
      # 只处理 Ruby 文件
      if source_path.end_with?('.rb')
        content = File.read(source_path)
        
        # 替换模块名称
        content = content.gsub(/module NetSuite/, 'module NetSuiteNew')
        content = content.gsub(/NetSuite::/, 'NetSuiteNew::')
        
        # 替换 require 路径
        content = content.gsub(/require ['"]netsuite\//, 'require \'netsuite_new/')
        content = content.gsub(/autoload :(\w+), ['"]netsuite\//, 'autoload :\1, \'netsuite_new/')
        
        # 写入新文件
        File.write(target_path, content)
        puts "Processed: #{target_path}"
      else
        # 直接复制非 Ruby 文件
        FileUtils.cp(source_path, target_path)
        puts "Copied: #{target_path}"
      end
    end
  end
end

# 开始处理
puts "Starting conversion from 'netsuite' to 'netsuite_new'..."
copy_and_replace(SOURCE_DIR, TARGET_DIR)
puts "Conversion completed!"
