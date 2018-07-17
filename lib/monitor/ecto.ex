defmodule Monitor.Ecto do
  require Logger
  # in repo.ex
  # use Monitor.Ecto

  # in web.ex
  # alias YourApp.Repo.Tracer, as: Repo


  defmacro __using__(_args) do
    quote unquote: false do
      contents = quote do
        require Logger

        def aggregate(a,b,c) do
          __trace(fn -> unquote(__MODULE__).aggregate(a,b,c) end)
        end

        def aggregate(a,b,c,d) do
          __trace(fn -> unquote(__MODULE__).aggregate(a,b,c,d) end)
        end

        def all(a) do
          __trace(fn -> unquote(__MODULE__).all(a) end)
        end

        def all(a,b) do
          __trace(fn -> unquote(__MODULE__).all(a,b) end)
        end

        def config() do
          __trace(fn -> unquote(__MODULE__).config() end)
        end

        def delete!(a) do
          __trace(fn -> unquote(__MODULE__).delete!(a) end)
        end

        def delete!(a,b) do
          __trace(fn -> unquote(__MODULE__).delete!(a, b) end)
        end

        def delete(a) do
          __trace(fn -> unquote(__MODULE__).delete(a) end)
        end

        def delete(a,b) do
          __trace(fn -> unquote(__MODULE__).delete(a,b) end)
        end

        def delete_all(a) do
          __trace(fn -> unquote(__MODULE__).delete_all(a) end)
        end

        def delete_all(a,b) do
          __trace(fn -> unquote(__MODULE__).delete_all(a,b) end)
        end

        def get!(a,b) do
          __trace(fn -> unquote(__MODULE__).get!(a,b) end)
        end

        def get!(a,b,c) do
          __trace(fn -> unquote(__MODULE__).get!(a,b,c) end)
        end

        def get(a,b) do
          __trace(fn -> unquote(__MODULE__).get(a,b) end)
        end

        def get(a,b,c) do
          __trace(fn -> unquote(__MODULE__).get(a,b,c) end)
        end

        def get_by!(a,b) do
          __trace(fn -> unquote(__MODULE__).get_by!(a,b) end)
        end

        def get_by!(a,b,c) do
          __trace(fn -> unquote(__MODULE__).get_by!(a,b,c) end)
        end

        def get_by(a,b) do
          __trace(fn -> unquote(__MODULE__).get_by(a,b) end)
        end

        def get_by(a,b,c) do
          __trace(fn -> unquote(__MODULE__).get_by(a,b,c) end)
        end

        def in_transaction?() do
          __trace(fn -> unquote(__MODULE__).in_transaction?() end)
        end

        def insert!(a) do
          __trace(fn -> unquote(__MODULE__).insert!(a) end)
        end

        def insert!(a,b) do
          __trace(fn -> unquote(__MODULE__).insert!(a,b) end)
        end

        def insert(a) do
          __trace(fn -> unquote(__MODULE__).insert(a) end)
        end

        def insert(a,b) do
          __trace(fn -> unquote(__MODULE__).insert(a,b) end)
        end

        def insert_all(a,b) do
          __trace(fn -> unquote(__MODULE__).insert_all(a,b) end)
        end

        def insert_all(a,b,c) do
          __trace(fn -> unquote(__MODULE__).insert_all(a,b,c) end)
        end

        def insert_or_update!(a) do
          __trace(fn -> unquote(__MODULE__).insert_or_update!(a) end)
        end

        def insert_or_update!(a,b) do
          __trace(fn -> unquote(__MODULE__).insert_or_update!(a,b) end)
        end

        def insert_or_update(a) do
          __trace(fn -> unquote(__MODULE__).insert_or_update(a) end)
        end

        def insert_or_update(a,b) do
          __trace(fn -> unquote(__MODULE__).insert_or_update(a,b) end)
        end

        def load(a,b) do
          __trace(fn -> unquote(__MODULE__).load(a,b) end)
        end

        def one!(a) do
          __trace(fn -> unquote(__MODULE__).one!(a) end)
        end

        def one!(a,b) do
          __trace(fn -> unquote(__MODULE__).one!(a,b) end)
        end

        def one(a) do
          __trace(fn -> unquote(__MODULE__).one(a) end)
        end

        def one(a,b) do
          __trace(fn -> unquote(__MODULE__).one(a,b) end)
        end

        def preload(a,b) do
          __trace(fn -> unquote(__MODULE__).preload(a,b) end)
        end

        def preload(a,b,c) do
          __trace(fn -> unquote(__MODULE__).preload(a,b,c) end)
        end

        def query!(a) do
          __trace(fn -> unquote(__MODULE__).query!(a) end)
        end

        def query!(a,b) do
          __trace(fn -> unquote(__MODULE__).query!(a,b) end)
        end

        def query!(a,b,c) do
          __trace(fn -> unquote(__MODULE__).query!(a,b,c) end)
        end

        def query(a) do
          __trace(fn -> unquote(__MODULE__).query(a) end)
        end

        def query(a,b) do
          __trace(fn -> unquote(__MODULE__).query(a,b) end)
        end

        def query(a,b,c) do
          __trace(fn -> unquote(__MODULE__).query(a,b,c) end)
        end

        def rollback(a) do
          __trace(fn -> unquote(__MODULE__).rollback(a) end)
        end

        def stop(a) do
          __trace(fn -> unquote(__MODULE__).stop(a) end)
        end

        def stop(a,b) do
          __trace(fn -> unquote(__MODULE__).stop(a,b) end)
        end

        def stream(a) do
          __trace(fn -> unquote(__MODULE__).stream(a) end)
        end

        def stream(a,b) do
          __trace(fn -> unquote(__MODULE__).stream(a,b) end)
        end

        def transaction(a) do
          __trace(fn -> unquote(__MODULE__).transaction(a) end)
        end

        def transaction(a,b) do
          __trace(fn -> unquote(__MODULE__).transaction(a,b) end)
        end

        def update!(a) do
          __trace(fn -> unquote(__MODULE__).update!(a) end)
        end

        def update!(a,b) do
          __trace(fn -> unquote(__MODULE__).update!(a,b) end)
        end

        def update(a) do
          __trace(fn -> unquote(__MODULE__).update(a) end)
        end

        def update(a,b) do
          __trace(fn -> unquote(__MODULE__).update(a,b) end)
        end

        def update_all(a,b) do
          __trace(fn -> unquote(__MODULE__).update_all(a,b) end)
        end

        def update_all(a,b,c) do
          __trace(fn -> unquote(__MODULE__).update_all(a,b,c) end)
        end

        defp __trace(f) do
          started_at = System.monotonic_time(:microseconds)
          res=f.()
          ended_at = System.monotonic_time(:microseconds)
          duration_in_ms = (ended_at-started_at)/1000
          #IO.puts("\nQuery duration in ms: #{inspect(duration_in_ms)}\n")
          log_entry = Process.get(:ecto_log_entry)
          if (duration_in_ms >= 500) do
            {:current_stacktrace, trace} = Process.info(self(), :current_stacktrace)
            trace = __sanitize_trace(trace)
            Logger.info("Slow Query!\n\s\s\s\s#{log_entry.query}\n\s\s\s\s#{duration_in_ms} ms\n#{Exception.format_stacktrace(trace)}")
          end
          res
        end

        # Removes the Process and __MODULE__ from the trace so we're starting with app-level, custom code.
        defp __sanitize_trace(trace) do
          Enum.filter(trace, fn(trace_entry) ->
            case trace_entry do
              {Process,_,_,_}    -> false
              {__MODULE__,_,_,_} -> false
              _ -> true
            end
          end)
        end
      end
      tracer_repo_module =
        __MODULE__
        |> Atom.to_string
        |> (Kernel.<> ".Tracer")
        |> String.to_atom

      Module.create(tracer_repo_module, contents, __ENV__)
    end
  end
end
