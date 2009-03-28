class Site < ActiveRecord::Base
  
  STATE_NEW = "new"
  STATE_CHECKING = "checking"
  STATE_OK = "ok"
  STATE_ERROR = "error"
  
  attr_protected :state, :account_id
  
  validates_presence_of :account_id, :message => "Systémová chyba."
  validates_presence_of :adress, :message => "Zadej adresu."
  
  validates_format_of :adress, :with => Utils::HTTP_ONLY_REGEX,
    :message => "Zadal jsi neplatnou adresu."
  validates_uniqueness_of :adress, :scope => :account_id,
    :message => "Zadal jsi duplicitní adresu."
  
  belongs_to :account
  has_many :checks, :dependent => :destroy
  has_many :reports, :order => "created_at DESC"

  def self.find_for_checking
    cond_str = "state != ? AND (last_checked < ? OR last_checked is NULL) AND updated_at < ?"
    locked = false
    item = nil
    begin
      connection.execute("LOCK TABLES sites WRITE;")
      locked = true
      item = find(:first, :conditions => [cond_str, Site::STATE_NEW, 5.minutes.ago, 5.minutes.ago], :order => "last_checked ASC")
      if item            
        item.state = Site::STATE_CHECKING
        item.save!
      end
      return item
    rescue Exception => e
      logger.error "Unable to fetch a site for checking."
      logger.error e
    ensure
      connection.execute("UNLOCK TABLES;") if locked
    end
  end
  
  def system_check
    @system_check ||= checks.find(:first, :conditions => {:system => true})
  end
  
  def user_checks
    @user_checks ||= checks.find(:all, :conditions => {:system => false})
  end
  
  def last_report
    @last_report ||= reports.find(:first, :conditions => ["state != ?", STATE_CHECKING])
  end
  
  def confirm_uri
    @confirm_uri ||= adress + "manitu" + sprintf("%03x", self.id) + "m" + sprintf("%03x", self.account.id) + ".html"
  end
  
  def reload
    @system_check, @user_checks, @last_report, @confirm_uri = nil, nil, nil, nil
    super
  end
  
  protected
  
    def set_default_state
      self.state = STATE_NEW if state.blank?
    end
    before_save :set_default_state
    
    def append_slash
      if adress[adress.length-1, 1] != "/"
        self.adress += "/"
      end
    end
    before_save :append_slash
    
    def create_default_root_check
      c = Check.new(:path => "/", :site_id => self.id, :system => true)
      c.save!
    end
    after_create :create_default_root_check
  
end
