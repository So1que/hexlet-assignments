# frozen_string_literal: true

require 'forwardable'
require 'uri'

# BEGIN
class Url
  include Comparable
  extend Forwardable

  def_delegators :@uri, :scheme, :host, :port

  def initialize(url)
    @uri = URI(url)
    parse_query_params
  end

  def query_params
    @query_params
  end

  def query_param(key, default = nil)
    @query_params[key] || default
  end

  def <=>(other)
    return nil unless other.is_a?(Url)
    
    [scheme, host, port, query_params] <=> [other.scheme, other.host, other.port, other.query_params]
  end

  private

  def parse_query_params
    @query_params = {}
    return @query_params if @uri.query.nil?

    @uri.query.split('&').each do |param|
      key, value = param.split('=')
      @query_params[key.to_sym] = value
    end
    
    @query_params
  end
end
# END
