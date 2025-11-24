FROM ruby:3.3-slim

# Install OS dependencies
RUN apt-get update && \
    apt-get install -y build-essential nodejs git && \
    gem install bundler

WORKDIR /site

# Install gems when Gemfile changes
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Default command when container runs
CMD ["bundle", "exec", "jekyll", "serve", "--watch", "--drafts", "--livereload", "--host", "0.0.0.0"]

# docker build -t jekyll-blog .
# docker run --rm -v "$(pwd):/site" -p 4000:4000 jekyll-blog
