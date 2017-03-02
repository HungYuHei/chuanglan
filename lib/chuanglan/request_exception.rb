module Chuanglan
  class RequestException < StandardError
    ERROR_MESSAGES = {
      '100' => 'Bad API Address',
      '101' => 'No such user',   # Not officially documented
      '102' => 'Wrong password',
      '103' => 'Push too hurry',
      '104' => 'System is busy',
      '105' => 'Sensitive message',
      '106' => 'Message is too long',
      '107' => 'Wrong mobile',
      '108' => 'Wrong quantity of mobile numbers',
      '109' => 'Out of quota',
      '110' => 'Not within avalidable period for sending',
      '111' => 'Out of monthly limitation',
      '112' => 'No such product',
      '113' => 'Wrong format of extno',
      '115' => 'Denied by auto audit',
      '116' => 'Invalid signature',
      '117' => 'Wrong IP',
      '118' => 'Have no related right as to this user',
      '119' => 'Have been expired',
    }

    def initialize(code)
      super(ERROR_MESSAGES[code] || code)
    end
  end
end
