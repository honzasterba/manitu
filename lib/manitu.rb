module Manitu
  
  def Manitu.daemon
    log.info "Manitu: Running daemon."
    while (site = Site.find_for_checking)
      check_site(site)
    end
    log.info "Manitu: Done."
  end
  
  def Manitu.check_site(site)
    checker = Checker.new(site)
    begin
      checker.run
    rescue Exception => e
      log.error "Manitu: Error checking site"
      log.error e
    ensure
      if site.state == Site::STATE_CHECKING
        site.state = Site::STATE_ERROR
        site.save
      end
    end
  end
  
  def Manitu.confirm_site(site)
    Confirmer.new(site).run
  end
  
  def Manitu.log
    if @logger.nil?
      @logger = Logger.new(logger_file, 1, 1000000)
      @logger.level = Logger::DEBUG
    end
    @logger
  end
  
  def Manitu.logger_file
    env = ENV['RAILS_ENV'][0,4]
    RAILS_ROOT+"/log/daemon_#{env}.log"
  end
  
end
