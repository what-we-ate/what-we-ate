class Admin
  class EventsController < AdminController
    before_action -> { session.delete(:event) }, only: :create

    def index
      @pending_events = Event.pending.most_recent
      @approved_events = Event.upcoming.approved.most_recent
      @past_events = Event.past.most_recent
    end

    def show
      @event = find_event.decorate
    end

    def preview
      @event = Event.new(session[:event]).decorate
      @event_host = @event.host
      @event_user = @event_host.user
    end

    def new
      @event = Event.new(session[:event])
      @hosts = find_hosts
    end

    def create
      @event = Event.new(event_params.merge(state: "available"))

      return handle_preview if params[:commit] == "Preview"

      if @event.save
        redirect_to(admin_events_url, notice: "Event successfully created")
      else
        @hosts = find_hosts
        render(:new)
      end
    end

    def edit
      @event = find_event
      @hosts = find_hosts
    end

    def update
      @event = find_event
      if @event.update(event_params)
        redirect_to(admin_event_url(@event), notice: "Event successfully updated")
      else
        @hosts = find_hosts
        render(:edit)
      end
    end

    def approve
      @event = find_event
      if @event.approve!
        flash[:notice] = "Event successfully approved"
      else
        flash[:alert] = "Event could not be approved"
      end
      redirect_to(admin_event_url(@event))
    end

    def destroy
      @event = find_event
      if @event.present?
        @event.destroy
        redirect_to(admin_events_url, notice: "Event successfully deleted")
      else
        redirect_to(edit_admin_event_url(@event))
      end
    end

    private

    def handle_preview
      if @event.valid?
        session[:event] = event_params
        redirect_to(preview_admin_events_url)
      else
        render(:new)
      end
    end

    def find_event
      Event.friendly.find(params[:id])
    end

    def find_hosts
      Host.all
    end

    def event_params
      params.require(:event).
        permit(:host_id, :date_date, :date_time, :title, :location, :location_url,
               :description, :menu, :seats, :price, :primary_photo, :primary_photo_cache)
    end
  end
end
