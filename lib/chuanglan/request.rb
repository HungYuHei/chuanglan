require 'net/http'

module Chuanglan
  class Request
    def initialize(url, recipients, message)
      @uri = URI(url)
      @recipients = Array(recipients)
      @message = message
    end

    def perform!(is_promote = false)
      timeout = Chuanglan.timeout
      response = Net::HTTP.start(@uri.host,
                                 @uri.port,
                                 open_timeout: timeout,
                                 read_timeout: timeout) do |http|
        post_data = URI.encode_www_form(is_promote ? promote_payload : payload)
        http.request_post(@uri.path, post_data)
      end

      success_or_raise_exception(response)
    end

    private

    def promote_payload
      {
        account: Chuanglan.promote_username,
        pswd: Chuanglan.promote_password,
        mobile: @recipients.join(','),
        msg: @message,
        needstatus: 'true',
      }
    end

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
