class Record < ActiveRecord::Base
  
  belongs_to :check
  belongs_to :report
  
  validates_presence_of :check_id
  validates_presence_of :report_id
  validates_presence_of :status
  validates_presence_of :message
  
  protected
    def set_default_values
      self.status = 0 if status.blank?
      self.length = 0 if length.blank?
      self.body = nil if body.blank?
    end
    before_validation :set_default_values
end
