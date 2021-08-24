# Intro to Rake

## Learning Goals

- Introduce Rake and Rake tasks
- Understand what Rake is used for in our Ruby programs
- Learn how to build a basic Rake task

## Introduction

Rake is a tool that is available to us in Ruby that allows us to automate
certain jobs — anything from executing SQL to `puts`-ing out a friendly message
to the terminal.

Rake allows us to define something called **Rake tasks** that execute these
jobs. Once we define a task, that task can be executed from the command line.

Rake tasks have a similar utility to npm scripts in JavaScript, which you'd see
in the `package.json` file, like `npm start` or `npm test`. They give you an
easy way to run common tasks from the command line.

## Why Rake?

Every program has some tasks that must be executed now and then. For example,
the task of creating a database table, the task of making or maintaining certain
files. Before Rake was invented, we would have to write standalone bash scripts
that accomplish these tasks, or we would have to make potentially confusing and
arbitrary decisions about what segment of our Ruby program would be responsible
for executing these tasks.

Writing scripts in bash is tough, and bash just isn't as powerful as Ruby. On
the other hand, for each developer to make his or her own decisions about where
to define and execute certain common tasks related to databases or file
maintenance is confusing.

Rake provides us a standard, conventional way to define and execute such tasks
using Ruby.

## Where did Rake Come From?

In fact, the C community was the first to implement the pattern of writing all
their recurring system maintenance tasks in a separate file. They called this
file the MakeFile because it was generally used to gather all of the source
files and make it into one compiled executable file.

Rake was later developed by [Jim Weirich][jim weirich] as the task management
tool for Ruby.

## How to Define and Use Rake Tasks

Building a Rake task is easy. All we need to do is create a file in the top
level of our directory called `Rakefile`. Here we define our task:

```rb
task :hello do
  # the code we want to be executed by this task
end
```

We define tasks with `task` + `name of task as a symbol` + a block that contains
the code we want to execute.

If you open up the `Rakefile` in this directory, you'll see our `:hello` task:

```rb
task :hello do
  puts "hello from Rake!"
end
```

Now, in your terminal in the directory of this project, type:

```console
$ rake hello
hello from Rake!
```

You should see the text above outputted to your terminal.

### Describing our Tasks With `rake -T`

Rake comes with a handy command, `rake -T`, that we can run in the terminal to
view a list of available Rake tasks and their descriptions. In order for
`rake -T` to work though, we need to give our Rake tasks descriptions. Let's
give our `hello` task a description now:

```rb
desc 'outputs hello to the terminal'
task :hello do
  puts "hello from Rake!"
end
```

Now, if we run `rake -T` in the terminal, we should see the following:

```console
$ rake -T
rake hello       # outputs hello to the terminal
```

So handy!

### Namespacing Rake Tasks

It is possible to namespace your Rake tasks. What does "namespace" mean? A
namespace is really just a way to group or contain something, in this case our
Rake tasks. So, we might namespace a series of greeting Rake tasks, like `hello`
above, under the `greeting` heading.

Let's take a look at namespacing now. Let's say we create another greeting-type
Rake task, `hola`:

```rb
desc 'outputs hola to the terminal'
task :hola do
  puts "hola de Rake!"
end
```

Now, let's namespace both `hello` and `hola` under the `greeting` heading:

```rb
namespace :greeting do
desc 'outputs hello to the terminal'
  task :hello do
    puts "hello from Rake!"
  end

  desc 'outputs hola to the terminal'
  task :hola do
    puts "hola de Rake!"
  end
end
```

Now, to use either of our Rake tasks, we use the following syntax:

```console
$ rake greeting:hello
hello from Rake!

$ rake greeting:hola
hola de Rake!
```

## `bundle exec rake`

One common issue with Rake is the following: you run a Rake task, like
`rake greeting:hello`, and see an output like this:

```console
$ rake greeting:hello
rake aborted!
Gem::LoadError: You have already activated rake 10.4.2,
but your Gemfile requires rake 10.4.0.
Prepending `bundle exec` to your command may solve this.
```

This is a very common thing to see as a Ruby developer, and luckily, there's an
easy fix if you do happen to see this error message. Just follow the
instructions, and "prepend" `bundle exec` to your rake command:

```console
$ bundle exec rake greeting:hello
hello from Rake!
```

While it is a bit of extra typing, we can tell you from experience, it's
worth the effort once you start encountering this issue. If you're
curious as to why, check out this article:

- [But I Don't Want to `bundle exec`](https://thoughtbot.com/blog/but-i-dont-want-to-bundle-exec)

We suggest you get in the habit of using `bundle exec` with your Rake commands.

## Common Rake Tasks

As we move towards developing Sinatra and Rails web applications, you'll begin
to use some common Rake tasks that handle certain database-related jobs. We'll
be using a gem to setup some of these tasks for us, but it's still helpful to
get an understanding of the syntax of Rake tasks so you can create your own.

### `rake db:migrate`

One common pattern you'll soon become familiar with is the pattern of writing
code that creates database tables and then "migrating" that code using a rake
task.

Our `Student` class currently has a `#create_table` method, so let's use that
method to build out our own `migrate` Rake task.

> **Note**: This lesson doesn't use Active Record, so the functionality of
> interacting with the database is all handled within the Student class, like
> when we were creating our own ORMs.

We'll namespace this task under the `db` heading. This namespace will contain a
few common database-related tasks.

We'll call this task `migrate`, because it is a convention to say we are
"migrating" our database by applying SQL statements that alter that database.

```rb
namespace :db do
  desc 'migrate changes to your database'
  task migrate: :environment do
    Student.create_table
  end
end
```

But, if we run `rake db:migrate` now, we're going to hit an error.

#### Task Dependency

You might be wondering what is happening with this snippet:

```rb
task migrate: :environment do
```

This creates a _task dependency_. Since our `Student.create_table` code would
require access to the `config/environment.rb` file (which is where the student
class and database are loaded), we need to give our task access to this file. In
order to do that, we need to define yet another Rake task that we can tell to
run before the `migrate` task is run.

Let's check out that `environment` task:

```rb
# in Rakefile

task :environment do
  require_relative './config/environment'
end
```

After adding our environment task, running `bundle exec rake db:migrate` should
create our students table.

### `rake db:seed`

Another task you will become familiar with is the `seed` task. This task is
responsible for "seeding" our database with some dummy data.

The conventional way to seed your database is to have a file in the `db`
directory, `db/seeds.rb`, that contains some code to create instances of your
class.

If you open up `db/seeds.rb` you'll see the following code to create a few
students:

```rb
Student.create(name: "Melissa", grade: "10th")
Student.create(name: "April", grade: "10th")
Student.create(name: "Luke", grade: "9th")
Student.create(name: "Devon", grade: "11th")
Student.create(name: "Sarah", grade: "10th")
```

Then, we define a rake task that executes the code in this file. This task will
also be namespaced under `db`:

```rb
namespace :db do

  # ...

  desc 'seed the database with some dummy data'
  task seed: :environment do
    require_relative './db/seeds'
  end
end
```

Now, if we run `bundle exec rake db:seed` in our terminal (provided we have
already run `rake db:migrate` to create the database table), we will insert five
records into the database.

If only there was some way to interact with our class and database without
having to run our entire program...

Well, we can build a Rake task that will load up a Pry console for us.

### `rake console`

We'll define a task that starts up the Pry console. We'll make this task
dependent on our `environment` task so that the `Student` class and the database
connection load first. Note that this class is _not_ namespaced under `:db`,
since we'll use it as a more general-purpose tool.

```rb
desc 'drop into the Pry console'
task console: :environment do
  Pry.start
end
```

Now, provided we ran `rake db:migrate` and `rake db:seed`, we can drop into our
console with the following:

```console
$ bundle exec rake console
```

This should bring you into a Pry session in your terminal:

```console
[1] pry(main)>
```

Let's check to see that we did in fact successfully migrate and seed our
database:

```rb
Student.all
# => [[1, "Melissa", "10th"],
#  [2, "April", "10th"],
#  [3, "Luke", "9th"],
#  [4, "Devon", "11th"],
#  [5, "Sarah", "10th"]]
```

We did it!

## Conclusion

As developers, we are constantly iterating and experimenting on our code. To
make our lives easier, it's helpful to use a tool like Rake to automate some of
the common setup and testing tasks we need to run in order to interact with our
applications. Using Rake is a great way to speed up your development process —
any time you find yourself running the same code over and over again, consider
setting up a Rake task for it.

## Resources

- [The Rake Gem](https://github.com/ruby/rake)
- [Writing Custom Rake Tasks](https://www.seancdavis.com/blog/how-to-write-a-custom-rake-task/)

[jim weirich]: https://en.wikipedia.org/wiki/Jim_Weirich
