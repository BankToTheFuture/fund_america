module FundAmerica
  class Investment
    class << self

      # End point: https://apps.fundamerica.com/api/investments (GET)
      # Usage: FundAmerica::Investment.list
      # Output: Returns list of investments
      def list
        API::request(:get, 'investments')
      end

      # End point: https://apps.fundamerica.com/api/investments (POST)
      # Usage: FundAmerica::Investment.create(options)
      # Output: Creates a new investment
      def create(options)
        API::request(:post, 'investments', options)
      end

      # End point: https://apps.fundamerica.com/api/investments/:id (PATCH)
      # Usage: FundAmerica::Investment.update(investment_id, options)
      # Output: Updates an investment
      def update(investment_id, options)
        base_uri = FundAmerica.mode == 'sandbox' ? "#{FundAmerica.base_uri}test_mode/" : ''
        end_point_url = base_uri + "investments/#{investment_id}"
        API::request(:patch, end_point_url, options)
      end

      # End point: https://apps.fundamerica.com/api/investments/:id (GET)
      # Usage: FundAmerica::Investment.details(investment_id)
      # Output: Returns the details of an investment with matching id
      def details(investment_id)
        API::request(:get, "investments/#{investment_id}")
      end

      # End point: https://apps.fundamerica.com/api/investments/:id (DELETE)
      # Usage: FundAmerica::Investment.delete(investment_id)
      # Output: Deletes an investment with matching id
      def delete(investment_id)
        API::request(:delete, "investments/#{investment_id}")
      end

      # End point: https://apps.fundamerica.com/api/investments/:id/billing_logs (GET)
      # Usage: FundAmerica::Investment.billing_logs(investment_id)
      # Output: Returns billing logs of an investment with matching id
      def billing_logs(investment_id)
        API::request(:get, "investments/#{investment_id}/billing_logs")
      end

      # End point: https://apps.fundamerica.com/api/investments/:id/investment_payments (GET)
      # Usage: FundAmerica::Investment.investment_payments(investment_id)
      # Output: Returns investment_payments of an investment with matching id
      def investment_payments(investment_id)
        API::request(:get, "investments/#{investment_id}/investment_payments")
      end

    end
  end
end
