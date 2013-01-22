class StopsController < ApplicationController
  respond_to :json
  
  def destroy
    @stop = Stop.find(params[:id])
    @stop.delete
    render :nothing => true
  end
  
  def update 
    @stop = Stop.find(params[:id])
    @stop.update_attributes(params[:stop])
    render :json => @stop
  end
end
