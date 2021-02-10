class DealersController < ApplicationController
  def index
    if params[:param1] == "sort"
      @dealers = Dealer.sort_by_instruments
    elsif params[:search]
      @dealers = Dealer.search(params[:search])
      @dealers = Dealer.partial_search(params[:search])
    else
      @dealers = Dealer.order_by_created_at
    end
  end

  def instruments
    @dealer = Dealer.find(params[:id])
    if !params[:param1].nil?
      @instruments = @dealer.instruments.order_by_name
    elsif params[:amount].nil?
      @instruments = @dealer.instruments
    else
      amount = params[:amount].to_i
      @instruments = @dealer.instruments.filter_price(amount)
    end
  end

  def show
    @dealer = Dealer.find(params[:id])
    @instruments = @dealer.instruments.count
  end

  def new
  end

  def create
    dealer = Dealer.new(dealer_params)
    if dealer.save
      redirect_to "/dealers"
    else
      flash[:notice] = "Dealer not created: Required information missing."
      render :new
    end
  end

  def edit
    @dealer = Dealer.find(params[:id])
  end

  def update
    dealer = Dealer.find(params[:id])
    dealer.update(dealer_params)
    dealer.save
    redirect_to "/dealers/#{dealer.id}"
  end

  def destroy
    dealer = Dealer.find(params[:id])
    dealer.destroy

    redirect_to "/dealers"
  end

  def new_instrument
    @dealer = Dealer.find(params[:id])
  end

  def create_instrument
    dealer = Dealer.find(params[:id])
    instruments = dealer.instruments
    new = instruments.create(instrument_params)
    if new.save
      redirect_to "/dealers/#{dealer.id}/instruments"
    else
      flash[:notice] = "Instrument not created: Required information missing."
      redirect_to "/dealers/#{dealer.id}/instruments"
    end
  end

  private

  def dealer_params
    params.permit(:name, :fully_staffed, :sq_ft, :city, :state, :search)
  end

  def instrument_params
    params.permit(:name, :on_sale, :brand, :price)
  end
end
