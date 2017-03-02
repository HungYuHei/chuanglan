require 'net/http'

module Chuanglan
  class Request

    def initialize(url, params)
      @uri = URI(url)
      @params = params
    end

    def perform
      timeout = Chuanglan.timeout
      Net::HTTP.start(@uri.host, @uri.port, open_timeout: timeout, read_timeout: timeout) do |http|
        post_data = URI.encode_www_form(@params)
        http.request_post(@uri.path, post_data)
      end
    end
  end
end
