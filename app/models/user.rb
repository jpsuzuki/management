class User < ApplicationRecord
    validates :name, presence: true, length: { maximum: 20 }
    VALID_NUMBER_REGEX = /\A[0-9][0-9][0-9][0-9]\z/
    validates :number, presence: true, length: { is: 4 },
                format: {with: VALID_NUMBER_REGEX},
                uniqueness: true
end
