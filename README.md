# Runtime Config com Distillery e Phoenix

Esse repositório é um demo da capacidade de setar configurações do Elixir em
_run time_ com [Mix Config Provider](https://hexdocs.pm/distillery/config/runtime.html#mix-config-provider) disponível no Distillery 2.0+

## Funcionamento

Ao rodar a aplicação com `mix phx.server`, o endpoint `/api` mostrará um JSON
com duas chaves:

```json
{
    "from_dynamic_env": "config not found",
    "from_file": "hello!",
    "from_regular_env": "config not found"
}
```

Essas duas chaves são lidas de configurações da aplicação em 

```elixir
%{
    from_file: Application.get_env(:phoenix_distillery, :from_file),
    from_regular_env: Application.get_env(:phoenix_distillery, :from_regular_env),
    from_dynamic_env: Application.get_env(:phoenix_distillery, :from_dynamic_env)
}
```

Elas são todas configuradas da forma usual, em `config.exs`:

```elixir
config :phoenix_distillery,
  from_file: "hello!",
  from_dynamic_env: System.get_env("COOL_CONFIG", "config not found"),
  from_regular_env: System.get_env("COOL_CONFIG", "config not found")
```


## Executando a Release

Observe como as configuração `from_dynamic_env` e `from_regular_env` leem a mesma
variávei de ambiente `COOL_CONFIG`. Defina essa variável para algum valor e faça
a release:

```sh
export COOL_CONFIG="valor em build!"
export MIX_ENV=prod
mix deps.get --only prod
mix compile
mix distillery.release
```

Execute a aplicação que foi compilada:

```sh
_build/prod/rel/phoenix_distillery/bin/phoenix_distillery foreground
```

Invocar a aplicação agora com `curl localhost:4000/api/` deve retornar

```json
{
    "from_dynamic_env": "valor em build!",
    "from_file": "hello!",
    "from_regular_env": "valor em build!"
}
```

Se você interromper a aplicação, mudar o valor da env e rodar de novo:

```sh
export COOL_CONFIG="valor em execução!"
_build/prod/rel/phoenix_distillery/bin/phoenix_distillery foreground
```

O retorno agora deverá ser

```json
{
    "from_dynamic_env": "valor em execução!",
    "from_file": "hello!",
    "from_regular_env": "valor em build!"
}
```

Observe como o valor de uma das configs lida da variável de ambiente `COOL_CONFIG`
foi atualizada mas a outra não.

## Detalhes da Configuração

Essa configuração dinâmica foi possível por conta de `rel/config.exs`:

```elixir
environment :prod do

  #...

  set config_providers: [
    {Distillery.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
  ]
  set overlays: [
    {:copy, "rel/config/config.exs", "etc/config.exs"}
  ]
end
```

O arquivo `rel/config/config.exs` redefine a configuração `from_dynamic_env`:

```elixir
config :phoenix_distillery, :from_dynamic_env, System.get_env("COOL_CONFIG", "config not found")
```

Esse arquivo de configuração vai ser lido **no momento do boot** e o valor de `from_dynamic_env`
vai ser substituído no valor definido no momento do build. Ao atualizar a variável de ambiente,
é necessário reiniciar a aplicação.