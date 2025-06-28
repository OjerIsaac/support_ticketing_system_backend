module Mutations
  class AssignTicket < BaseMutation
    argument :ticket_id, ID, required: true
    argument :agent_id, ID, required: false

    field :ticket, Types::TicketType, null: true
    field :errors, [ String ], null: false

    def resolve(ticket_id:, agent_id: nil)
      authenticate!
      authorize_agent!

      ticket = Ticket.find_by(id: ticket_id)
      return { ticket: nil, errors: [ "Ticket not found" ] } unless ticket

      if agent_id
        agent = User.agent.find_by(id: agent_id)
        return { ticket: nil, errors: [ "Agent not found" ] } unless agent
      end

      if ticket.update(agent_id: agent_id)
        { ticket: ticket, errors: [] }
      else
        { ticket: nil, errors: ticket.errors.full_messages }
      end
    end
  end
end
