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
      order[:id] = required_option(:order_id, options[:order_id])
      order[:campaign_id] = options[:campaign_id]
      order[:email_id] = options[:email_id]
      order[:email] = options[:email]
      order[:total] = options[:total]
      order[:order_date] = options[:order_date]
      order[:shipping] = options[:shipping]
      order[:tax] = options[:tax]
      order[:store_id] = required_option(:store_id, options[:store_id])
      order[:store_name] = options[:store_name]
      order[:items] = [{:product_id => 500, :product_name => "Freddie Doll", :category_id => 1, :category_name => "Toys"}]

      if @mailchimp.ecomm_order_add :order => order
        puts "Order added!"
      else
        puts "Order not added. :("
      end
    end
  end

  c.desc 'Delete Ecommerce Order Information used for segmentation'
  c.command :delete do |s|
    s.flag :store_id
    s.flag :order_id

    s.action do |global,options,args|
      if @mailchimp.ecomm_order_del(:store_id => required_option(:store_id, options[:store_id]), :order_id => required_option(:order_id, options[:order_id]))
        puts "Order deleted!"
      else
        puts "Order not deleted. :("
      end
    end
  end

  c.desc 'Retrieve the Ecommerce Orders for an account'
  c.command :orders do |s|
    s.action do |global,options,args|
      @output.standard @mailchimp_cached.ecomm_orders['data'], :fields => [:store_id, :store_name, :order_id, :campaign_id, :email, :order_total, :order_date]
    end
  end
end
