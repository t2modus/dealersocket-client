# frozen_string_literal: true

require 'test_helper'

module BaseHelper
  def test_model_has_attributes_and_approved_attributes
    assert @model.attributes
    @model.class::APPROVED_ATTRIBUTES.each do |attr|
      assert @model.send(attr)
    end
  end
end
