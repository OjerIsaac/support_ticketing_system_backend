module Types
  class TicketsResultType < Types::BaseObject
    field :items, [ Types::TicketType ], null: false
    field :total_count, Integer, null: false
  end
end
