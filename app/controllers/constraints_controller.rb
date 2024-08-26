class ConstraintsController < ApplicationController
  before_action :set_constraint, only: [:show, :update, :destroy]

  # GET /constraints?part_ids=1,2,3
  def index
    # Ensure part_ids is a unique list
    part_ids = params[:part_ids].split(',').map(&:to_i).uniq
    
    # Fetch constraints based on unique part IDs
    constraints = Constraint.where(part_id: part_ids)
    
    # Render constraints with associated data
    render json: constraints.to_json(include: {
      constraint_part: { only: [:id, :name] },
      constraint_option: { only: [:id, :name, :price] },
      part: { only: [:id, :name] },
      option: { only: [:id, :name, :price] }
    })
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
      render json: { errors: @constraint.errors.as_json }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /constraints/:id
  def update
    if @constraint.update(constraint_params)
      render json: @constraint
    else
      render json: { errors: @constraint.errors.as_json }, status: :unprocessable_entity
    end
  end

  # DELETE /constraints/:id
  def destroy
    @constraint.destroy
    head :no_content
  end

  private

  def set_constraint
    @constraint = Constraint.find(params[:id])
  end

  def constraint_params
    params.require(:constraint).permit(:part_id, :constraint_part_id, :constraint_option_id)
  end
end
