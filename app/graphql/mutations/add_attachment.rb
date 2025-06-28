module Mutations
  class AddAttachment < BaseMutation
    argument :file, ApolloUploadServer::Upload, required: true

    field :attachment, Types::AttachmentType, null: true
    field :errors, [ String ], null: false

    def resolve(file:)
      authenticate!

      blob = ActiveStorage::Blob.create_and_upload!(
        io: file,
        filename: file.original_filename,
        content_type: file.content_type
      )

      attachment = ActiveStorage::Attachment.create!(
        name: "attachment",
        record_type: "TempAttachment",
        record_id: current_user.id,
        blob: blob
      )

      {
        attachment: {
          id: attachment.id,
          filename: blob.filename,
          content_type: blob.content_type,
          byte_size: blob.byte_size,
          url: Rails.application.routes.url_helpers.rails_blob_url(blob)
        },
        errors: []
      }
    rescue => e
      { attachment: nil, errors: [ e.message ] }
    end
  end
end
