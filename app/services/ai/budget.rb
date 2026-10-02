module Ai
  # A monthly ceiling on recorded AI spend (AI_MONTHLY_BUDGET_USD, default
  # $10). New requests are refused once it's reached; a request already
  # running can still finish, so a month can end slightly over.
  module Budget
    def self.limit_usd
      ENV.fetch("AI_MONTHLY_BUDGET_USD", "10").to_d
    end

    def self.spent_usd
      AiRequest.this_month.sum(:cost_usd)
    end

    def self.remaining_usd
      [ limit_usd - spent_usd, 0 ].max
    end

    def self.exceeded?
      spent_usd >= limit_usd
    end

    def self.check!
      raise BudgetExceeded, "This month's AI budget ($#{'%.2f' % limit_usd}) is used up." if exceeded?
    end
  end
end
