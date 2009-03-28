class Manitu::UsersController < Manitu::BaseController
  
  filter_parameter_logging :pass
  
  def index
    @rights = act_account.rights
  end
  
  def create_account
    account = Account.new(params[:account])
    if account.save
      right = Right.new(:account => account, :user => act_user, :rights => Right::ADMIN)
      if right.save
        flash[:notice] = "Účet vytvořen."
      else
        account.destroy
        flash[:error] = "Nepodařilo se přiřadit práva."
      end
    else 
      flash[:error] = "Máš tam chybu: "+account.errors.first_message
    end
    redirect_to :action => "index"
  end
  
  def set_pass
    user = act_user
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    if params[:password].blank?
      flash[:error] = "Zadej neprázdné heslo."
    elsif user.save
      flash[:notice] = "Heslo změněno."
    else
      flash[:error] = user.errors.first_message
    end
    redirect_to :action => "index"
  end
end
