Sequel.migration do
  change do
    create_table(:ads) do
      primary_key :id, type: :Bignum

      column :user_id, :Bignum, null: false
      column :title, "character varying", null: false
      column :description, "text", null: false
      column :city, "character varying", null: false
      column :lat, "double precision"
      column :lon, "double precision"
      column :created_at, "timestamp(6) without time zone", null: false
      column :updated_at, "timestamp(6) without time zone", null: false

      index [:user_id], name: :index_ads_on_user_id
    end
  end
end
