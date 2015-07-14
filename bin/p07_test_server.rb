require 'webrick'
require_relative '../lib/phase6/controller_base'
require_relative '../lib/phase6/router'

cat_holder = []

class Cat
  attr_reader :name, :owner
  def initialize(name, owner)
    @name = name
    @owner = owner
  end
end

class CatsController < Phase6::ControllerBase
  def index
    # flash[:errors] = 'Flash'
    render :index
  end

  def new
    flash.now[:errors] = 'Flash Now'
    render :new
  end
end

router = Phase6::Router.new
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/new$"), CatsController, :new
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
