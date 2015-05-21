require_relative '../phase4/controller_base'
require_relative './params'
require_relative '../phase8/flash'

module Phase5
  class ControllerBase < Phase4::ControllerBase
    attr_reader :params
    attr_accessor :flash

    # setup the controller
    def initialize(req, res, route_params = {})
      super(req, res)
      @flash = Flash.new(req)
      @params = Params.new(req, route_params)
      session
    end
  end
end
