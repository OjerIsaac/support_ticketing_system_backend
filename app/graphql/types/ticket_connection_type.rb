# frozen_string_literal: true

module Types
  class TicketConnectionType < Types::BaseObject
    description "A paginated list of tickets"

    field :items, [ Types::TicketType ], null: false
    field :total_count, Integer, null: false
  end
end
