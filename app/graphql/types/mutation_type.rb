module Types
  class MutationType < Types::BaseObject
    field :add_attachment, mutation: Mutations::AddAttachment
    field :create_ticket, mutation: Mutations::CreateTicket
    field :assign_ticket, mutation: Mutations::AssignTicket
    field :login_user, mutation: Mutations::LoginUser
    field :create_comment, mutation: Mutations::CreateComment
    field :update_ticket_status, mutation: Mutations::UpdateTicketStatus
  end
end
