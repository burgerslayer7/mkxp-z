# RGSS-NX postload compatibility layer
# Loaded after the game's scripts and before rgss_main.

unless defined?(RGSSNX)
  module RGSSNX
    VERSION = "0.2.0-m1"
    def self.log(message)
      begin
        STDERR.puts("[RGSS-NX] #{message}")
      rescue Exception
      end
    end
    def self.http_available?
      defined?(HTTPLite) && HTTPLite.respond_to?(:get)
    rescue Exception
      false
    end
  end
end

module RGSSNX
  def self.detect_profile
    if defined?(Settings)
      begin
        if Settings.const_defined?(:CUSTOM_FUSIONS_SPRITESHEET_TRUE_SIZE_URL) ||
           Settings.const_defined?(:LATEST_GAME_RELEASE)
          return "infinite-fusion-2"
        end
      rescue Exception
      end
    end
    return "pokemon-essentials" if defined?(PokemonSystem) || defined?(GameData)
    "generic-rgss"
  end
end

RGSSNX.log("postload profile=#{RGSSNX.detect_profile} http_backend=#{RGSSNX.http_available?}")

# Horizon cannot hand a URL to xdg-open/open/start. Fangames should keep
# running instead of spawning a process that does not exist on libnx.
if Object.private_method_defined?(:openUrlInBrowser) || Object.method_defined?(:openUrlInBrowser)
  Object.send(:define_method, :openUrlInBrowser) do |url = ""
    RGSSNX.log("browser request ignored on Horizon: #{url}")
    false
  end
  Object.send(:private, :openUrlInBrowser)
end

# Infinite Fusion/Essentials gates sprite and data downloads behind this method.
# If this mkxp-z build exposes no HTTPLite backend, force clean offline mode.
# When HTTPLite exists, preserve the game's own user setting and behavior.
if Object.private_method_defined?(:downloadAllowed?) || Object.method_defined?(:downloadAllowed?)
  original_download_allowed = Object.instance_method(:downloadAllowed?)
  Object.send(:define_method, :downloadAllowed?) do
    next false unless RGSSNX.http_available?
    begin
      original_download_allowed.bind(self).call
    rescue Exception => e
      RGSSNX.log("downloadAllowed? fallback: #{e.class}: #{e.message}")
      false
    end
  end
  Object.send(:private, :downloadAllowed?)
end

# Network-only PIF helpers that are not always protected by downloadAllowed?.
# Keep them inert only when the runtime genuinely has no HTTP implementation.
unless RGSSNX.http_available?
  if Object.private_method_defined?(:pbPostData) || Object.method_defined?(:pbPostData)
    Object.send(:define_method, :pbPostData) { |_url, _postdata, _filename = nil, _depth = 0| "" }
    Object.send(:private, :pbPostData)
  end
  if Object.private_method_defined?(:pbDownloadData) || Object.method_defined?(:pbDownloadData)
    Object.send(:define_method, :pbDownloadData) { |_url, _filename = nil, _authorization = nil, _depth = 0, &_block| nil }
    Object.send(:private, :pbDownloadData)
  end
end
