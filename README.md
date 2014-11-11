# UrlShortnr: Simple URL shortener in Sinatra

A very basic URL shortener using Ruby, Sinatra, and Redis.

## Overview

App provides a root page that presents a form. The form accepts a URL
and then, when submitted, saves the URL into Redis. The visitor
is then presented with a page that displays the shortened URL.

When a shortened URL is requested, the system locates the real URL in Redis by the key
and redirects the visitor to the real URL.

If a URL is not found, the visitor is told it's not available.

## Structure
~~~
├── Gemfile                 Dependencies.
├── Gemfile.lock            Dependencies lockfile.
├── Guardfile               Test runner.
├── README.md               You are reading this.
├── config.ru               File that runs the app.
├── lib
│   ├── app.rb              The main web app.
│   ├── url_store.rb        The model that talks to Redis.
│   └── views
│       ├── error.erb       Displayed when URL can't be saved.
│       ├── index.erb       Main page of the system displaying the form.
│       ├── nothing.erb     Displayed when the shortened URL doesn't exist.
│       └── show.erb        Detail page about shortened URL.
~~~

### Flow

```

  +---------------+            +-----------+---+      +----------------------+
  | User submits  +-----+----> | Sinatra saves +----->| Display show.erb     |
  | URL           |     |      | to Redis      |      | page with short URL  |
  +---------------+     |      +---------------+      +----------------------+
                        |      +---------------+      +----------------------+
                        +----> | Sinatra can't |      | Display failure      |
                               | store URL     +----->| page (error.erb)     |
                               +---------------+      +----------------------+

  +---------------+            +------------------+      +----------------------+
  | User follows  +-----+----> | Sinatra looks    +----->| Display show.erb     |
  | short URL     |            | for URL in Redis |  |   |  page with short URL |
  +---------------+            +------------------+  |   +----------------------+
                                                     |   +----------------------+
                                                     |   | Display failure      |
                                                     +-->| page (nothing.erb)   |
                                                         +----------------------+

```

## Requirements

* Redis
* Sinatra
* Ruby 2.1

## Installation

First, get Redis running. Install with your tool of choice.  

Second, this app uses Redis on the default port since this is a basic app
to learn how Ruby and Redis work together. Modify the code if you want to change
the port and address to Redis.

Next, clone this repository.

After that, run `bundle` to set things up.

Finally, run 

```
rackup
```

to run the app.

# License
MIT license. 

Copyright 2014 Brian P. Hogan
