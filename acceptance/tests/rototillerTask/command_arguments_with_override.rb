require 'beaker/hosts'
require 'rakefile_tools'
require 'test_utilities'

test_name 'C97824: can set command arguments in a RototillerTask' do
  extend Beaker::Hosts
  extend RakefileTools
  extend TestUtilities

  step 'Test command with an override_env that has a value' do

    override_env = unique_env_on(sut)
    argument_override_env = unique_env_on(sut)
    env_key = 'THIS_WAS_IN_ENV'
    argument_env_key = 'THIS_WAS_THE_ARG_IN_THE_ENV'
    env_value = 'echo ' << env_key

    default_arg = 'HANKVENTURE'

    @task_name    = 'command_with_args_and_defaults'
    rakefile_contents = <<-EOS
#{rototiller_rakefile_header}
rototiller_task :#{@task_name} do |t|
    t.add_command({:name => 'echo', :override_env => '#{override_env}', :argument => '#{default_arg}', :argument_override_env => '#{argument_override_env}'})
end
    EOS

    rakefile_path = create_rakefile_on(sut, rakefile_contents)

    sut.add_env_var(override_env, env_value)
    sut.add_env_var(argument_override_env, argument_env_key)

    execute_task_on(sut, @task_name, rakefile_path) do |result|
      # command was used that was supplied by the override_env
      assert_match(/^#{env_key} #{argument_env_key}/, result.stdout, 'The correct command was not observed')
    end
  end

  step 'Add Command with block syntax and unset override_env' do

    override_env = unique_env_on(sut)
    @task_name    = 'command_with_args_and_defaults'

    validation_string = random_string
    argument_validation_string = random_string

    rakefile_contents = <<-EOS
#{rototiller_rakefile_header}
rototiller_task :#{@task_name} do |t|
    t.add_command do |c|
      c.name = 'echo #{validation_string}'
      c.override_env = '#{override_env}'
      c.argument = '#{argument_validation_string}'
      c.argument_override_env = '#{override_env}'
    end
end
    EOS
    rakefile_path = create_rakefile_on(sut, rakefile_contents)

    execute_task_on(sut, @task_name, rakefile_path) do |result|
      command_regex = /#{validation_string} #{argument_validation_string}/
      assert_match(command_regex, result.stdout, 'The correct command was not observed')
    end
  end
end
