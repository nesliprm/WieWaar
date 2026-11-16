# Bootstrap 5.3 still uses Sass @import and older Sass functions.
# Hide those deprecation warnings so real problems in our own SCSS stand out.
Rails.application.config.dartsass.build_options |= [ "--quiet-deps", "--silence-deprecation=import" ]
