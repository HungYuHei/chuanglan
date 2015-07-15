require 'net/http'

module Chuanglan
  class Request
    def initialize(url, recipients, message)
      @uri = URI(url)
      @recipients = Array(recipients)
      @message = message
    end

    def perform!
      timeout = Chuanglan.timeout
      response = Net::HTTP.start(@uri.host,
                                 @uri.port,
                                 open_timeout: timeout,
                                 read_timeout: timeout) do |http|
        post_data = URI.encode_www_form(payload)
        http.request_post(@uri.path, post_data)
      end

      success_or_raise_exception(response)
    end

    private

    def payload
      {
        account: Chuanglan.username,
        pswd: Chuanglan.password,
        mobile: @recipients.join(','),
        msg: @message,
        needstatus: 'true',
      }
    end

    def success_or_raise_exception(response)
      headers, msgid= response.body.split("\n")
      timestamp, code = headers.split(',')

      code == '0' || raise(RequestException.new(code))
    end
  end
end
