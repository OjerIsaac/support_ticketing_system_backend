module Mutations
  class UpdateTicketStatus < BaseMutation
    argument :id, ID, required: true
    argument :status, String, required: true

    field :ticket, Types::TicketType, null: true
    field :errors, [ String ], null: false

    def resolve(id:, status:)
      authenticate!
      authorize_agent!

      ticket = Ticket.find_by(id: id)
      return { ticket: nil, errors: [ "Ticket not found" ] } unless ticket

      unless Ticket.statuses.keys.include?(status)
        return { ticket: nil, errors: [ "Invalid status" ] }
      end

      if ticket.update(status: status)
        { ticket: ticket, errors: [] }
      else
        { ticket: nil, errors: ticket.errors.full_messages }
      end
    end
  end
end
