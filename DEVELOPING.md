# Developing Flippd

This document describes how to setup your environment in order to make changes to Flippd.

## Prerequisites

If you are using a machine in CS student labs, you can skip this section. Otherwise, you need to install [VirtualBox](https://www.virtualbox.org) and [Vagrant](https://www.vagrantup.com/downloads.html).

## Installing Flippd

Run `git clone https://github.com/flippd/flippd.git`. This will create a directory `flippd`. In that directory, create a file called `.env` with the following contents:

```
CONFIG_URL=https://raw.githubusercontent.com/york-cs-dams/flippd-dams/master/
COOKIE_SECRET=abcdefg
```

Now run `vagrant up`. After a few minutes, you'll see:

```
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => /<YOUR HOME DIR>/flippd
```

Test that the installation has worked by navigating to [http://localhost:4567](http://localhost:4567) in a web browser. You should see that Flippd is running, and is displaying the DAMS videos and other materials.


## Making a change

Let's try making a really simple change to Flippd, so that we can see what the process looks like:

1. Open `app/flippd.rb` and change the value of the `@version` variable.
2. Run `vado rake restart`. (If this step fails because `vado` cannot be found, you should complete the DAMS Vagrant tutorial and try again).
3. Reload the webpage at [http://localhost:4567](http://localhost:4567). You should see the new version number in the footer of the page.


## Running the integration tests

Flippd has a small number of high-level (integration) tests that check its basic functionality. You can run these with `vado rake test`. It's helpful to run these often to increase confidence that any changes that have been made have not introduced a bug.

## Debugging

Let's see what happens when an error is introduced into the Flippd code:

1. Open `app/flippd.rb` and, immediately after `@version = ...` add the following statement on a new line `raise "Boom!"`.
2. Run `vado rake restart`.
3. Reload the webpage at [http://localhost:4567](http://localhost:4567). You should see an error page that contains the text `Runtime Error: Boom!`.
4. Take a look at the various sections of the page. Note that the Backtrace indicates precisely where in the code the error has occurred.
5. The other sections of the error page provide information about the HTTP request that resulted in this error.

If visiting [http://localhost:4567](http://localhost:4567) ever fails to render an error page, this usually means that there is a syntax error somewhere in the code. Running `vado rake log` will normally help to pinpoint the problem.


## Technologies

Flippd has an intentionally small number of dependencies on other pieces of software. The two most important dependencies are on Sinatra and on ERB.

Sinatra is a lightweight web framework for Ruby. Roughly speaking, it handles the HTTP layer of the web stack so that Flippd need only be concerned with (1) determining what kind of request is being made, and (2) rendering some appropriate HTML. You can see this by looking at `app/routes/main.rb`. Note that the structure of the file is something like this:

```ruby
class Flippd < Sinatra::Application
  before do
    # code that runs for every request
  end

  get '/' do
    # code that runs only when the user requests '/'
  end

  get '/phases/:title' do
    # code that runs only when the user requests '/phases/:title' where title is a variable
  end

  get '/videos/:id' do
    # code that runs only when the user requests '/videos/:id' where id is a variable
  end
```

The purpose of every `get` block is ultimately to render some HTML to send back to the user. More often than not, HTML is rendered via ERB...

ERB is a template-based code generation language built into Ruby. It allows us to parameterise plaintext documents (such as HTML) with Ruby code. For example:

```erb
Hello <%=@name%>!

Your friends are:
<% friends.each do |friend| %>
* <%=friend.name%>
<% end %>
```

Note that the sections of the text that are enclosed in `<%` and `%>` are Ruby code.

For more information, see the [Sinatra README](http://www.sinatrarb.com/intro.html) and [this ERB tutorial](http://www.stuartellis.eu/articles/erb).


## Project layout

Flippd is roughly split into five pieces:

1. `spec` - Test suite
2. `app/routes` - Ruby code that drives the application via Sinatra
3. `app/views`- ERB templates that render HTML
4. `app/public` - Javascript and CSS files
5. `config` - Vagrant provisioning scripts

Most of the changes made for your assessment should be to Ruby server code (2 in the list above). You may also need to change the ERB templates (3), but any changes to the HTML should be discussed with me first.

You will want to change the test suite (1) as you add new features and make changes to existing features. However, testing is not something I am assessing in DAMS, so I can give you lots of help and advice.

You should not change the Javascript and CSS (4) or the Vagrant setup (5), but can discuss desirable changes with me first. (Where feasible, I will do this work for you, so that you can focus on the more important parts of your assessment).

Flippd does not currently use a database, and the Vagrant setup does not currently install one.
