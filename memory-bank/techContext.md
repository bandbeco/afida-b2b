# Technical Context: AFIDA E-commerce Platform

## Technologies Used

### Backend Framework
- **Ruby on Rails 7.2**: Full-stack web application framework
- **PostgreSQL**: Relational database management system
- **Active Record**: ORM for database interaction
- **Active Storage**: File attachment management for product images

### Authentication & Authorization
- **Devise**: Authentication solution for Rails
- **Devise Invitable**: Extension for user invitation functionality
- **CanCanCan**: Authorization library for permission management

### Frontend Technologies
- **Tailwind CSS**: Utility-first CSS framework for styling
- **DaisyUI**: Component library for Tailwind CSS providing pre-designed UI components
- **Stimulus JS**: Modest JavaScript framework for enhanced interactivity
- **Importmap**: JavaScript module management without bundling
- **ERB**: Embedded Ruby templating

### Development Tools
- **Bundler**: Dependency management for Ruby gems
- **Rake**: Task automation tool
- **Rails Console**: Interactive command-line for the Rails environment

### Testing Framework
- **Minitest**: Testing framework included with Rails
- **System Tests**: End-to-end testing with browser automation

### Deployment & Infrastructure
- **Docker**: Containerization for consistent environments
- **Puma**: Web server for Ruby applications
- **Honeybadger**: Error monitoring and alerting

## Development Setup

### Local Environment Requirements
- Ruby 3.x
- PostgreSQL 14+
- Node.js (for asset compilation)
- Docker (optional, for containerized development)

### Setup Process
1. Clone repository
2. Install dependencies with `bundle install`
3. Set up database with `rails db:setup`
4. Run migrations with `rails db:migrate`
5. Seed initial data with `rails db:seed`
6. Start the server with `bin/dev` (uses Procfile.dev)

### Environment Variables
- `DATABASE_URL`: PostgreSQL connection string
- `RAILS_MASTER_KEY`: Encryption key for credentials
- `RAILS_ENV`: Environment (development, test, production)
- Various Devise configuration settings

## Technical Constraints

### Performance Considerations
- Database query optimization for product listings
- N+1 query prevention
- Image optimization for product photos
- Pagination for large result sets

### Security Requirements
- CSRF protection
- Secure password handling
- Role-based access control
- Input validation and sanitization
- SQL injection prevention

### Browser Compatibility
- Support for modern browsers (Chrome, Firefox, Safari, Edge)
- Responsive design for mobile and desktop
- Graceful degradation for older browsers

### Scalability Considerations
- Database indexing strategy
- Connection pooling
- Potential for background job processing
- Caching strategy for frequently accessed data

## Dependencies

### Ruby Gems
- `rails (~> 7.2.0)`: Web framework
- `pg`: PostgreSQL adapter
- `puma`: Web server
- `devise`: Authentication
- `devise_invitable`: User invitations
- `cancancan`: Authorization
- `tailwindcss-rails`: Tailwind CSS integration
- `daisyui`: DaisyUI component library for Tailwind
- `stimulus-rails`: Stimulus JS integration
- `importmap-rails`: Import maps for JavaScript
- `image_processing`: Image manipulation for Active Storage
- `honeybadger`: Error monitoring

### External Services
- Email delivery service for notifications
- Postcode lookup service for address validation

## Tool Usage Patterns

### Database Management
- Migrations for schema changes
- Seeds for initial data population
- Rails console for ad-hoc data manipulation
- Database backups and restoration procedures

### Asset Management
- Active Storage for image uploads and storage
- Asset pipeline for CSS and JavaScript
- Tailwind with DaisyUI for styling components

### Testing Practices
- Model tests for business logic
- Controller tests for request handling
- System tests for end-to-end functionality
- Fixtures for test data

### Deployment Workflow
- CI/CD pipeline for automated testing and deployment
- Docker for containerization
- Environment-specific configuration
- Database migration strategy

### Monitoring & Maintenance
- Logging strategy
- Performance monitoring
- Database maintenance tasks

## Configuration Management

### Environment-specific Configuration
- Development environment optimized for debugging
- Test environment for automated testing
- Production environment optimized for performance and security

### Feature Flags
- Potential for feature flags to control rollout of new features
- Environment-specific feature enabling/disabling

### Database Configuration
- Connection pooling settings
- Timeout configurations
- SSL requirements for production

### Security Settings
- Content Security Policy
- Permissions Policy
- Session storage configuration
- CSRF protection mechanisms
