class AttachmentsController < ApplicationController
    before_action :authenticate_user!

    def create
      @attachment = ActiveStorage::Attachment.create!(
        name: "attachment",
        record_type: "TempAttachment",
        record_id: current_user.id,
        blob: ActiveStorage::Blob.create_and_upload!(
          io: params[:file],
          filename: params[:file].original_filename,
          content_type: params[:file].content_type
        )
      )

      render json: {
        id: @attachment.id,
        filename: @attachment.filename,
        url: rails_blob_url(@attachment.blob)
      }
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def destroy
      @attachment = ActiveStorage::Attachment.find(params[:id])
      if @attachment.record_type == "TempAttachment" && @attachment.record_id == current_user.id
        @attachment.purge
        head :no_content
      else
        render json: { error: "Not authorized" }, status: :forbidden
      end
    end
end
