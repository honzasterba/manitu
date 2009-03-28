class Manitu::Confirmer
  include Manitu::Common
  
  def initialize(site)
    @site = site
  end
  
  def run(*args)
    confirm(args)
  end

  def confirm(short = false)
    log.debug "#{@site.adress}: Confirmer: Confirmation check on #{@site.adress}."
    uri = @site.confirm_uri
    begin
      response = get_uri(uri)
    rescue Exception => e
      return "Nedostupné: (#{e.message})."
    end
    case response
      when Net::HTTPSuccess
        @site.state = Site::STATE_CHECKING
        @site.save!
        return nil
      else
        return "#{describe_response_short(response)}." if short
        return "#{describe_response(response)}."
    end
  end  
  
end