class Account < ActiveRecord::Base
  
  validates_presence_of :name, :message => "Zadej název účtu."
  validates_uniqueness_of :name, :message => "Jméno účtu už je používáno."
  
  has_many :rights, :dependent => :destroy
  has_many :users, :through => :rights
  
  has_many :sites, :dependent => :destroy
  
  has_many :reports, :through => :sites, :order => "created_at DESC"
  
  attr_protected :rights
  
  USER = 0
  PREMIUM = 1
  ADMIN = 2
  
  def last_report
    reports.first
  end
  
  def notification_recipients
    users.collect { |u| u.email }.join(",")
  end
  
  def sites_with_errors
    sites.find(:all, :conditions => ["state = ? OR state = ?", Site::STATE_ERROR, Site::STATE_NEW])
  end
  
  def sites_without_errors
    sites.find(:all, :conditions => ["state = ? OR state = ?", Site::STATE_OK, Site::STATE_CHECKING])
  end
  protected
    
    before_save :set_default_rights
    def set_default_rights
      self.rights ||= USER
    end
  
end
