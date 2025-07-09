

# Softlife API

## JWT Authentication Setup (Devise-JWT)

### 1. Add Devise and Devise-JWT Gems
- Ensure your `Gemfile` includes:
  ```ruby
  gem 'devise'
  gem 'devise-jwt'
  ```

### 2. Configure Devise for JWT
- In `config/initializers/devise.rb`, add:
  ```ruby
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.devise[:jwt_secret_key] || ENV['DEVISE_JWT_SECRET_KEY'] || 'your_fallback_secret_key'
    jwt.dispatch_requests = [
      ['POST', %r{^/login$}],
      ['POST', %r{^/api/v1/login$}],
      ['POST', %r{^/users/sign_in$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/logout$}],
      ['DELETE', %r{^/api/v1/logout$}],
      ['DELETE', %r{^/users/sign_out$}]
    ]
    jwt.expiration_time = 1.day.to_i
  end
  ```

### 3. Set the JWT Secret
- **Production:**
  - Store your JWT secret securely using Rails credentials or an environment variable.
    - To set in credentials: `EDITOR="vim" bin/rails credentials:edit` and add:
      ```yaml
      devise:
        jwt_secret_key: <your-very-secret-key>
      ```
    - Or set in your environment:
      ```sh
      export DEVISE_JWT_SECRET_KEY=<your-very-secret-key>
      ```
- **Development:**
  - The fallback secret in the initializer is fine for local testing, but change it for production!

### 4. Usage Notes
- JWT tokens are issued on login and must be sent in the `Authorization: Bearer <token>` header for all protected API requests.
- Logout is stateless (with Null revocation strategy). To "logout", the client should simply delete the token.
- If you want to support token revocation/blacklisting, use a different revocation strategy (see Devise-JWT docs).

### 5. Error Handling
- Invalid or expired tokens will return a JSON error with status 401, not a 500 error.
- See `app/middleware/jwt_error_handler.rb` for custom error handling.

### 6. Insomnia/Testing
- See `softlife_api_insomnia.json` for ready-to-import API tests.
- The login request will automatically set the JWT token for use in subsequent requests.

---
