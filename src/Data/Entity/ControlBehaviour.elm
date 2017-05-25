module Data.Entity.ControlBehaviour exposing (..)

import Data.Signal exposing (Signal)
import Json.Decode exposing (..)


type alias ControlBehaviour =
    {}


type Condition
    = ArtihmeticConditions {}
    | DeciderConditions {}
    | CircuitConditions {}
    | Filters {}
    | LogisticCondition {}
    | RailCondition {}
    | InserterCondition {} 


--  "arithmetic_conditions": {
--                         "first_signal": {
--                             "type": "virtual",
--                             "name": "signal-each"
--                         },
--                         "constant": 0,
--                         "operation": "+",
--                         "output_signal": {
--                             "type": "virtual",
--                             "name": "signal-each"
--                         }
--                     }


-- "decider_conditions": {
--                         "first_signal": {
--                             "type": "virtual",
--                             "name": "signal-P"
--                         },
--                         "constant": 3000,
--                         "comparator": ">",
--                         "output_signal": {
--                             "type": "virtual",
--                             "name": "signal-everything"
--                         },
--                         "copy_count_from_input": true
--                     }


--  "circuit_condition": {
--                         "first_signal": {
--                             "type": "virtual",
--                             "name": "signal-P"
--                         },
--                         "constant": 0,
--                         "comparator": ">"
--                     }


-- "filters": [
--                         {
--                             "signal": {
--                                 "type": "virtual",
--                                 "name": "signal-count"
--                             },
--                             "count": 1,
--                             "index": 1
--                         },
--                         {
--                             "signal": {
--                                 "type": "virtual",
--                                 "name": "vehicle-hauler-_-signal"
--                             },
--                             "count": 1,
--                             "index": 2
--                         },


-- circuit_mode_of_operation : 1

-- available_construction_output_signal, available_logistic_output_signal, total_construction_output_signal, total_logistic_output_signal




-- circuit_close_signal
-- :
-- true

-- circuit_read_signal
-- :
-- true

-- green_output_signal, orange_output_signal , red_output_signal


-- connect_to_logistic_network = True, circuit_enable_disable = True, read_from_train = True, read_stopped_train = True, train_stopped_signal = { type = "virtual", name = "signal-T" }

-- logistic_condition = { first_signal = { type = "item", name = "copper-ore" }, constant = 0, comparator = ">" }

-- circuit_contents_read_mode
-- :
-- 0

-- circuit_read_hand_contents
-- :
-- true

-- circuit_enable_disable
-- :
-- true

-- circuit_set_stack_size
-- :
-- true
-- stack_control_input_signal
-- : Signal
