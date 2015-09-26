module Nephos
  module Responder

    class InvalidContentType < StandardError; end

    CT_CHARSET_PREFIX = '; charset='

    def self.content_type(kind, type, charset='UTF-8')
      "#{kind}/#{type}" + CT_CHARSET_PREFIX + charset
    end

    # @param params [Hash] containing :type => "kind/type", example: "text/html"
    def self.ct_specific(params)
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

    private
    # if not :status entry, set to 200
    def self.set_default_params_status params
      params[:status] ||= 200
    end

    def self.set_default_params_type params
      if params[:type].nil?
        params[:type] = PRESET_CT[(params.keys & [:plain, :html, :json]).first || :plain]
      end
      params[:type] = ct_specific(params)
    end

    def self.set_default_params_content params
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
    public

    # Fill params with default parameters (status, plain errors)
    def self.set_default_params params
      set_default_params_status(params)
      set_default_params_type(params)
      set_default_params_content(params)
      params
    end

    # @param controller [Controller]
    # @param method_to_call [Symbol]
    def self.render controller, method_to_call, *opts
      params = controller.send method_to_call
      return [204, ct_specific({type: PRESET_CT[:plain]}), [""]] if params == :empty
      return render(status: params) if params.is_a? Integer
      params = set_default_params(params)
      resp = Rack::Response.new
      resp.status = params[:status]
      resp["Content-Type"] = params[:type]
      resp.body = [params[:content]]
      controller.cookies.each do |k, v|
        resp.set_cookie k, v
      end
      return resp
    end

  end
end
