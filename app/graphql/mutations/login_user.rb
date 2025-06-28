module Mutations
  class LoginUser < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :user, Types::UserType, null: true
    field :errors, [ String ], null: false

    def resolve(email:, password:)
      user = User.find_for_database_authentication(email: email)

      if user&.valid_password?(password)
        {
          token: user.generate_jwt,
          user: user,
          errors: []
        }
      else
        {
          token: nil,
          user: nil,
          errors: [ "Invalid email or password" ]
        }
      end
    end
  end
end
