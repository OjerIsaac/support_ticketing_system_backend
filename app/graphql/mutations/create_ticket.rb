module Mutations
  class CreateTicket < BaseMutation
    argument :title, String, required: true
    argument :description, String, required: true
    argument :attachment_ids, [ ID ], required: false

    field :ticket, Types::TicketType, null: true
    field :errors, [ String ], null: false

    def resolve(title:, description:, attachment_ids: nil)
      authenticate!
      return { ticket: nil, errors: [ "Only customers can create tickets" ] } unless current_user.customer?

      ticket = current_user.authored_tickets.new(
        title: title,
        description: description,
        status: :open
      )

      if ticket.save
        if attachment_ids.present?
          ActiveStorage::Attachment.where(
            id: attachment_ids,
            record_type: "TempAttachment",
            record_id: current_user.id
          ).update_all(record_type: "Ticket", record_id: ticket.id)
        end
        { ticket: ticket, errors: [] }
      else
        { ticket: nil, errors: ticket.errors.full_messages }
      end
    end
  end
end
