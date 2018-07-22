json.extract! cliente, :id, :nome, :cpf, :email, :endereco, :user_id, :created_at, :updated_at
json.url cliente_url(cliente, format: :json)
