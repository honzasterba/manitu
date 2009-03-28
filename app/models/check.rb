class Check < ActiveRecord::Base
  
  validates_presence_of :path, :message => "Zadej cestu ke kotrole."
  validates_uniqueness_of :path, :scope => "site_id",
    :message => "Nadefinoval jsi duplicitní kontrolu."
  
  belongs_to :site
  has_many :records, :dependent => :destroy, 
     :order => "created_at DESC"
  
  def last_record
    @last_record ||= records.first
  end
  
  def uri
    return site.adress if self.system?
    return site.adress + path
  end
  
  protected
    def validate_path
      return if errors.on(:path)
      errors.add(:path, "Validaci kořene (/) provádí sytém.") if self.path.strip == "/"
      begin
        URI.parse(path)
      rescue URI::InvalidURIError
        errors.add(:path, "Neplatná URI cesta.")
      end
    end
    after_validation :validate_path
  
end
