class Manitu::Checker
  include Manitu::Common

  def initialize(site)
    log.debug "#{site.adress}: Checker for site #{site.id} created."
    @site = site
    @report = Report.now(site)
  end
  
  def run
    log.info "#{@site.adress}: Checker: Running all checks."
    if system_check.ok?
      log.debug "#{@site.adress}: Checker: System check ok, running user checks."
      ok = user_checks
    else
      log.debug "#{@site.adress}: Checker: System check failed!"
      ok = false
    end
    if ok
      @site.state = Site::STATE_OK
    else
      @site.state = Site::STATE_ERROR
    end
    @report.finish!
    @site.last_checked = DateTime.now
    @site.save!
  end
  
  def system_check
    check = @site.system_check
    log.info "#{@site.adress}: Checker: system check on #{@site.adress}."
    record = create_record(check)
    not_confimed_reason = Manitu::Confirmer.new(@site).run(true)
    if not_confimed_reason
      record.ok = false
      record.message = not_confimed_reason
      record.status = 0
      record.save!
    elsif check.active?
      run_check(check, record)
    else
      record.ok = true
      record.message = "Ověřeno"
      record.status = 0
      record.save!
    end
    log.debug "#{@site.adress}: Checker: completed with result: #{record.ok?}."
    return record
  end
  
  def user_checks
    list = @site.user_checks
    log.info "#{@site.adress}: Checker: running #{list.size} user checks."
    all_ok = true
    list.each do |check|
      rec = create_record(check)
      if check.active?
        run_check(check, rec)
        all_ok = all_ok and rec.ok?
      end
    end
    return all_ok
  end
  
  def run_check(check, record)
    return if !check.active?
    log.debug "#{@site.adress}: Checker: checking #{check.uri}."
    begin
      result = get_uri(check.uri)
      set_record_values_from_response(record, result)
      record.save!
      return record
    rescue Timeout::Error => e
      record.ok = false
      record.message = "Server nedpovídá."
      record.save!      
    rescue Exception => e
      record.ok = false
      record.message = "Adresa nedostupná (#{e.message})."
      record.save!
      return record
    end
  end
  
end