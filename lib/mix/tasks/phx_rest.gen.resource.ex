defmodule Mix.Tasks.PhxRest.Gen.Resource do
  @shortdoc "Generates a PlugRest resource for Phoenix 1.3"

  @moduledoc """
  Generates a PlugRest resource in your Phoenix application.

      mix phx_rest.gen.resource UserResource

  The generator will add the following files to `lib/`:

    * a resource file in lib/my_app_web/resources/user_resource.ex

  To place the resource under `lib/my_app/web` instead, use the `--path` and
  `--namespace` options:

      mix phx_rest.gen.resource UserResource --path "lib/my_app/web/resources" --namespace MyApp.Web

  To create a resource with no tutorial comments:

      mix phx_rest.gen.resource UserResource --no-comments
  """
  use Mix.Task

  def run(args) do
    no_umbrella!("phx_rest.gen.resource")

    switches = [
      use: :string,
      app: :string,
      path: :string,
      namespace: :string,
    ]

    {opts, parsed, _} = OptionParser.parse(args, switches: switches)

    resource =
      case parsed do
        [] -> Mix.raise "phx_rest.gen.resource expects a Resource name to be given"
        [resource] -> resource
        [_ | _] -> Mix.raise "phx_rest.gen.resource expects a single Resource name"
      end

    inflections = Mix.Phoenix.inflect(resource)
    web_module = Keyword.get(inflections, :web_module)

    app_name = Mix.Phoenix.context_app()

    default_opts = [
      namespace: web_module,
      path: "./lib/#{app_name}_web/resources",
      use: "PhoenixRest.Resource"
    ]

    opts = Keyword.merge(default_opts, opts)

    module_name = Module.concat([opts[:namespace], resource])
    Mix.Phoenix.check_module_name_availability!(module_name)

    gen_args = [resource] ++ OptionParser.to_argv(opts)

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
