require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './params'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params
  attr_accessor :flash

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @flash = Flash.new(req)
    @params = Params.new(req, route_params)
    session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name.to_sym)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response ||= false
  end

  # Set the response status code and header
  def redirect_to(url)
    raise Exception if already_built_response?
    @already_built_response = true
    @res.header["location"] = url
    @res.status = 302
    @session.store_session(@res)
    @flash.store_flash(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    raise Exception if already_built_response?
    cn = self.class.to_s
    controller_name = cn[0..cn.length-11].downcase
    template = File.read(
      "./views/#{controller_name}_controller/#{template_name}.html.erb"
    )

    evaluated_content = ERB.new(template).result(binding)

    render_content(evaluated_content, "text/html")
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise Exception if already_built_response?
    @res.content_type = content_type
    @res.body = content
    @already_built_response = true
    @session.store_session(@res)
    @flash.store_flash(@res)
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end
end
