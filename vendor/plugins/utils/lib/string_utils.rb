module StringUtils
  
  CzLetters = "ĚěÉéŘřŽžÚúŮůÍíÓóÁáŠšĎďÝýČčŇň"
  EnLetters = "eeeerrzzuuuuiiooaassddyyccnn"
  
  def self.slugerize(str)
      str.to_s.strip.tr(CzLetters, EnLetters).downcase.gsub(/[\s\.:_]+/, '-').gsub(/[^-a-z0-9~;+=_]/, '')
  end

end

class String
  def slugerize
    StringUtils.slugerize(self)
  end
end
