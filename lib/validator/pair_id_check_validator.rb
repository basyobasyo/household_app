class PairIdCheckValidator < ActiveModel::EachValidator
  # ペアユーザーのバリデーション
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid) unless User.exists?(id: value) # ペア対象のユーザーが存在するかどうかの条件式
  end
  # //ペアユーザーのバリデーション
end
