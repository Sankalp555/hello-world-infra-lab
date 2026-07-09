# 1. Use an official Ruby image as the base
FROM ruby:3.3.4-slim

# 2. Install essential system dependencies and CLEAN UP
# We combine the commands and delete the cache in the SAME layer to save space.
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    git \
    curl && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 3. Set the working directory
WORKDIR /app

# 4. Copy Gemfiles first for layer caching
COPY Gemfile Gemfile.lock ./

# 5. Install Ruby dependencies and CLEAN UP
# We skip development/test gems and remove the gem cache.
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3 && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

# 6. Copy the rest of the application code
COPY . .

# 7. Precompile assets
RUN RAILS_ENV=production SECRET_KEY_BASE=dummy_for_precompile bundle exec rails assets:precompile

# 8. Start the application
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
