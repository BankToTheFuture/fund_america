module FabricatorsHelper
  def create_investment
    FundAmerica::Investment.create(investment_params)
  end

  def create_investor
    entity = create_entity
    FundAmerica::Investor.create(primary_entity_id: entity['id'])
  end

  def create_entity
    FundAmerica::Entity.create(entity_params)
  end

  def create_entity_document(entity = nil)
    FundAmerica::EntityDocument.create(entity_document_params(entity))
  end

  def investment_params
    {
      amount: '5000',
      entity: entity_params,
      equity_share_count: '10',
      offering_id: 'AflShkTFRm6neTWJe6UXcA',
      payment_method: 'wire'
    }
  end

  def entity_params
    {
      city: 'Las Vegas',
      country: 'US',
      date_of_birth: '1980-01-01',
      email: "investor#{current_time}@test.com",
      name: "Investor #{current_time}",
      phone: '17025551212',
      postal_code: '89123',
      region: 'NV',
      street_address_1: '555 Some St',
      tax_id_number: '000000000'
    }
  end

  def entity_document_params(entity = nil)
    {
      content_type: 'application/pdf',
      entity_id: (entity || create_entity)['id'],
      purpose: 'kyc',
      title: 'Important document',
      file: File.open(File.join(File.dirname(__FILE__), 'example_document.pdf'))
    }
  end

  def ach_authorization_params
    {
      account_number: '0000123456789',
      account_type: 'checking',
      address: '555 Somewhere in Manhattan',
      check_type: 'personal',
      city: 'New York',
      email: 'john.investor@example.com',
      entity_id: 'Ar9FLNbPRcegQsgX0YgIKg',
      ip_address: '127.0.0.1',
      literal: 'John Q Investor',
      name_on_account: 'John Q Investor',
      routing_number: '122287251',
      state: 'NY',
      user_agent: 'No Name Browser 1.0',
      zip_code: '10004'
    }
  end

  def current_time
    @current_time ||= Time.now.to_i
  end
end
