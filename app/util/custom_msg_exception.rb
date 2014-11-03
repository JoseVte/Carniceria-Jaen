class CustomMsgException < StandardError
  attr :msg,:status
  def initialize(status,msg)
    @msg = msg
    @status = status
  end

  def message
    @msg
  end

  def status
    @status
  end
end