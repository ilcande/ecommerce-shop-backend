class ConstraintsController < ApplicationController
  before_action :set_constraint, only: [:show, :update, :destroy]

  # GET /constraints
  def index
    @constraints = Constraint.all
    render json: @constraints
  end

  # GET /constraints/:id
  def show
    render json: @constraint
  end

  # POST /constraints
  def create
    @constraint = Constraint.new(constraint_params)
    if @constraint.save
      render json: @constraint, status: :created
    else
      render json: @constraint.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /constraints/:id
  def update
    if @constraint.update(constraint_params)
      render json: @constraint
    else
      render json: @constraint.errors, status: :unprocessable_entity
    end
  end

  # DELETE /constraints/:id
  def destroy
    @constraint.destroy
  end

  private

  def set_constraint
    @constraint = Constraint.find(params[:id])
  end

  def constraint_params
    params.require(:constraint).permit(:part_id, :constraint_part_id, :constraint_option_id)
  end
end
