class Report < ActiveRecord::Base
  
  validates_presence_of :site_id
  validates_presence_of :state
  
  belongs_to :site
  has_many :records, :dependent => :destroy
  
  def Report.now(site)
    r = new(:site => site, :state => Site::STATE_CHECKING)
    r.save
    r
  end
  
  def Report.find_for_user(user, only_mailed = true)
    if only_mailed
      user.reports.find(:all, :conditions => {:mailed => true})
    else
      user.reports
    end
  end
  
  def finish!
    reload
    set_state
    self.mailed = send_mails
    save
  end
  
  def recipients
    self.site.account.notification_recipients
  end
  
  def ok?
    self.state == Site::STATE_OK
  end
  
  def title
    res = ""
    if ok?
      res << "Vše v pořádku: "
    else
      res << "Chyba: "
    end
    res << "#{site.adress} kontrolováno #{created_at.to_formatted_s(:cz_datetime)}"
    res
  end
  
  protected
  
    def set_state
      ok = true
      records.each do |rec|
        ok &&= rec.ok?
      end
      self.state = ok ? Site::STATE_OK : Site::STATE_ERROR
    end
    
    def send_mails
      begin
        if send_error_mail?
          Notifier.deliver_error_notify(self)
          return true
        elsif send_ok_mail?
          Notifier.deliver_fixed_notify(self)
          return true
        else 
          return false
        end 
      rescue Exception => e
        logger.error e
        return true
      end
    end
    
    def send_ok_mail?
      self.site.last_report and
      self.ok? and
      !self.site.last_report.ok?
    end
    
    def send_error_mail?
      !self.ok? and 
      (self.site.last_report.nil? or self.site.last_report.ok?)
    end
    
    before_create :set_default_vals
    def set_default_vals
      self.state = Site::STATE_CHECKING
      self.mailed = false
      true
    end
    
end
