module Nephos
  module Responder

    CT_CHARSET_PREFIX = '; charset='

    def self.content_type(kind, type, charset='UTF-8')
      {'Content-type' => "#{kind}/#{type}" + CT_CHARSET_PREFIX + charset}
    end

    def self.plain
      content_type(:text, :plain)
    end
    def self.html
      content_type(:text, :html)
    end
    def self.json
      content_type(:text, :javascript)
    end

    def self.set_default_params params
      if (params.keys & [:status]).empty?
        params[:status] ||= 200
      end
      if (params.keys & [:plain, :html, :json]).empty?
        if params[:status].to_s.match(/^[345]\d\d$/)
          params[:plain] ||= "Error: #{params[:status]} code"
        else
          params[:plain] ||= "ok"
        end
      end
      params
    end

    def self.params_content_type params
      (params.keys & [:plain, :html, :json]).first
    end

    def self.params_content_type_value params
      self.send(params_content_type(params))
    end

    # @param params [Hash, Symbol]
    def self.render params
      return [204, plain(), [""]] if params == :empty
      params = set_default_params(params)
      return [
        params[:status],
        params_content_type_value(params),
        [params[params_content_type(params)]],
      ]
    end

  end
end
