module Nephos

  class Responder

    class InvalidContentType < StandardError; end

    CT_CHARSET_PREFIX = '; charset='

    def content_type(kind, type, charset='UTF-8')
      "#{kind}/#{type}" + CT_CHARSET_PREFIX + charset
    end

    # @param params [Hash] containing :type => "kind/type", example: "text/html"
    def ct_specific(params)
      kind, type = params[:type].to_s.match(/^(\w+)\/(\w+)$/) && Regexp.last_match[1..2]
      if kind.nil? or type.nil?
        raise InvalidContentType, "params[:type] must match with \"kind/type\""
      end
      content_type(kind, type)
    end

    PRESET_CT = {
      plain: "text/plain",
      html: "text/html",
      json: "application/json",
    }

    # if not :status entry, set to 200
    def set_default_params_status params
      params[:status] ||= 200
    end

    def set_default_params_type params
      if params[:type].nil?
        params[:type] = PRESET_CT[(params.keys & [:plain, :html, :json]).first || :plain]
      end
      params[:type] = ct_specific(params)
    end

    def set_default_params_content params
      type = (params.keys & [:plain, :html, :json, :content]).first
      if type.nil?
        if params[:status].to_s.match(/^[45]\d\d$/)
          params[:content] = "Error: #{params[:status]} code"
        elsif params[:status].to_s.match(/^[3]\d\d$/)
          params[:content] = "Redirected: #{params[:status]} code"
        else
          params[:content] = "Status: #{params[:status]} code"
        end
      else
        params[type] = params[type].to_json if type == :json
        params[:content] = params[type]
      end
    end

    # Fill params with default parameters (status, plain errors)
    def set_default_params params
      set_default_params_status(params)
      set_default_params_type(params)
      set_default_params_content(params)
      return params
    end

    def empty_resp
      resp = Rack::Response.new
      resp.status = 204
      resp["Content-Type"] = ct_specific({type: PRESET_CT[:plain]})
      return resp
    end

    def render_from_controller req, call
      controller = Module.const_get(call[:controller]).new(req, call)
      method_to_call = call[:method]

      controller.execute_before_action(method_to_call)
      # puts "Call #{controller} # #{method_to_call}"
      params = controller.send(method_to_call)
      controller.execute_after_action(method_to_call)

      # puts "--- Params #{params.class} ---", "<<", params, ">>"
      resp = render(params)
      controller.cookies.each do |k, v|
        resp.set_cookie k, v
      end
      controller.alterate_header(resp, call[:method])
      return resp
    end

    def render params
      return empty_resp if params == :empty
      return render(status: params) if params.is_a? Integer
      raise "Not a valid params argument" unless params.is_a? Hash

      resp = Rack::Response.new
      params = set_default_params(params)
      resp.status = params[:status]
      resp["Content-Type"] = params[:type]
      resp.body = [params[:content]]
      return resp
    end

  end

end
