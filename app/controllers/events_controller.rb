class EventsController < ApplicationController
  before_filter :signed_in_user,  only: [:new, :create, :destroy, :edit, :update, :attend]
  before_filter :correct_user,    only: [:edit, :update,  :destroy]

  def index
    if params[:search].present?
      @events_location = Event.near(params[:search], 50, :order => :distance)
    end
    if (params[:timeMin].present? and params[:timeMax].present? and params[:timeMin] != params[:timeMin])
      #min = DateTime.new(params[:timeMin]["1i"],2,3,4,5,6)
      timeMin = DateTime.new(
                              params["timeMin"]["(1i)"].to_i, 
                              params["timeMin"]["(2i)"].to_i,
                              params["timeMin"]["(3i)"].to_i,
                              params["timeMin"]["(4i)"].to_i,
                              params["timeMin"]["(5i)"].to_i,
                              "0".to_i)
      timeMax = DateTime.new(
                              params["timeMax"]["(1i)"].to_i, 
                              params["timeMax"]["(2i)"].to_i,
                              params["timeMax"]["(3i)"].to_i,
                              params["timeMax"]["(4i)"].to_i,
                              params["timeMax"]["(5i)"].to_i,
                              "0".to_i)     

      #@events = Event.where('date BETWEEN ? AND ?', somedate, somedate)
      @events_time = Event.all(:conditions => ['date >= ? AND date <= ?', timeMin, timeMax])
    else
      @events = Event.all
    end
    
    @user = current_user
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end
  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @user = User.find(@event.user_id)
    @locations = @event
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.events.build(params[:event])
    @event.user_id = current_user

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def attend
    @event = Event.find(params[:id])
    if @event.users.include?(current_user)
      flash[:error] = "You're already attending this event."
    else
      current_user.events << @event
      flash[:success] = "Attending event!"
    end
    redirect_to @event
  end

  def withdraw
    event    = Event.find(params[:id])
    attendee = Attendee.find_by_user_id_and_event_id(current_user.id, event.id)

    if attendee.blank?
      flash[:error] = "No current attendees"
    else
      attendee.delete
      flash[:success] = 'You are no longer attending this event.'
    end
    redirect_to event
  end
  
  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    redirect_to root_path, :notice => "Successfully deleted event"
  end
  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end
    def correct_user
      @event = current_user.events.find_by_id(params[:id])
      if !@event.present?
        redirect_to events_path, :notice => "You do not own this event"
      end
    end
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end


end
