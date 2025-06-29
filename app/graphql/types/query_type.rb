# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ ID ], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :tickets, Types::TicketsResultType, null: false do
      argument :page, Integer, required: true
      argument :per_page, Integer, required: true
      argument :is_agent, Boolean, required: true
    end

    field :ticket, Types::TicketType, null: true do
      description "Fetch a single ticket by its ID"
      argument :id, ID, required: true
    end

    def ticket(id:)
      Ticket.find_by(id: id)
    end

    def tickets(page: 1, per_page: 10, is_agent: false)
      scope = Ticket.all

      unless is_agent
        # e.g., if you want to only show current_user tickets
        scope = scope.where(customer_id: context[:current_user].id)
      end

      {
        items: scope
          .order(created_at: :desc)
          .limit(per_page)
          .offset((page - 1) * per_page),
        total_count: scope.count
      }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end
  end
end
