module FlightsHelper
  def index_for_pagination(index)
    if params[:page].to_i < 1
      ((params[:page].to_i) * 30) + (index + 1)
    else
      ((params[:page].to_i - 1) * 30) + (index + 1)
    end
  end
end
