defmodule Mix.Tasks.PhxRest.Gen.Resource do
  use Mix.Task

  @shortdoc "Generates a PlugRest resource for Phoenix 1.3"

  @moduledoc """
  Generates a PlugRest resource in your Phoenix application.

      mix phx_rest.gen.resource UserResource

  The generated resource will contain:

    * a resource file in web/resources

  The resource file path can be set with the option:

      mix phx_rest.gen.resource UserResource --path "lib/my_app/resources"
  """
  def run(args) do
    no_umbrella!("phx_rest.gen.resource")

    switches = [dir: :binary, use: :binary]
    {opts, parsed, _} = OptionParser.parse(args, switches: switches)

    resource =
      case parsed do
        [] -> Mix.raise "phx_rest.gen.resource expects a Resource name to be given"
        [resource] -> resource
        [_ | _] -> Mix.raise "phx_rest.gen.resource expects a single Resource name"
      end

    module_name = "Web." <> resource

    app_name = Mix.Project.config |> Keyword.get(:app) |> Atom.to_string

    [Mix.Phoenix.base(), module_name]
    |> Module.concat()
    |> Mix.Phoenix.check_module_name_availability!()

    default_opts = [path: "./lib/#{app_name}/web/resources/#{resource}.ex", use: "PhoenixRest.Resource"]
    opts = Keyword.merge(default_opts, opts)

    gen_args = [module_name] ++ OptionParser.to_argv(opts)

    Mix.Task.run("plug_rest.gen.resource", gen_args)
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
