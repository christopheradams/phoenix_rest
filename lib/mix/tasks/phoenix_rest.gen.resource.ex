defmodule Mix.Tasks.PhoenixRest.Gen.Resource do
  use Mix.Task

  @shortdoc "Generates a PlugRest resource for Phoenix pre 1.3"

  @moduledoc """
  Generates a PlugRest resource in your Phoenix application.

      mix phoenix_rest.gen.resource UserResource

  The generated resource will contain:

    * a resource file in web/resources
  """
  def run(args) do
    no_umbrella!("phoenix_rest.gen.resource")

    switches = [path: :binary, use: :binary]
    {opts, parsed, _} = OptionParser.parse(args, switches: switches)

    resource =
      case parsed do
        [] -> Mix.raise("phoenix_rest.gen.resource expects a Resource name to be given")
        [resource] -> resource
        [_ | _] -> Mix.raise("phoenix_rest.gen.resource expects a single Resource name")
      end

    default_opts = [path: "web/resources", use: "PhoenixRest.Resource"]
    opts = Keyword.merge(default_opts, opts)

    gen_args = [resource] ++ OptionParser.to_argv(opts)

    Mix.Task.run("plug_rest.gen.resource", gen_args)
  end

  @doc """
  Raises on umbrella application.
  """
  def no_umbrella!(task) do
    if Mix.Project.umbrella?() do
      Mix.raise("Cannot run task #{inspect(task)} from umbrella application")
    end
  end
end
