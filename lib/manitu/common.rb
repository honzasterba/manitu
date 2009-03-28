require 'net/http'
require 'timeout'

module Manitu::Common
  
  def describe_response(response)
    desc = "HTTP/#{describe_response_short(response)}"
    if !response.message.blank?
      desc << " (#{response.message})"
    end
    return desc
  end
  
  def describe_response_short(response)
    desc = "#{response.code}: "
    case response
      when Net::HTTPSuccess
        desc << "Úspěch"
      when Net::HTTPRedirection
        desc << "Přesměřování"
      when Net::HTTPInformation
        desc << "Informace"
      when Net::HTTPClientError
        desc << "Chyba dotazu/Nenalezeno"
      when Net::HTTPServerError
        desc << "Chyba serveru"
      else
        desc << "Neznámá odpověď"
    end
    return desc
  end
  
  def create_record(check)
    r = Record.new(:check => check, :report => @report)
    return r
  end
  
  def set_record_values_from_response(record, response)
    record.status = response.code
    record.message = describe_response_short(response)
    case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        record.length = response.content_length
        # record.body = response.body
        record.ok = true
      else
        record.ok = false
    end
  end

  def get_uri(uri, limit = 25)
    log.debug "#{@site.adress}: fetching #{uri}"
    res = nil
    Timeout::timeout(limit) do
      res = Net::HTTP.get_response(URI.parse(uri))  
    end
    log.debug "#{@site.adress}: got #{res} for #{uri}."
    res
  end
  
  def log
    Manitu.log
  end
  
end