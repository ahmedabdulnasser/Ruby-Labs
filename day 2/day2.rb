module Logger
    def self.method_missing(name, *args)
        if name.to_s.start_with?("log_")
            log_type = name.to_s.split("_")[1]
            timestamp = Time.now()
            user = args[0]
            transaction = args[1]
            transaction_msg = transaction ? "transaction with value #{transaction}" : ""
            reason = args[2] || ''
            processing = args[3]
            log_message = "#{timestamp} -- #{log_type} -- #{user ? "User #{user} " : ""}#{transaction ? "transaction with value #{transaction} " : ""}#{!reason.empty? ? "with reason #{reason} " : ""}#{processing}".strip

            open('app.logs', 'a') do |f|
            f.puts(log_message)
            end
        else 
            raise NoMethodError
        end
    end
end

class User 
    attr_accessor :name, :balance
    def initialize (name, balance)
        @name = name
        @balance = balance
    end
end

class Transaction
    attr_reader :user, :value
    def initialize(user, value)
        @user = user
        @value = value


    end
end

class Bank 
    attr_reader :users

    def process_transactions(*transactions, &block)
        raise NotImplementedError
    end
end

class CBABank < Bank

    @@users = [
            User.new("Ali", 200),
            User.new("Peter", 500),
            User.new("Manda", 100)
        ]
    def self.users
        @@users.map(&:name)
    end

    def self.process_transactions(transactions, &block)
        summary  = transactions.map { |transaction| "#{transaction.user.name} transaction with value #{transaction.value}" }.join(", ")
        Logger.log_info(nil,nil,nil,"Processing Transactions #{summary}")
        transactions.each do |transaction|
            user_name = transaction.user.name
            transaction_value = transaction.value

        if users.include?(user_name)
            user = @@users.find { |u| u.name == user_name}
            if user.balance >= transaction_value.abs
                user.balance -= transaction_value.abs
                Logger.log_info(user_name, transaction_value) 
                yield(user_name, transaction_value, :success) if block_given? 
                Logger.log_warning("#{user_name} has 0 balance") 
            else
                Logger.log_error("#{user_name} transaction with value #{transaction_value} failed with reason: not enough balance")
                yield(user_name, transaction_value, :failure, "Not enough balance") if block_given?
        end
        else 
            Logger.log_error(user_name, transaction_value, "User does not exist in the bank") 
            yield(user_name, transaction_value, :failure, "User does not exist in the bank") if block_given? 
        end
    end

    end

end



transactions = [
  Transaction.new(User.new("Ali", 100), 10),
  Transaction.new(User.new("John", 50), 20),
  Transaction.new(User.new("Ali", 100), 300) 
]

CBABank.process_transactions(transactions) do |user_name, transaction_value, status, reason|
    if status == :success
        puts "Call endpoint for success of user #{user_name} transaction with value #{transaction_value}"
    else 
        puts "Call endpoint for failure of user #{user_name} transaction with value #{transaction_value} with reason: #{reason}"
    end
end


