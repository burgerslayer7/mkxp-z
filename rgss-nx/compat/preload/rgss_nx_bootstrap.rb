# RGSS-NX bootstrap/probe
# Copyright (c) RGSS-NX contributors
#
# This preload script is intentionally non-invasive. M0 only records the
# runtime environment so Switch-specific incompatibilities can be fixed from
# evidence rather than guessed patches.

module RGSSNX
  VERSION = "0.1.0-m0"

  def self.safe_value
    yield
  rescue Exception => e
    "<#{e.class}: #{e.message}>"
  end

  def self.log(message)
    line = "[RGSS-NX] #{message}"
    begin
      STDERR.puts(line)
    rescue Exception
      begin
        puts(line)
      rescue Exception
      end
    end
  end
end

RGSSNX.log("bootstrap=#{RGSSNX::VERSION}")
RGSSNX.log("ruby=#{RUBY_VERSION} platform=#{RUBY_PLATFORM}")
RGSSNX.log("cwd=#{RGSSNX.safe_value { Dir.pwd }}")

if defined?(System)
  RGSSNX.log("system.platform=#{RGSSNX.safe_value { System.platform }}")
  if System.respond_to?(:data_directory)
    RGSSNX.log("system.data_directory=#{RGSSNX.safe_value { System.data_directory }}")
  end
  if System.respond_to?(:is_libretro?)
    RGSSNX.log("system.is_libretro=#{RGSSNX.safe_value { System.is_libretro? }}")
  end
else
  RGSSNX.log("System module not available during preload")
end

begin
  ENV["RGSS_NX"] = "1"
rescue Exception => e
  RGSSNX.log("unable to set RGSS_NX env: #{e.class}: #{e.message}")
end
