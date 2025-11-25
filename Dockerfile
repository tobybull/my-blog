FROM docker.io/ruby:3.3-slim

# Install OS dependencies
RUN apt-get update && \
    apt-get install -y build-essential nodejs git && \
    gem install bundler

WORKDIR /site

# Install gems when Gemfile changes
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Site content is mounted as a volume at runtime

# Default command when container runs
CMD ["bundle", "exec", "jekyll", "serve", "--watch", "--drafts", "--livereload", "--host", "0.0.0.0"]
