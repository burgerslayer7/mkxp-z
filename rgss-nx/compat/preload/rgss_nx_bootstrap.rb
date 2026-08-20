# RGSS-NX compatibility bootstrap.
# Loaded before the RPG Maker game scripts by the dedicated Switch frontend.

module RGSSNX
  VERSION = "0.2.1-m1"

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

  # Top-level methods in RPG Maker scripts are private Object instance methods.
  # Prepending this module before the game scripts keeps these Horizon-specific
  # behaviors ahead of methods the game defines later, while `super` still lets
  # the original game implementation run when the capability exists.
  module ObjectCompat
    def openUrlInBrowser(url = "")
      RGSSNX.log("browser request ignored on Horizon: #{url}")
      false
    end

    def downloadAllowed?(*args, &block)
      return false unless RGSSNX.http_available?
      super
    rescue NoMethodError
      false
    rescue Exception => e
      RGSSNX.log("downloadAllowed? fallback: #{e.class}: #{e.message}")
      false
    end

    def pbPostData(*args, &block)
      return "" unless RGSSNX.http_available?
      super
    rescue NoMethodError
      ""
    rescue Exception => e
      RGSSNX.log("pbPostData fallback: #{e.class}: #{e.message}")
      ""
    end

    def pbDownloadData(*args, &block)
      return nil unless RGSSNX.http_available?
      super
    rescue NoMethodError
      nil
    rescue Exception => e
      RGSSNX.log("pbDownloadData fallback: #{e.class}: #{e.message}")
      nil
    end

    private :openUrlInBrowser, :downloadAllowed?, :pbPostData, :pbDownloadData
  end
end

Object.prepend(RGSSNX::ObjectCompat) unless Object.ancestors.include?(RGSSNX::ObjectCompat)

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
