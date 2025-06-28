module Mutations
  class CreateComment < BaseMutation
    argument :ticket_id, ID, required: true
    argument :content, String, required: true
    argument :attachment_ids, [ ID ], required: false

    field :comment, Types::CommentType, null: true
    field :errors, [ String ], null: false

    def resolve(ticket_id:, content:, attachment_ids: nil)
      authenticate!

      ticket = Ticket.find_by(id: ticket_id)
      return { comment: nil, errors: [ "Ticket not found" ] } unless ticket

      unless ticket.can_comment?(current_user)
        return { comment: nil, errors: [ "Not authorized to comment on this ticket" ] }
      end

      comment = ticket.comments.new(
        user: current_user,
        content: content
      )

      if comment.save
        if attachment_ids.present?
          ActiveStorage::Attachment.where(
            id: attachment_ids,
            record_type: "TempAttachment",
            record_id: current_user.id
          ).update_all(record_type: "Comment", record_id: comment.id)
        end
        { comment: comment, errors: [] }
      else
        { comment: nil, errors: comment.errors.full_messages }
      end
    end
  end
end
