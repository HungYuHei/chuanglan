require 'chuanglan/version'
require 'chuanglan/international'
require 'chuanglan/request'
require 'chuanglan/request_exception'

module Chuanglan
  GATEWAY = 'https://sms.253.com'
  @timeout = 5

  class << self
    attr_accessor :username, :password, :timeout, :signature

    def send_to!(recipients, message, params = {})
      params = base_params.merge(params)
      params[:phone] = Array(recipients).join(',')
      params[:msg] = "#{params.fetch(:signature, signature)}#{message}"
      rsp = Request.new("#{GATEWAY}/msg/send", params).perform
      success_or_raise_exception(rsp)
    end

    def balance
      rsp = Request.new("#{GATEWAY}/msg/balance", un: username, pw: password).perform
      success_or_raise_exception(rsp).to_i
    end

    private

    def base_params
      {
        un: username,
        pw: password,
        rd: 1,
      }
    end

    def success_or_raise_exception(response)
      headers, data   = response.body.split("\n")
      timestamp, code = headers.split(',')
      code == '0' ? data : raise(RequestException.new(code))
    end
  end
end
