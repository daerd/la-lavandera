# La Lavandera

Corporative website built for a laundry bussiness using Middleman, a static site generator written in Ruby.

## Dependencies

- Ruby ~>2.2.0, along with several gems which could installed running "bundle", including Middleman 4.
- Due to the use of Webpack as the external pipeline:
  - NPM ~>6.8.0.
  - NodeJS ~>11.10.0.

## Config

To have both the web and the deploy command working, just create a ".env" file using the ".env.example" as an example and put there the real configuration parameters.

## Useful and self-descriptive commands

```ruby
npm install
rake server
rake build
rake deploy
```
