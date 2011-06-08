# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
module  Models::Account
  module Base
    
    def self.included(base)
      base.send(:extend, InstanceMethods)
      base.set_account_settings
      base.send(:include, ClassMethods)
    end

    module InstanceMethods
      def set_account_settings
        before_save :select_account_type

        has_one :account, :as => :accountable, :autosave => true
        attr_readonly :initial_amount
      end
    end

    module ClassMethods

      def create_account_ledger
      end
      private

      # Selects the methods neccessary accordiny the class
      def select_account_type

        case self.class.to_s
          when "Bank", "Cash" then self.extend Models::Account::MoneyAccount
        end

        create_new_account
      end
    end
  end
end