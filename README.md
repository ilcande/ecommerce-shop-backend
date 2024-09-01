# Overview

The e-commerce application is a two-part system consisting of a backend Rails API and a [frontend React application](https://github.com/ilcande/ecommerce-shop-frontend). The backend Rails application serves as an API-only server that provides a robust and scalable interface for CRUD operations, business logic, and data management. The frontend React application, styled with Tailwind CSS, acts as the user interface through which end-users interact with the application.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/ilcande/ecommerce-shop-backend.git
    ```

2. Change into the directory:

   ```bash
   cd ecommerce-shop-backend
   ```

3. Install dependencies:

   ```bash
    bundle install
    ```

4. Create the database:

   ```bash
   rails db:create
   ```

5. Run the migrations:

   ```bash
    rails db:migrate
    ```

6. Seed the database with sample data:

   ```bash
    rails db:seed
    ```

7. Start the Rails server:

   ```bash
    rails s
    ```

8. The Rails server should now be running at `http://localhost:3000`.

## Testing

To run the test suite, execute the following command:

```bash
rspec
```

## API Endpoints

### Public

The API provides the following main endpoints for and admin to manage products, parts, options, and configurations:

- `GET /` - Retrieve the API root.
- `GET /products` - Retrieve all products.
- `GET /products/:id` - Retrieve a specific product.

### Admin

- `GET /admin/dashboard` - Retrieve the admin dashboard.
- `POST /admin/products` - Create a new product.
- `PATCH /admin/products/:id` - Update an existing product.
- `DELETE /admin/products/:id` - Delete a product.
- `POST /admin/products/:product_id/product_configurations/bulk_create` - Create multiple product configurations for a product.
- `POST /admin/parts` - Create a new part.
- `POST /admin/parts/:part_id/options` - Create a new option for a part.
- `PATCH /admin/parts/:part_id/options/:id` and `PUT /admin/parts/:part_id/options/:id`  - Update an existing option for a part.
- `POST /admin/parts/:part_id/constraints` - Create a new constraint for some options of some parts.
- `POST /admin/stock_levels` - Create a new stock level for an option.
- `PATCH /admin/stock_levels/:id`  and `PUT /admin/stock_levels/:id` - Update an existing stock level for an option.

### Products

- **GET /api/products**: Retrieve all products.
- **GET /api/products/:id**: Retrieve a specific product.
- **POST /api/products**: Create a new product.
- **PATCH /api/products/:id**: Update an existing product.
- **DELETE /api/products/:id**: Delete a product.

### Parts

- **GET /api/parts**: Retrieve all parts.

## Architecture Backend (Rails API)

### Technology Stack

1. **Ruby on Rails**: Framework for building the API, following RESTful principles.
2. **PostgreSQL**: Database management system for data persistence.

### Components

- **Controllers**:
  - Handle HTTP requests and responses.
  - Route requests to appropriate services or perform direct CRUD operations.
  - Examples: `Admin::ProductsController` for managing product creation and updates.

- **Services**:
  - Encapsulate business logic and complex operations.
  - Used to keep controllers thin and focused on handling HTTP requests.
  - Examples: `ProductConfiguratorService` for managing product configuration and options.

- **Models**:
  - Define the data structure and relationships.
  - Validate and interact with the PostgreSQL database.
  - Examples: `Product`, `Option`, `StockLevel`.

- **Error Handling and Logging**:
  - Centralized error handling and logging are implemented to capture and manage errors and log information for debugging and monitoring.
  - Use of Rails' built-in logging mechanisms and potentially external services like Sentry for error tracking.

- **Authentication and Authorization**:
  - `Admin` users are authenticated using `Devise`, with access controlled by role-based authorization.
  - Generic users interact with the public-facing parts of the application, such as product browsing and cart management.

## Data Flow

The frontend React application interacts with the backend Rails API through HTTP requests. The API processes these requests, performs CRUD operations on the PostgreSQL database, and returns the appropriate responses. The frontend application then updates the UI based on the responses received.

- **User Interaction**:
  - Users interact with the frontend React application via UI components.

- **API Requests**:
  - React components make HTTP requests to the Rails API using Axios.

- **Controller Handling**:
  - Rails controllers receive requests, perform necessary operations, and send responses.

- **Service Layer (if applicable)**:
  - Complex business logic is handled by service objects.

- **Database Operations**:
  - Models interact with PostgreSQL to perform CRUD operations.

- **Response Handling**:
  - The Rails API returns data or status codes, which are then processed by React components.

- **Error Logging and Authentication**:
  - Errors are logged and managed centrally.
  - Authentication ensures secure access to administrative functions.

## System Design

The system is designed to be modular, scalable, and maintainable. The separation of concerns between the frontend and backend allows for independent development and deployment of each part. The backend API follows RESTful principles, providing a clear and consistent interface for data management.

![System Design](system-design.png)

## Scalability and Performance

The system is designed to be scalable and performant by following best practices and utilizing appropriate technologies.

- **Scalability**:
  - Both the backend and frontend are designed to handle growing user bases and data sizes.

- **Database Optimization**:
  - Proper indexing, query optimization, and database tuning to improve performance.

- **Maintainability**:
  - The separation of concerns (controllers, services, models) ensures that the codebase is maintainable and extensible.

## Schema Explanation

### 1. Products Table

- **Purpose**: Stores information about the generic products available for sale.
- **Fields**:
  - `name` (string, not null): The name of the product (e.g., “Mountain Bike”).
  - `product_type` (string, not null): The type of product (e.g., “Bike”, “Ski”). This allows differentiation between various product categories.
  - `base_price` (decimal, precision: 10, scale: 2, not null): The base price of the product before customization.
  - `timestamps`: Automatic fields (created_at and updated_at) for record tracking.

  **Rationale**: This table provides a central repository for all product types and their base prices, enabling easy management and scalability as new product types are introduced.

### 2. Parts Table

- **Purpose**: Defines different parts or components that can be customized for a product.
- **Fields**:
  - `name` (string, not null): The name of the part (e.g., “Frame Type”).
  - `product_type` (string, not null): The type of product to which this part applies (e.g., “Bike”, “Ski”).

  **Rationale**: This table abstracts the concept of parts, making it possible to define and manage various components that are applicable across different product types.

### 3. Options Table

- **Purpose**: Contains the available options for each part, including their prices and stock status.
- **Fields**:
  - `part_id` (references, not null): Foreign key linking to the parts table, specifying which part this option belongs to.
  - `name` (string, not null): The name of the option (e.g., “Full-Suspension”, “Matte”).
  - `price` (decimal, precision: 10, scale: 2, not null): The price of this specific option.
  - `is_in_stock` (boolean, default: true): Indicates whether this option is currently in stock.

  **Rationale**: This table allows for detailed management of individual options for parts, including pricing and stock availability, crucial for customizable products.

### 4. Constraints Table

- **Purpose**: Manages constraints between parts and their options to enforce valid combinations.
- **Fields**:
  - `part_id` (references, not null): Foreign key to the parts table indicating the part being constrained.
  - `constraint_part_id` (references, not null): Foreign key to the parts table indicating the part affected by the constraint.
  - `constraint_option_id` (references, not null): Foreign key to the options table specifying the option that enforces the constraint.
  - `option_id` (references, not null): Foreign key to the options table specifying the option that is constrained.

  **Rationale**: This table supports the implementation of business rules by defining constraints on which options can be selected based on other options, ensuring the product configurations are valid and realistic.

### 5. ProductConfigurations Table

- **Purpose**: Stores the configuration of a specific product based on user selections.
- **Fields**:
  - `product_id` (references, not null): Foreign key to the products table, linking the configuration to a specific product.
  - `option_id` (references, not null): Foreign key to the options table, indicating the selected option for the part.

  **Rationale**: This table captures the user-selected configurations for a product, allowing the customization of products and tracking of chosen options.

### 6. StockLevels Table

- **Purpose**: Manages stock levels for each option to handle inventory and availability.
- **Fields**:
  - `option_id` (references, not null): Foreign key to the options table, linking the stock level to a specific option.
  - `quantity` (integer, not null, default: 0): The quantity of the option available in stock.
  - `is_in_stock` (boolean, default: true): Indicates whether the option is currently in stock.

  **Rationale**: This table provides detailed stock management for each option, allowing the system to track inventory levels and manage out-of-stock situations effectively.

## Design Considerations

- **Scalability**: The schema is designed to handle the addition of new product types and parts without major changes. The use of foreign keys and constraints ensures data integrity and supports complex business rules.
- **Flexibility**: The design allows for various product configurations and constraints, making it adaptable to different types of products beyond bicycles.
- **Stock Management**: Separate tables for options and stock levels enable detailed management of inventory, ensuring accurate availability information for customers.

## Future Enhancements

- **Extensibility**: The schema can be extended to support additional product types and parts as needed.
- **Performance Optimization**: Indexes and caching strategies may be applied to improve performance for large datasets.
- **Business Rules**: Additional constraints and validation rules can be implemented to accommodate evolving business requirements.

## Entities and Relationships

1. **Product**
   - **Attributes**: id, name, product_type, base_price, image_url
   - **Relationships**:
     - One-to-Many with product_configurations (one product can have many configurations)

2. **Part**
   - **Attributes**: id, name, product_type
   - **Relationships**:
     - One-to-Many with options (one part can have many options)
     - One-to-Many with constraints (one part can have many constraints)

3. **Option**
   - **Attributes**: id, name, price, is_in_stock, part_id
   - **Relationships**:
     - Many-to-One with part
     - One-to-Many with stock_levels (one option can have many stock levels)
     - One-to-Many with constraints (one option can have many constraints)
     - Many-to-One with product_configurations

4. **ProductConfiguration**
   - **Attributes**: id, product_id, option_id
   - **Relationships**:
     - Many-to-One with product
     - Many-to-One with option

5. **Constraint**
   - **Attributes**: id, part_id, constraint_part_id, constraint_option_id
   - **Relationships**:
     - Many-to-One with part (the part being constrained)
     - Many-to-One with part (as constraint_part_id, the part causing the constraint)
     - Many-to-One with option (as constraint_option_id, the option causing the constraint)

6. **StockLevel**
   - **Attributes**: id, option_id, quantity, is_in_stock
   - **Relationships**:
     - Many-to-One with option

## ERD Visualization

- Product connects to ProductConfiguration through a one-to-many relationship.
- ProductConfiguration connects to Option through a many-to-one relationship.
- Part connects to Option through a one-to-many relationship.
- Option connects to StockLevel through a one-to-many relationship.
- Constraint connects to Part and Option through a many-to-one relationship.
