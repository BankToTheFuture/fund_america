require 'spec_helper'

describe FundAmerica::Entity, :vcr do
  context '#list' do
    let(:response) { described_class.list }

    it 'returns entities list' do
      expect(response['object']).to eq 'resource_list'
      expect(response['total_resources']).to be > 1
      expect(response['resources'].first['object']).to eq 'entity'
    end
  end

  context '#details' do
    let(:entity_id) { 'Yl5VNP19TuyK3sJHsHDNIg' }
    let(:response) { described_class.details(entity_id) }

    it 'returns entity details' do
      expect(response['object']).to eq 'entity'
      expect(response['id']).to eq entity_id
    end
  end

  context '#create' do
    let(:response) { described_class.create(params) }

    context 'when valid params' do
      let(:params) { entity_params }

      it 'returns created entity' do
        expect(response['object']).to eq 'entity'
        expect(response['id']).not_to be_empty
      end
    end

    context 'when invalid params' do
      let(:params) { {} }

      it 'raises error' do
        error = /invalid parameters/
        expect { response }.to raise_error(FundAmerica::Error, error)
      end
    end
  end

  context '#delete' do
    let(:response) { described_class.delete(entity['id']) }

    context 'when entity exists' do
      let(:entity) { create_entity }

      # Comment from docs
      # The delete option from sandbox mode gives the error message
      # FundAmerica::Error: Not authorized.
      # You don't have permission to take action on a particular resource.
      # It may not be owned by your account or it may be in a state
      # where you action cannot be taken (such as attempting to cancel an invested investment)
      # This request has to be tested with production mode in final testing phase
      xit 'returns deleted entity' do
        expect(response['id']).to eq entity['id']
      end
    end

    context 'when entity does not exists' do
      let(:entity) { { 'id' => 'abc' } }

      it 'raises error' do
        error = /Resource was not found/
        expect { response }.to raise_error(FundAmerica::Error, error)
      end
    end
  end

  context '#update' do
    let(:entity) { create_entity }
    let(:params) { { city: 'New York' } }
    let(:response) { described_class.update(entity['id'], params) }

    context 'when entity exists and params are valid' do
      # TODO unable to test in sandbox mode
      xit 'returns updated entity' do
        expect(response['id']).to eq entity['id']
        expect(response['city']).to eq params[:city]
      end
    end

    context 'when entity does not exists' do
      let(:entity) { { 'id' => 'abc' } }

      it 'raises error' do
        error = /Resource was not found/
        expect { response }.to raise_error(FundAmerica::Error, error)
      end
    end
  end
end
