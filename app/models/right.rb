class Right < ActiveRecord::Base
  
    validates_presence_of :user_id, :message => "Nebyl zadán uživatel."
    validates_presence_of :account_id, :message => "Nebyl zadán účet."
    
    validates_uniqueness_of :user_id, :scope => "account_id", :message => "Duplicitní práva."
    
    belongs_to :account
    belongs_to :user
    
    READ = 0
    WRITE = 1
    ADMIN = 2
    
    protected
    
      before_save :default_rights
      def default_rights
        self.rights ||= READ
      end
      
      after_destroy :destroy_account_if_empty
      def destroy_account_if_empty
        acc = self.account
        if acc.rights(true).empty?
          acc.destroy
        end
      end
    
end
