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
2. Run `vado rake restart`. (If this step fails because `vado` cannot be found, you should complete the [DAMS Vagrant tutorial](https://github.com/york-cs-dams/practicals/blob/master/tutorials/tools/vagrant.md) and try again).
3. Reload the webpage at [http://localhost:4567](http://localhost:4567). You should see the new version number in the footer of the page.


## Working with a different configuration

Flippd displays information about a specific module (e.g., DAMS), and this information is taken from the Github repository at location specified by CONFIG_URL in your `.env` file. If you've followed the instructions above, your `.env` file will use a Github repository that contains information about DAMS. You can also change Flippd to use your own Github repository (perhaps a clone of the [DAMS repository](https://github.com/york-cs-dams/flippd-dams), for example).

You can also change Flippd to use local files, by setting `CONFIG_URL` equal to some path relative to the base directory of the application. So for example, you could create a directory `module` (in the same directory as `app`, `config`, etc) and set `CONFIG_URL=module/` in your `.env` file. Do make sure that `module` contains both a `template.json` file and an `index.erb` file.


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

The purpose of every `get` block is ultimately to render some HTML to send back to the user. More often than not, HTML is rendered via ERB (e.g., `erb :phase` will render the file at `/app/views/phase.erb`).

ERB is a template-based code generation language built into Ruby. It allows us to parameterise plaintext documents (such as HTML) with Ruby code. For example:

```erb
Hello <%=@name%>!

Your friends are:
<% @friends.each do |friend| %>
* <%=friend.name%>
<% end %>
```

Any instance variables declared in a Sinatra `get` block are passed to the ERB template that is being rendered.

Note that the sections of the text that are enclosed in `<%` and `%>` are Ruby code.

For more information, see the [Sinatra README](http://www.sinatrarb.com/intro.html) and [this ERB tutorial](http://www.stuartellis.eu/articles/erb).

## Database

Since Flippd v0.0.4, a database is used to store information about logged-in users. The data is stored in a [MySQL 5](https://www.mysql.com) database. Flippd uses the [DataMapper](http://datamapper.org) gem to interact with the database. To become familiar with how Flippd reads and writes data to the database, I strongly recommend that you:

1. Take a look at `app/models/user.rb` to understand how Ruby classes can be used to define and access database tables. You might like to refer to DataMapper's [Properties Guide](http://datamapper.org/docs/properties.html).
2. Take a look at `app/routes/auth.rb` to understand how objects can be retrieved from the database (e.g., via `User#get`) and saved to the database (e.g., via `User#first_or_create`). You might like to refer to DataMapper's [Create, Save, Update and Destroy](http://datamapper.org/docs/create_and_destroy.html) and [Finding and Counting Records](http://datamapper.org/docs/find.html) guides.
3. Read through the notes below which detail how your development workflow should change when working with the database.

Adding a database to the mix has several ramifications on how we develop Flippd. The most important of these are:

* **Don't edit the database by hand.** Any new database tables should be defined by creating a new file in `app/models`. Every file in this directory should define classes that `include DataMapper::Resource`. Any changes to database tables should be made to the corresponding file in `app/models`. Most changes will be automatically propagated to the database, when you next make a request to the web application. Changes that would invalidate existing records in the database will not be automatically propagated, so you will need to run `vado rake db:schema:load`. *This will delete all of the data in the database!*

* **Quering the database can be useful for debugging.** The `vado rake db` command can be used to start an interactive session with the MySQL database. You can enter SQL commands here to see whether the database has the contents that you expect (e.g., `SELECT * from users;`) and you can check the structure of tables (`DESCRIBE users;`).

* **The test suite uses a separate MySQL database.** So that you can run the test suite locally without destroying the state of your development database, the test suite uses its own MySQL database, named `flippd_test`. (By default, the database named `flippd` is used). The `flippd_test` database is automatically cleared out between each test case so that test cases do not interfere with each other.


## Project layout

Flippd is roughly split into five pieces:

1. `spec` - Test suite
2. `app/db` - Ruby code that setups up the database connection
3. `app/models` - Ruby code for CRUD operations on the database
4. `app/routes` - Ruby code that drives the application via Sinatra
5. `app/views`- ERB templates that render HTML
6. `app/public` - Javascript and CSS files
7. `config` - Vagrant provisioning scripts

Most of the changes made for your assessment should be to Ruby server code (3 and 4 in the list above). You may also need to change the ERB templates (5), but any changes to the HTML should be discussed with me first.

You will want to change the test suite (1) as you add new features and make changes to existing features. However, testing is not something I am assessing in DAMS, so I can give you lots of help and advice.

You should not change the Javascript and CSS (6) or the Vagrant setup (7), but can discuss desirable changes with me first. (Where feasible, I will do this work for you, so that you can focus on the more important parts of your assessment).
