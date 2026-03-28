class CreateRefreshTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :refresh_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token_digest
      t.datetime :expires_at
      t.boolean :revoked

      t.timestamps
    end
  end
end
