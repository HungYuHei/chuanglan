module Chuanglan
  class International
    GATEWAY = 'https://intapi.253.com'

    class << self
      attr_accessor :username, :password, :timeout, :signature

      def send_to!(recipients, message, params = {})
        params = base_params.merge(params)
        params[:da] = Array(recipients).join(',')
        params[:sm] = "#{params.delete(:signature) || signature}#{message}"
        rsp = Request.new("#{GATEWAY}/mt", params).perform
        success_or_raise_exception(rsp)
      end

      private

      def base_params
        {
          un: username,
          pw: password,
          dc: 15,
          rf: 1,
          tf: 3,
        }
      end

      def success_or_raise_exception(response)
        data = URI.decode_www_form(response.body).to_h
        data['id'] || raise(RequestException.new(data['r']))
      end
    end
  end
end
