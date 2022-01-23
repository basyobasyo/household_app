class PairIdCheckValidator < ActiveModel::EachValidator

  # ペアユーザーのバリデーション
  def validate_each(record, attribute, value)
    unless User.exists?(id: value) #ペア対象のユーザーが存在するかどうかの条件式
      record.errors.add(attribute, :invalid)
    end
  end
  # //ペアユーザーのバリデーション

end