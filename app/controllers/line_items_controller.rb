class LineItemsController < ApplicationController

  skip_before_filter :authorize, :only => :create

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end
##------------------------------------------------------------------------------
  # POST /line_items
  # POST /line_items.json
  def create
    @cart = current_cart # current_cart is a METHOD!! NOT a variable
    # sb: RECALL it was defined in application_controller.rb as private
    # sb: application_controller.rb means public to all controllers
    # sb: private means NEVER AN ACTION ON A CONTROLLER
    # sb: remember variables are @instance_variable and @@class_variable !!
    # sb: current_cart is defined in application_controller.rb (not a model-specific controller)
    # sb: HOW DOES product GET PROTECTED?? and  since not an attribute, how to fix????
    # sb: product is not a variable .... it's a class object !!
    product = Product.find(params[:product_id])
#puts session.join("--")
#    @line_item = LineItem.new(params[:line_item])
## sb: ** SECURITY: mass-assignment allows other fields to set
## sb: ** you must explicitly declare with variables are (un)protected
## sb: ** http://railscasts.com/episodes/26-hackers-love-mass-assignment
## sb: ** the real issue with the params[:line_item]
## sb: ** YOU CAN NEVER TRUST THE params[:hash]!!!!
## sb: ** error says product is protected and can't mass assign
## sb: ** cart has_many line_items so has_many == build method
## sb: ** I FIXED the mass-assign error by adding product
## sb: ** to the attr_accessible line in the LineItem model

    #@line_item = @cart.line_items.build(:product => product)
    @line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save
#        format.html { redirect_to @line_item, :notice => 'Line item was successfully created.' }
#        format.html { redirect_to @line_item.cart, :notice => 'Line item was successfully created.' }
        format.html { redirect_to(store_url, :notice => 'Line item was successfully created.') }
        format.js { @current_item = @line_item }
        format.json { render :json => @line_item, :status => :created, :location => @line_item }
        format.xml { render :xml => @line_item, :status => :created, :location => @line_item } 
      else
        format.html { render :action => "new" }
        format.json { render :json => @line_item.errors, :status => :unprocessable_entity }
        format.xml { render :xml => @line_item.errors, :status => :unproessable_entity } 
      end
    end
  end
##------------------------------------------------------------------------------

  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.html { redirect_to @line_item, :notice => 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :no_content }
    end
  end
end
