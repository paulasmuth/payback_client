require 'test/payback_test_data'
require 'lib/payback_client'

describe PaybackClient do
  
  before :each do
    @payback_card = PAYBACK_TEST_CARDS[0]
    @payback_client = PaybackClient.new(PAYBACK_PARTNER_ID, PAYBACK_BRANCH_ID)
  end
  
  it "should check the current balance" do
    points_on_card = @payback_client.check_card_for_redemption(@payback_card[:card_number])
    points_on_card.should be_a(Hash)
    points_on_card.length.should == 3
    points_on_card.should have_key(:balance)
    points_on_card.should have_key(:available)
    points_on_card.should have_key(:available_for_next_redemption)
    points_on_card[:balance].should be_a(Integer)
    points_on_card[:balance].should > 0
  end
  
  it "should redeem 2 points and the current balance should change by 2 points" do
    transaction_id = rand(99999999999)
    
    points_on_card_before_redeem = @payback_client.check_card_for_redemption(@payback_card[:card_number])
    balance_before_redeem = points_on_card_before_redeem[:balance]
    
    @payback_client.authenticate_alternate_and_redeem(@payback_card[:card_number], 2, transaction_id, @payback_card[:zip], @payback_card[:dob])
    
    points_on_card_after_redeem = @payback_client.check_card_for_redemption(@payback_card[:card_number])
    balance_after_redeem = points_on_card_after_redeem[:balance]
    
    balance_after_redeem.should == balance_before_redeem - 2
  end
  
end
