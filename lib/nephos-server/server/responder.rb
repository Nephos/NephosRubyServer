module Nephos
  module Responder

    CT_CHARSET_ = '; charset=UTF-8'
    CT_TP = {'Content-type' => 'text/plain' + CT_CHARSET_}
    CT_TJ = {'Content-type' => 'text/javascript' + CT_CHARSET_}
    CT_TH = {'Content-type' => 'text/html' + CT_CHARSET_}
    def self.render params
      if params == :empty
        return [204, CT_TP, [""]]
      elsif params[:status] == 404
        return [404, CT_TP, ['Error 404 : Not found !']]
      elsif params[:status] == 500
        return [500, CT_TP, ['Error 5OO : Internal Server Error !']]
      elsif params[:status].is_a? Fixnum
        return [params[:status], CT_TP, ["Error #{params[:status]}"]]
      elsif params[:json]
        return [200, CT_TJ, [params[:json].to_json]]
      elsif params[:plain]
        return [200, CT_TJ, [params[:plain].to_s]]
      else
        render(:empty)
      end
    end

  end
end
