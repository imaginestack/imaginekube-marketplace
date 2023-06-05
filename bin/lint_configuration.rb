#!/usr/bin/env ruby

require 'yaml'

exit_code = 0

Dir.glob('**/*.yaml').each do |filename|
  next unless filename[/manifest\.yaml$/]

  begin
    yaml = YAML.load_file(filename)
    yaml["configuration"].each do |k,v|
      if v["value"][/^IMAGINE\:ALPHANUMERIC\(\d+\)(\:BASE64)?/]
        # OK
      elsif v["value"][/^IMAGINE\:WORDS\(\d+\)(\:BASE64)?/]
        # OK
      elsif v["value"][/^IMAGINE\:CLUSTER_NAME/]
        # OK
      elsif v["value"][/^IMAGINE\:CLUSTER_ID/]
        # OK
      elsif v["value"][/^IMAGINE\:EMAIL_ADDRESS/]
        # OK
      elsif v["value"][/^IMAGINE\:MASTER_IP/]
        # OK
      elsif v["value"][/^IMAGINE\:MASTER_IP/]
        # OK
      elsif v["value"][/^IMAGINE\:REGION/]
        # OK
      elsif v["value"][/^IMAGINE\:/]
        puts "#{filename} has a configuration for #{v["value"]} that is invalid"
        exit_code = 1
      end
    end
  rescue
  end
end

exit exit_code
