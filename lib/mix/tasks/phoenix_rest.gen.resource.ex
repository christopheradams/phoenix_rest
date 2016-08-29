defmodule Mix.Tasks.PhoenixRest.Gen.Resource do
  use Mix.Task

  @shortdoc "Generates a PlugRest resource for Phoenix"

  @moduledoc """
  Generates a PlugRest resource in your Phoenix application.

      mix phoenix_rest.gen.resource UserResource

  The generated resource will contain:

    * a resource file in web/resources

  The resources target directory can be changed with the option:

      mix phoenix_rest.gen.resource UserResource --dir "lib/my_app/resources"
  """
  def run(args) do
    no_umbrella!("phoenix_rest.gen.resource")

    switches = [dir: :binary, use: :binary]
    {opts, parsed, _} = OptionParser.parse(args, switches: switches)

    resource =
      case parsed do
        [] -> Mix.raise "phoenix_rest.gen.resource expects a Resource name to be given"
        [resource] -> resource
        [_ | _] -> Mix.raise "phoenix_rest.gen.resource expects a single Resource name"
      end

    default_opts = [dir: "web/resources"]
    opts = Keyword.merge(default_opts, opts)

    gen_args = [resource] ++ OptionParser.to_argv(opts)

    Mix.Tasks.PlugRest.Gen.Resource.run(gen_args)
  end

  @doc """
  Raises on umbrella application.
  """
  def no_umbrella!(task) do
    if Mix.Project.umbrella? do
      Mix.raise "Cannot run task #{inspect task} from umbrella application"
    end
  end
end
