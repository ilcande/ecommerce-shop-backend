class ConstraintsController < ApplicationController
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
end

