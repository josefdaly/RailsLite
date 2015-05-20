require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
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
  end
end
