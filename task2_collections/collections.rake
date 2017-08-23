namespace :collections do
  task :add_apple_to_basket => :environment do |task, args|
    count_num = ENV['count'].to_i
    return false if (count_num == 0) #Incase count is '0' returns
    baskets = Basket.select(:id, :capacity)
    baskets.each do |basket|
      #1: Basket that has 0 or is filled with at least 1 apple of the same sort as the variety argument
      zeroOrOne = Apple.where(["basket_id = ? and variety = ?", basket.id, ENV['variety']]) 
      puts "Available basket ID with zero or one is #{basket.id}" if(zeroOrOne.count < 2) unless zeroOrOne.empty?
      #2: Create as many apple records as passed it is passed as count argument
      apple_count = Apple.where(["basket_id = ?", basket.id]).count
      #4: If the selected basket is full the remainder of apples should be carried over to the next basket
      if (apple_count == basket.capacity)
        break;
      else
        while(apple_count <= basket.capacity)
          return false if (count_num <= 0)
          #3: Basket has a new apple the fill_rate should be re-calculated as a % of count of associated records divided by capacity of the basket
          fill_rate = apple_count/basket.capacity * 100;
          Apple.new(basket_id: basket.id, variety:ENV['variety']).save
          count_num -= 1
          response = Basket.where(id: basket.id).update_all(fill_rate: fill_rate)
          apple_count += 1
        end #While end
      end #If end
    end # do end
    #5: If no baskets are available
    puts "All baskets are full. We couldn't find the place for [#{count_num}] apples" if (count_num > 0)
  end
end