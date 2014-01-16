class EventsController < ApplicationController
  before_filter :signed_in_user,  only: [:new, :create, :destroy, :edit, :update, :attend]
  before_filter :correct_user,    only: [:edit, :update, :destroy]
  before_filter   :admin_user,    only: :destroy

  def index
    @events = Event.all
    if params[:search].present?
      p "LOCATION SEARCH"
      @events_loc = Event.near(params[:search], 50)
      @events = @events & @events_loc
    end
    if (params[:timeMin] != params[:timeMax])
      p "TIME SEARCH"
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

      @events_time = Event.all(:conditions => ['date >= ? AND date <= ?', timeMin, timeMax])
      @events = @events & @events_time
    end

    if (params[:durationMin] != nil and params[:durationMin] != [""] and params[:durationMin] !={"\"\""=>""})
      p "DurationMin SEARCH"
      p params[:durationMin]
      @events_durationMin = Event.all(:conditions => ['duration >= ?', params[:durationMin]])
      @events = @events & @events_durationMin
    end
    if (params[:durationMax] != nil and params[:durationMax] != [""] and params[:durationMax] !={"\"\""=>""})
      p "DurationMax SEARCH"
      p params[:durationMax]
      @events_durationMax = Event.all(:conditions => ['duration <= ?', params[:durationMax]])
      @events = @events & @events_durationMax
    end
    if (params[:speedArr] != nil and params[:speedArr] != "0")
      p "SpeedArr SEARCH"
      p params[:speedArr]
      @events_speedArr = Event.all(:conditions => ['speedArr == ?', params[:speedArr]])
      @events = @events & @events_speedArr
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
    @event.user_id = current_user.id
    p @event.user_id
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event }
        flash[:success] = "Event was successfully created."
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
        format.html { redirect_to @event}
        flash[:success] = "Event was successfully updated."
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
    @event = Event.find(params[:id])
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
      if (Event.find(params[:id]).user_id != current_user.id and !current_user.admin?)
        redirect_to events_path
        flash[:error] = "You do not own this event"
      end
    end
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end


end
