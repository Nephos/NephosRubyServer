module Nephos
  module Responder

    class InvalidContentType < StandardError; end

    CT_CHARSET_PREFIX = '; charset='

    def self.content_type(kind, type, charset='UTF-8')
      {'Content-type' => "#{kind}/#{type}" + CT_CHARSET_PREFIX + charset}
    end
    def self.ct_plain
      content_type(:text, :plain)
    end
    def self.ct_html
      content_type(:text, :html)
    end
    def self.ct_json
      content_type(:text, :javascript)
    end
    # @param params [Hash] containing :type => "kind/type", example: "text/html"
    def self.ct_specific(params)
      kind, type = params[:type].match(/^(\w+)\/(\w+)$/)[1..2]
      if kind.nil? or type.nil?
        raise InvalidContentType, "params[:type] must match with \"kind/type\""
      end
      content_type(kind, type)
    end

    # Fill params with default parameters (status, plain errors)
    def self.set_default_params params
      if (params.keys & [:status]).empty?
        params[:status] ||= 200
      end
      if (params.keys & [:plain, :html, :json, :type]).empty?
        if params[:status].to_s.match(/^[345]\d\d$/)
          params[:plain] ||= "Error: #{params[:status]} code"
        else
          params[:plain] ||= "ok"
        end
      end
      params
    end

    # @return [Symbol, nil] :plain, :html, :json, or nil
    # search the content type
    def self.params_content_type params
      (params.keys & [:plain, :html, :json]).first
    end

    # search the content to render from the params,
    # based on content_type (plain, html, ...).
    # If not, check for specific type
    def self.params_content_type_value params
      type = params_content_type(params)
      if type
        self.send("ct_#{type}")
      else
        self.send("ct_specific", params)
      end
    end

    # @param params [Hash, Symbol]
    def self.render params
      return [204, plain(), [""]] if params == :empty
      params = set_default_params(params)
      return [
        params[:status],
        params_content_type_value(params),
        [params[params_content_type(params) || :content]],
      ]
    end

  end
end
