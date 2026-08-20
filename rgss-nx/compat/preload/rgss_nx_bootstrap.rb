# RGSS-NX bootstrap
# Loaded before the RPG Maker game scripts.

module RGSSNX
  VERSION = "0.2.0-m1"

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

  def self.libretro?
    return false unless defined?(System)
    return System.is_libretro? if System.respond_to?(:is_libretro?)
    System.respond_to?(:platform) && System.platform.to_s == "libretro"
  rescue Exception
    false
  end

  def self.http_available?
    defined?(HTTPLite) && HTTPLite.respond_to?(:get)
  rescue Exception
    false
  end
end

begin
  ENV["RGSS_NX"] = "1"
  ENV["RGSS_NX_VERSION"] = RGSSNX::VERSION
rescue Exception => e
  RGSSNX.log("unable to set environment markers: #{e.class}: #{e.message}")
end

RGSSNX.log("bootstrap=#{RGSSNX::VERSION}")
RGSSNX.log("ruby=#{RUBY_VERSION} platform=#{RUBY_PLATFORM}")
RGSSNX.log("cwd=#{RGSSNX.safe_value { Dir.pwd }}")
RGSSNX.log("libretro=#{RGSSNX.libretro?}")
RGSSNX.log("http_backend=#{RGSSNX.http_available?}")

if defined?(System)
  RGSSNX.log("system.platform=#{RGSSNX.safe_value { System.platform }}") if System.respond_to?(:platform)
  RGSSNX.log("system.data_directory=#{RGSSNX.safe_value { System.data_directory }}") if System.respond_to?(:data_directory)
end
