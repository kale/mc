desc 'Ecomm related actions'

command :ecomm do |c|
  c.desc 'Import Ecommerce Order Information to be used for Segmentation'
  c.command :add do |s|
    s.flag :order_id
    s.flag :campaign_id
    s.flag :email_id
    s.flag :email
    s.flag :total
    s.flag :order_date
    s.flag :shipping
    s.flag :tax
    s.flag :store_id
    s.flag :stoe_name

    s.action do |global,options,args|
      order = {}
      order[:id] = options[:order_id]
      order[:email_id] = options[:email_id]
      order[:email] = options[:email]
      order[:total] = options[:total]
      order[:order_date] = options[:order_date]
      order[:shipping] = options[:shipping]
      order[:tax] = options[:tax]
      order[:store_id] = options[:store_id]
      order[:store_name] = options[:store_name]
      order[:items] = [{:product_id => 500, :product_name => "Freddie Doll", :category_id => 1, :category_name => "Toys"}]

      if @mailchimp.ecomm_order_add :order => order
        puts "Order added!"
      else
        puts "Order not added. :("
      end
    end
  end
end
