-module(dqe_replace_below_confidence).
-behaviour(dqe_fun).

-include_lib("mmath/include/mmath.hrl").

-export([spec/0, describe/1, init/1, chunk/1, resolution/2, run/2, help/0]).

-record(state, {
          threshold :: number(),
          default_value :: number()
         }).

init([Threshold, DefaultValue]) ->
    #state{threshold = Threshold,
           default_value = DefaultValue}.

chunk(#state{}) ->
    ?RDATA_SIZE.

resolution(_Resolution, State) ->
    {1, State}.

describe(#state{threshold = Threshold, default_value = DefaultValue}) ->
    ["replace_below_confidence(", float_to_list(Threshold), ", ", float_to_list(DefaultValue), ")"].

spec() ->
    {<<"replace_below_confidence">>, [metric, float, float], none, metric}.

run([Data], S = #state{threshold = Threshold, default_value = DefaultValue}) ->
    {mmath_trans:replace_below_confidence(Data, Threshold, DefaultValue), S}.

help() ->
    <<"Replaces the metric equal to or below given threshold with the default value."
      "This can be either applied to raw serieses or aggregates.">>.
