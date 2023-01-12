class BirdsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
# using find will throw an activerecord::RecordNotFound exception which if we use the above code and put the the method after the with: then any of the below code that throw this error will send our generic response we created in our private methods!!!  i like it.  simple and easy to forget so im writing this out to remember
# use find instead of find_by for this to work.  find_by will return nil which would let us do if/else statements but not throw an activerecord::RecordNotFound exception so we would need to explicityly state the error message in each action
  # GET /birds
  def index
    birds = Bird.all
    render json: birds
  end

  # POST /birds
  def create
    bird = Bird.create(bird_params)
    render json: bird, status: :created
  end

  # GET /birds/:id
  def show
    bird = find_bird
    render json: bird
  end

  # PATCH /birds/:id
  def update
    bird = find_bird
    bird.update(bird_params)
    render json: bird
  end

  # DELETE /birds/:id
  def destroy
    bird = find_bird
    bird.destroy
    head :no_content
  end

  private

  def find_bird
    Bird.find(params[:id])
  end

  def bird_params
    params.permit(:name, :species, :likes)
  end

  def render_not_found_response
    render json: { error: "Bird not found" }, status: :not_found
  end

end
