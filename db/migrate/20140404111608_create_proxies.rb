class CreateProxies < ActiveRecord::Migration
  def change
    create_table :proxies do |t|
      t.string :proxy_addr
      t.integer :proxy_port

      t.timestamps
    end
  end
end
