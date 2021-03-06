##Reference examples for add_env
Any parameter (command, switch, option, argument) or task can call the `add_env` method. The context of the `add_env` method call and additional method calls determine its behavior. The only location where `add_env` is not available is under an existing `add_env` method call.

###A user (Task Author) wants the rake task consumer to provide input

#### Stopping and asking for an environment variable that represents an argument to an --option.
This task will produce an error if the environment variable `ARG_OVERRIDE` does not have a value because no default is provided,
and no implicit default is set as this environment variables `parent` (arg) does not have a name.
&nbsp;

    desc "a command that will stop"
    rototiller_task :stop do |task|
      task.add_command do |cmd|
        cmd.name = 'echo command_name'
        cmd.add_option do |o|
          o.name = '--option'
          o.add_argument do |arg|
            arg.add_env({ :name => 'ARG_OVERRIDE', :message => 'message at the env for argument' })
          end
        end
      end
    end


#### Stopping and asking for an Environment variable that is not related to a command
Because a task has a name that would not be implicitly useful as the default value for a task's arbitrary environment variable, this will produce an error if `SOME_TASK_VAR` does not have a value when the task is run.
&nbsp;

    desc "a command that will stop"
    rototiller_task :stop do |task|

      task.add_env({ :name => 'SOME_TASK_VAR' })

      task.add_command do |cmd|
        cmd.name = 'echo this command might use SOME_TASK_VAR'
        cmd.add_option do |o|
          o.name = '--option'
          o.add_argument do |arg|
            arg.name = 'argument'
          end
        end
      end
    end


###A task author wants to supply a default value
In all of the examples below the environment variable `OPTION_ARGUMENT` can be used to override the argument passed to the option `--option`
In these cases, if the environment variable is not set on the system, rototiller will set it so tasks or commands can make use of it, as required.

An explicit default is supplied to argument via `add_env`
&nbsp;

    desc "a command that has an environment variable with a default value for an option argument"
    rototiller_task :default do |task|
      task.add_command do |cmd|
        cmd.name = 'echo command_name'
        cmd.add_option do |o|
          o.name = '--option'
          o.add_argument do |arg|
            arg.add_env do |env|
              env.name    = 'OPTION_ARGUMENT'
              env.default = 'this_is_the_default'
            end
          end
        end
      end
    end


An implicit default is supplied to argument via the parent parameters `name`
&nbsp;

    desc "a command that has a default for an option argument"
    rototiller_task :default do |task|
      task.add_command do |cmd|

        cmd.name = 'echo command_name'
        cmd.add_option do |o|
          o.name = '--option'
          o.add_argument do |arg|
            arg.name = 'this_is_the_default'
            arg.add_env do |env|
              env.name = 'OPTION_ARGUMENT'
            end
          end
        end
      end
    end


The value of `default` is preferred over 'name'.  In this example the default value to the --option <argument> will be 'this_is_the_default'
&nbsp;

    desc "a command that has a default for an option argument"
    rototiller_task :default do |task|
      task.add_command do |cmd|

        cmd.name = 'echo command_name'
        cmd.add_option do |o|
          o.name = '--option'
          o.add_argument do |arg|
            arg.name = 'this_is_the_name'
            arg.add_env do |env|
              env.name    = 'OPTION_ARGUMENT'
              env.default = 'this_is_the_default'
            end
          end
        end
      end
    end
