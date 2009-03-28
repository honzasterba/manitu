require 'digest/sha1'

class User < ActiveRecord::Base
  
  NEW = 1
  CONFIRMED = 2
  BLOCKED = 3
 
  validates_presence_of :email, :message => "Zadej email."
  validates_uniqueness_of :email, :message => 'Email už někdo používá.'
  validates_format_of :email, :message => 'Neplatný email.', :with => Utils::EMAIL_REGEX

  validates_length_of :password, :within => 6..50, 
    :too_short => "Heslo musí mít alespoň 6 znaků.",
    :too_long => "Heslo je moc dlouhé.",
    :if => :confirm_password?,
    :allow_nil => true
  validates_confirmation_of :password, :message => 'Potvzení a zadané heslo se musí shodovat.', 
    :if => :confirm_password?

  attr_protected :state

  has_many :rights, :dependent => :destroy
  has_many :accounts, :through => :rights
  
  has_many :reports, :through => :accounts

  def self.sha1(phrase)
    Digest::SHA1.hexdigest("--hot stuff-- #{phrase} --sweet salt--")
  end
  
  def confirm_password?
    return true if password_confirmation
    return true if new_record?
    return true if User.find(self.id).password != self.password
    return false
  end
  
  def nick
    @nick ||= email[/([^@]+)@.*/, 1]
  end
  
  def confirm!
    self.state = CONFIRMED
    self.token = User.sha1(self.email+rand(1024).to_s)
    save
  end
  
  def send_welcome_mail(url)
    begin
      Notifier.deliver_welcome_mail(self, url)
      return true
    rescue Exception => e
      logger.error e
      return false
    end
  end
  
  def reset_password!
    new_pass = self.password[0..7]
    self.password = new_pass
    self.save
    new_pass
  end  
  
  def clear_passwords
    self.password = nil
    self.password_confirmation = nil
  end
  
  def generate_remember
    self.remember = User.sha1(Time.now.to_s)
    save
    self.remember
  end
  
  def clear_remember
    if self.remember
      self.remember = nil
      save
    end
  end
  
  protected
  
    before_create :assign_state
    def assign_state
      self.state = NEW
    end
  
    before_create :assign_token
    def assign_token
      self.token = User.sha1(self.email)
    end
    
    before_save :create_account_if_none
    def create_account_if_none
      if self.accounts.empty?
        @acc_to_save = Account.new(:name => default_acc_name)
        return @acc_to_save.save
      end
      return true
    end
    
    def default_acc_name
      if Account.find_by_name(self.email)
        name = self.email
        i = 1
        name = nil
        while Account.find_by_name(name = "#{self.email}_#{i.to_s}") do
          # find next
          i += 1
        end
        return name
      else
        return self.email
      end
    end
    
    after_save :assign_rights_to_created_account
    def assign_rights_to_created_account
      if @acc_to_save
        right = Right.new(:account => @acc_to_save, :user => self, :rights => Right::ADMIN)
        @acc_to_save = nil
        return right.save
      end
    end
  
    before_validation_on_update :check_password
    def check_password
      if self.password.blank?
        self.password = nil
        self.password_confirmation = nil
      end
    end
  
    before_create :encrypt_password
    def encrypt_password
      self.password = self.class.sha1(password)
    end
  
    before_update :encrypt_password_unless_empty_or_unchanged
    def encrypt_password_unless_empty_or_unchanged
      user = self.class.find(self.id)
      if self.password.blank?
        self.password = user.password
      elsif self.password != user.password
        encrypt_password
      end
    end  
    
    after_save :clear_pass_confirm
    def clear_pass_confirm
      self.password_confirmation = nil
    end
    
end
